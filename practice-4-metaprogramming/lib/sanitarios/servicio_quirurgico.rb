# frozen_string_literal: true

module Sanitarios
  # Represents a general surgical service unit
  class ServicioQuirurgico
    include Comparable

    attr_reader :id, :nombre, :quirofanos, :personal, :tipo, :precio

    def initialize(id, nombre, quirofanos = [], personal = [], precio = 0)
      raise ArgumentError, "ID must be an Integer." unless id.is_a?(Integer)
      raise ArgumentError, "Name must be a String." unless nombre.is_a?(String)
      raise ArgumentError, "Price must be a Numeric value." unless precio.is_a?(Numeric)

      @id = id
      @nombre = nombre
      @quirofanos = Array(quirofanos).compact
      @personal = Array(personal).compact
      @tipo = Sanitarios::GruposServicios::QUIRURGICA
      @precio = precio
    end

    def id=(nuevo_id)
      raise ArgumentError, "ID must be an Integer." unless nuevo_id.is_a?(Integer)
      @id = nuevo_id
    end

    def nombre=(nuevo_nombre)
      raise ArgumentError, "Name must be a String." unless nuevo_nombre.is_a?(String)
      @nombre = nuevo_nombre
    end

    def quirofanos=(nuevos_quirofanos)
      temp = Array(nuevos_quirofanos).compact
      raise ArgumentError, "Operating room list cannot be empty." if temp.empty?
      @quirofanos = temp
    end

    def personal=(nuevo_personal)
      temp = Array(nuevo_personal).compact
      raise ArgumentError, "Staff list cannot be empty." if temp.empty?
      @personal = temp
    end

    def precio=(nuevo_precio)
      raise ArgumentError, "Price must be a Numeric value." unless nuevo_precio.is_a?(Numeric)
      @precio = nuevo_precio
    end

    def num_quirofanos
      @quirofanos.length
    end

    def num_personal
      @personal.length
    end

    def obtener_estados_individuales
      estados = []
      @quirofanos.each do |q|
        estados << "Status of OR ID #{q.id}: #{q.estado}"
      end
      estados
    end

    def total_personal_turno
      conteo = {}
      @personal.each do |persona|
        turno = persona.turno
        conteo[turno] = (conteo[turno] || 0) + 1
      end
      conteo
    end

    def coste_total
      @precio
    end

    def disponibilidad_personal_quirofano
      return 0.0 if @quirofanos.empty?
      num_personal.to_f / num_quirofanos
    end

    def indicador_costo_por_quirofano
      return 0.0 if @quirofanos.empty?
      @precio.to_f / num_quirofanos
    end

    def indicador_costo_por_personal
      return 0.0 if @personal.empty?
      @precio.to_f / num_personal
    end

    def to_s
      quirofanos_str = ""
      @quirofanos.each_with_index do |q, idx|
        quirofanos_str += q.id.to_s
        quirofanos_str += ", " if idx < @quirofanos.length - 1
      end

      personal_str = ""
      @personal.each_with_index do |p, idx|
        personal_str += p.nombre
        personal_str += ", " if idx < @personal.length - 1
      end

      "Service: #{nombre} (ID: #{id})\n" \
      "   Care Type: #{tipo}\n" \
      "   Assigned ORs: #{quirofanos_str}\n" \
      "   Assigned Staff: #{personal_str}\n" \
      "   Usage Price: #{@precio}"
    end

    def ==(otro)
      otro.is_a?(ServicioQuirurgico) &&
        id == otro.id &&
        nombre == otro.nombre &&
        quirofanos == otro.quirofanos &&
        personal == otro.personal &&
        tipo == otro.tipo &&
        precio == otro.precio
    end

    def <=>(other)
      return nil unless other.is_a?(ServicioQuirurgico)
      precio <=> other.precio
    end

    public :to_s, :==, :num_quirofanos, :num_personal, :obtener_estados_individuales,
           :total_personal_turno, :<=>, :coste_total, :indicador_costo_por_quirofano,
           :indicador_costo_por_personal, :personal=, :quirofanos=, :nombre=, :id=, :precio=
  end

  # Major Surgery Service Class
  class CirugiaMayor < ServicioQuirurgico
    EQUIPOS_REQUERIDOS = [
      "anestesia general",
      "monitores multiparametro",
      "equipos de reanimacion",
      "ventiladoresmecanicos"
    ].freeze

    attr_accessor :equipos_avanzados

    def initialize(id, nombre, quirofanos = [], personal = [], precio = 0)
      super(id, nombre, quirofanos, personal, precio)
      @equipos_avanzados = EQUIPOS_REQUERIDOS.dup
    end

    def coste_total
      coste_base = super
      coste_add = @equipos_avanzados.is_a?(Array) ? @equipos_avanzados.length * 150 : 0
      coste_base + coste_add
    end

    def to_s
      equipos_str = ""
      if @equipos_avanzados.is_a?(Array)
        @equipos_avanzados.each_with_index do |eq, idx|
          equipos_str += eq
          equipos_str += ", " if idx < @equipos_avanzados.length - 1
        end
      else
        equipos_str = @equipos_avanzados.to_s
      end

      "#{super}\n   Required Advanced Equipment: #{equipos_str}"
    end

    public :to_s, :coste_total, :precio
  end

  # Minor Surgery Service Class
  class CirugiaMenor < ServicioQuirurgico
    EQUIPOS_REQUERIDOS = ["anestesia local", "monitores simples"].freeze

    attr_accessor :equipo_simple

    def initialize(id, nombre, quirofanos = [], personal = [], precio = 0)
      super(id, nombre, quirofanos, personal, precio)
      @equipo_simple = EQUIPOS_REQUERIDOS.dup
    end

    def coste_total
      coste_base = super
      coste_add = @equipo_simple.is_a?(Array) ? @equipo_simple.length * 45 : 0
      coste_base + coste_add
    end

    def to_s
      equipos_str = ""
      if @equipo_simple.is_a?(Array)
        @equipo_simple.each_with_index do |eq, idx|
          equipos_str += eq
          equipos_str += ", " if idx < @equipo_simple.length - 1
        end
      else
        equipos_str = @equipo_simple.to_s
      end

      "#{super}\n   Required Basic Equipment: #{equipos_str}"
    end

    public :to_s, :coste_total, :precio
  end
end