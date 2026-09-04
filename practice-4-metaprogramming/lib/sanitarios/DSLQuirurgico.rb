# frozen_string_literal: true

module Sanitarios
  # Domain Specific Language builder for Surgical Units
  class DSLQuirurgico
    ESPECIALIDAD_A_CLASE = {
      "cirugia general"             => "Cirujano",
      "cirugia plastica"            => "Cirujano",
      "neurocirugia"                => "Cirujano",

      "cardiovascular"              => "Anestesiologo",
      "obstetrica"                  => "Anestesiologo",
      "neuroquirúrgica"             => "Anestesiologo",

      "tecnologo quirurgico"        => "Asistente",
      "primer asistente quirurgico" => "Asistente",
      "enfermero anestesista"       => "Asistente",

      "estudiante"                  => "Otros",
      "enfermero cirulante"         => "Otros",
      "residente"                   => "Otros"
    }.freeze

    QUIROFANO_TIPOS_A_CLASE = {
      "Clase A" => "Funcional",
      "Clase B" => "Funcional",
      "Clase C" => "Funcional",
      "ISO 5"   => "Bioseguridad",
      "ISO 6"   => "Bioseguridad",
      "ISO 7"   => "Bioseguridad"
    }.freeze

    attr_reader :servicio
    attr_accessor :equipamiento_config

    def initialize(id, &block)
      @servicio = Sanitarios::ServicioQuirurgico.new(id, "", [], [], 0)
      @context = @servicio
      @equipamiento_config = {}
      instance_eval(&block) if block_given?
    end

    def configuracion(args)
      unless args.is_a?(Hash) && args.key?(:tipo)
        raise ArgumentError, "Configuration must specify the surgery type (tipo: '...')."
      end

      tipo_valor = args[:tipo]
      if tipo_valor == "cirugia mayor"
        @servicio = Sanitarios::CirugiaMayor.new(@servicio.id, @servicio.nombre, @servicio.quirofanos, @servicio.personal, @servicio.precio)
      elsif tipo_valor == "cirugia menor"
        @servicio = Sanitarios::CirugiaMenor.new(@servicio.id, @servicio.nombre, @servicio.quirofanos, @servicio.personal, @servicio.precio)
      else
        raise ArgumentError, "Invalid surgery service type: #{tipo_valor}."
      end
      @context = @servicio

      if args.key?(:precio)
        precio_valor = args[:precio]
        unless precio_valor.is_a?(Numeric) && precio_valor >= 0
          raise ArgumentError, "Price must be a non-negative number."
        end
        @servicio.precio = precio_valor
      end
    end

    def equipamiento(&block)
      unless @servicio.is_a?(Sanitarios::CirugiaMayor) || @servicio.is_a?(Sanitarios::CirugiaMenor)
        raise ArgumentError, "Must define service 'tipo' before configuring equipment."
      end

      @equipamiento_config = {}
      contexto_anterior = @context
      @context = :equipamiento_config

      instance_eval(&block) if block_given?

      @context = contexto_anterior
      if @servicio.is_a?(Sanitarios::CirugiaMayor)
        @servicio.equipos_avanzados = @equipamiento_config
      elsif @servicio.is_a?(Sanitarios::CirugiaMenor)
        @servicio.equipo_simple = @equipamiento_config
      end
      @equipamiento_config = {}
    end

    def quirofano(id, args, &block)
      unless id.is_a?(Numeric) && args.is_a?(Hash) && args[:estado] && args[:tipo]
        raise ArgumentError, "Incorrect OR syntax. Expected: quirofano ID, estado: '...', tipo: '...'"
      end

      tipo_input = args[:tipo]
      estado_input = args[:estado].upcase
      nombre_clase = QUIROFANO_TIPOS_A_CLASE[tipo_input]

      raise ArgumentError, "Invalid OR type: #{tipo_input}." unless nombre_clase

      clase_quirofano = Sanitarios.const_get(nombre_clase)
      @personal_quirofano = []

      contexto_anterior = @context
      @context = :quirofano_config
      instance_eval(&block) if block_given?
      @context = contexto_anterior

      nuevo_quirofano = clase_quirofano.new(
        id,
        estado_input,
        @personal_quirofano,
        tipo_input
      )
      @servicio.quirofanos << nuevo_quirofano
      @personal_quirofano = nil
    end

    def personal(id, args)
      unless id.is_a?(Numeric) && args.is_a?(Hash) && args[:nombre] && args[:turno] && args[:especialidad]
        raise ArgumentError, "Incorrect staff syntax. Expected: personal ID, nombre: '...', turno: '...', especialidad: '...'"
      end

      especialidad = args[:especialidad].downcase
      nombre_clase = ESPECIALIDAD_A_CLASE[especialidad]

      unless nombre_clase
        raise ArgumentError, "Unknown staff specialty: #{especialidad}."
      end

      clase_personal = Sanitarios.const_get(nombre_clase)
      nuevo_personal = clase_personal.new(
        id,
        args[:nombre],
        args[:turno].upcase,
        especialidad
      )

      @personal_quirofano << nuevo_personal if @context == :quirofano_config
      @servicio.personal << nuevo_personal
    end

    def method_missing(method_name, *args, &block)
      if @context == :equipamiento_config && args.length == 1
        equipamiento_key = method_name.to_s.tr('_', ' ')
        @equipamiento_config[equipamiento_key] = args[0].to_i
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @context == :equipamiento_config || super
    end

    def to_s
      output = "Surgical Service: Surgical Unit LPP\n"
      output << "=====================================================\n\n"
      output << "Type: #{@servicio.is_a?(Sanitarios::CirugiaMayor) ? 'Major Surgery' : 'Minor Surgery'}\n"
      output << "Price: #{@servicio.precio}\n\n"
      output << "Equipment:\n"

      equipos = @servicio.is_a?(Sanitarios::CirugiaMayor) ? @servicio.equipos_avanzados : @servicio.equipo_simple

      if equipos.nil? || equipos.empty?
        output << " - No equipment configured.\n"
      elsif equipos.is_a?(Hash)
        equipos.each do |item, num|
          output << " - #{item.capitalize}: #{num}\n"
        end
      else
        equipos.each do |item|
          output << " - #{item.capitalize}\n"
        end
      end

      output << "\nRooms:\n"
      @servicio.quirofanos.each do |q|
        tipo = q.respond_to?(:clase) ? q.clase : q.iso
        output << " - Operating Room #{q.id}, status: #{q.estado.downcase}, type: #{tipo}"
        if q.equipo_medico.any?
          nombres = q.equipo_medico.map(&:nombre).join(", ")
          output << ", team: (#{nombres})"
        end
        output << "\n"
      end

      output << "\nStaff:\n"
      orden_clases = ["Cirujano", "Anestesiologo", "Asistente", "Otros"]
      personal_agrupado = orden_clases.each_with_object({}) { |c, h| h[c] = [] }

      @servicio.personal.each do |p|
        clase_p = p.class.name.split('::').last
        if personal_agrupado.key?(clase_p)
          personal_agrupado[clase_p] << p
        else
          personal_agrupado["Otros"] << p
        end
      end

      orden_clases.each do |clase|
        personal_agrupado[clase].each do |p|
          output << " - #{clase} #{p.id}, name: #{p.nombre}, shift: #{p.turno.downcase}, specialty: #{p.especialidad.downcase}\n"
        end
      end

      output
    end
  end
end