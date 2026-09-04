# frozen_string_literal: true

module Sanitarios
  # Class representing medical staff members
  class Personal
    include Comparable

    TURNOS = ["MAÑANA", "TARDE", "NOCHE"].freeze

    attr_reader :id, :nombre, :turno

    @@contador_personal = 0

    def initialize(id, nombre, turno)
      raise ArgumentError, "ID must be an Integer." unless id.is_a?(Integer)
      raise ArgumentError, "Name must be a String." unless nombre.is_a?(String)

      validar_turno!(turno)

      @id = id
      @nombre = nombre
      @turno = turno

      @@contador_personal += 1
    end

    def self.count_personal
      @@contador_personal
    end

    def id=(nuevo_id)
      raise ArgumentError, "ID must be an Integer." unless nuevo_id.is_a?(Integer)
      @id = nuevo_id
    end

    def nombre=(nuevo_nombre)
      raise ArgumentError, "Name must be a String." unless nuevo_nombre.is_a?(String)
      @nombre = nuevo_nombre
    end

    def turno=(nuevo_turno)
      validar_turno!(nuevo_turno)
      @turno = nuevo_turno
    end

    def to_s
      "Staff ID: #{id}\n" \
      "  Name: #{nombre}\n" \
      "  Shift: #{turno}"
    end

    def ==(otro)
      otro.is_a?(Personal) && id == otro.id && nombre == otro.nombre && turno == otro.turno
    end

    def <=>(other)
      return nil unless other.is_a?(Personal)
      nombre <=> other.nombre
    end

    public :==, :to_s, :<=>
    protected :nombre=, :id=, :turno=
    private

    def validar_turno!(turno_a_verificar)
      unless TURNOS.include?(turno_a_verificar)
        raise ArgumentError, "Invalid shift. Must be one of: #{TURNOS.join(', ')}"
      end
    end
  end

  # Specialized Surgeon class
  class Cirujano < Personal
    ESPECIALIDADES_VALIDAS_CIRUJANO = ["cirugia general", "neurocirugia", "cirugia plastica"].freeze

    attr_reader :especialidad

    def initialize(id, nombre, turno, especialidad)
      super(id, nombre, turno)
      validar_especialidad!(especialidad)
      @especialidad = especialidad
    end

    def to_s
      "#{super}\n  Specialty: #{especialidad}"
    end

    def ==(otro)
      otro.is_a?(Cirujano) && super(otro) && especialidad == otro.especialidad
    end

    public :to_s, :==
    private

    def especialidad=(nueva_especialidad)
      validar_especialidad!(nueva_especialidad)
      @especialidad = nueva_especialidad
    end

    def validar_especialidad!(especialidad_a_verificar)
      unless ESPECIALIDADES_VALIDAS_CIRUJANO.include?(especialidad_a_verificar)
        raise ArgumentError, "Invalid specialty. Must be one of: #{ESPECIALIDADES_VALIDAS_CIRUJANO.join(', ')}"
      end
    end
  end

  # Specialized Anesthesiologist class
  class Anestesiologo < Personal
    ESPECIALIDADES_VALIDAS_ANESTESIOLOGO = ["cardiovascular", "obstetrica", "neuroquirúrgica"].freeze

    attr_reader :especialidad

    def initialize(id, nombre, turno, especialidad)
      super(id, nombre, turno)
      validar_especialidad!(especialidad)
      @especialidad = especialidad
    end

    def to_s
      "#{super}\n  Specialty: #{especialidad}"
    end

    def ==(otro)
      otro.is_a?(Anestesiologo) && super(otro) && especialidad == otro.especialidad
    end

    public :==, :to_s
    private

    def especialidad=(nueva_especialidad)
      validar_especialidad!(nueva_especialidad)
      @especialidad = nueva_especialidad
    end

    def validar_especialidad!(especialidad_a_verificar)
      unless ESPECIALIDADES_VALIDAS_ANESTESIOLOGO.include?(especialidad_a_verificar)
        raise ArgumentError, "Invalid specialty. Must be one of: #{ESPECIALIDADES_VALIDAS_ANESTESIOLOGO.join(', ')}"
      end
    end
  end

  # Specialized Surgical Assistant class
  class Asistente < Personal
    ESPECIALIDADES_VALIDAS_ASISTENTE = ["primer asistente quirurgico", "tecnologo quirurgico", "enfermero anestesista"].freeze

    attr_reader :especialidad

    def initialize(id, nombre, turno, especialidad)
      super(id, nombre, turno)
      validar_especialidad!(especialidad)
      @especialidad = especialidad
    end

    def to_s
      "#{super}\n  Specialty: #{especialidad}"
    end

    def ==(otro)
      otro.is_a?(Asistente) && super(otro) && especialidad == otro.especialidad
    end

    public :==, :to_s
    private

    def especialidad=(nueva_especialidad)
      validar_especialidad!(nueva_especialidad)
      @especialidad = nueva_especialidad
    end

    def validar_especialidad!(especialidad_a_verificar)
      unless ESPECIALIDADES_VALIDAS_ASISTENTE.include?(especialidad_a_verificar)
        raise ArgumentError, "Invalid specialty. Must be one of: #{ESPECIALIDADES_VALIDAS_ASISTENTE.join(', ')}"
      end
    end
  end

  # Class representing other support roles
  class Otros < Personal
    ESPECIALIDADES_VALIDAS_OTROS = ["enfermero cirulante", "residente", "estudiante"].freeze

    attr_reader :especialidad

    def initialize(id, nombre, turno, especialidad)
      super(id, nombre, turno)
      validar_especialidad!(especialidad)
      @especialidad = especialidad
    end

    def to_s
      "#{super}\n  Specialty: #{especialidad}"
    end

    def ==(otro)
      otro.is_a?(Otros) && super(otro) && especialidad == otro.especialidad
    end

    public :==, :to_s
    private

    def especialidad=(nueva_especialidad)
      validar_especialidad!(nueva_especialidad)
      @especialidad = nueva_especialidad
    end

    def validar_especialidad!(especialidad_a_verificar)
      unless ESPECIALIDADES_VALIDAS_OTROS.include?(especialidad_a_verificar)
        raise ArgumentError, "Invalid specialty. Must be one of: #{ESPECIALIDADES_VALIDAS_OTROS.join(', ')}"
      end
    end
  end
end