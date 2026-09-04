# frozen_string_literal: true

module Sanitarios
  # Base class representing Operating Rooms
  class Quirofano
    include Comparable

    ESTADOS_PERMITIDOS = ["DISPONIBLE", "ESPERANDO", "OCUPADO"].freeze

    attr_reader :id, :estado, :equipo_medico

    @@contador_quirofanos = 0

    def initialize(id, estado, equipo_medico)
      raise ArgumentError, "ID must be an Integer." unless id.is_a?(Integer)

      validar_estado!(estado)

      temp_equipo = Array(equipo_medico).compact
      raise ArgumentError, "Medical team list cannot be empty." if temp_equipo.empty?

      validar_equipo_completo!(temp_equipo)

      @id = id
      @estado = estado
      @equipo_medico = temp_equipo

      @@contador_quirofanos += 1
    end

    def self.count_quirofanos
      @@contador_quirofanos
    end

    def id=(nuevo_id)
      raise ArgumentError, "ID must be an Integer." unless nuevo_id.is_a?(Integer)
      @id = nuevo_id
    end

    def estado=(nuevo_estado)
      validar_estado!(nuevo_estado)
      @estado = nuevo_estado
    end

    def equipo_medico=(nuevo_equipo)
      temp_equipo = Array(nuevo_equipo).compact
      raise ArgumentError, "Medical team list cannot be empty." if temp_equipo.empty?
      validar_equipo_completo!(temp_equipo)
      @equipo_medico = temp_equipo
    end

    def nuevo_equipo_medico!(equipo)
      self.equipo_medico = equipo
    end

    def to_s
      "Operating Room ID: #{id}\n" \
      "  Status: #{estado}\n" \
      "  Medical Team: #{_join_elements(equipo_medico)}"
    end

    def ==(otro)
      otro.is_a?(Quirofano) && id == otro.id && estado == otro.estado && equipo_medico == otro.equipo_medico
    end

    def <=>(other)
      return nil unless other.is_a?(Quirofano)
      equipo_medico.length <=> other.equipo_medico.length
    end

    public :==, :to_s, :<=>, :nuevo_equipo_medico!
    protected :equipo_medico=, :estado=, :id=
    private

    def _join_elements(array)
      result = ""
      array.each_with_index do |element, index|
        result += element.to_s
        result += ", " if index < array.length - 1
      end
      result
    end

    def validar_estado!(estado_a_verificar)
      unless ESTADOS_PERMITIDOS.include?(estado_a_verificar)
        raise ArgumentError, "Invalid status. Must be one of: #{ESTADOS_PERMITIDOS.join(', ')}"
      end
    end

    def validar_equipo_completo!(equipo)
      has_cirujano = false
      has_asistente = false
      has_anestesiologo = false

      equipo.each do |miembro|
        has_cirujano = true if miembro.is_a?(Sanitarios::Cirujano)
        has_asistente = true if miembro.is_a?(Sanitarios::Asistente)
        has_anestesiologo = true if miembro.is_a?(Sanitarios::Anestesiologo)
      end

      unless has_cirujano && has_asistente && has_anestesiologo
        raise ArgumentError, "The medical team must include at least one Surgeon, one Assistant, and one Anesthesiologist."
      end
    end
  end

  # Functional operating rooms classified by operational tier
  class Funcional < Quirofano
    ESTADOS_PERMITIDOS = ["Clase A", "Clase B", "Clase C"].freeze

    attr_reader :clase

    def initialize(id, estado, equipo_medico, clase)
      super(id, estado, equipo_medico)
      validar_clase!(clase)
      @clase = clase
    end

    def to_s
      "#{super}\n  Functional Class: #{clase}"
    end

    def ==(otro)
      otro.is_a?(Funcional) && super(otro) && clase == otro.clase
    end

    public :to_s, :==
    private

    def clase=(nueva_clase)
      validar_clase!(nueva_clase)
      @clase = nueva_clase
    end

    def validar_clase!(clase_a_verificar)
      unless ESTADOS_PERMITIDOS.include?(clase_a_verificar)
        raise ArgumentError, "Invalid functional class. Must be one of: #{ESTADOS_PERMITIDOS.join(', ')}"
      end
    end
  end

  # Biosecurity operating rooms classified by ISO air purity standards
  class Bioseguridad < Quirofano
    ISO_PERMITIDOS = ["ISO 5", "ISO 6", "ISO 7"].freeze

    attr_reader :iso

    def initialize(id, estado, equipo_medico, iso)
      super(id, estado, equipo_medico)
      validar_iso!(iso)
      @iso = iso
    end

    def to_s
      "#{super}\n  ISO Type: #{iso}"
    end

    def ==(otro)
      otro.is_a?(Bioseguridad) && super(otro) && iso == otro.iso
    end

    public :==, :to_s
    private

    def iso=(nuevo_iso)
      validar_iso!(nuevo_iso)
      @iso = nuevo_iso
    end

    def validar_iso!(iso_a_verificar)
      unless ISO_PERMITIDOS.include?(iso_a_verificar)
        raise ArgumentError, "Invalid ISO certification. Must be one of: #{ISO_PERMITIDOS.join(', ')}"
      end
    end
  end
end