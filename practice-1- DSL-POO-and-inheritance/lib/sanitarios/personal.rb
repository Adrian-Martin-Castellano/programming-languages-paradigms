module Sanitarios
  class Personal

    TURNOS = ["MORNING", "AFTERNOON", "NIGHT"]

    attr_reader :id, :nombre, :turno

    def initialize(id, nombre, turno)
      if id.class != Integer 
        raise ArgumentError, "ID must be an integer."
      end
      @id = id

      if nombre.class != String
        raise ArgumentError, "Name must be a string."
      end
      @nombre = nombre

      validar_turno!(turno)
      @turno = turno
    end

    def validar_turno!(turno_a_verificar)
      encontrado = false
      for turno_permitido in TURNOS
        if turno_permitido == turno_a_verificar
          encontrado = true
          break 
        end
      end

      unless encontrado
        raise ArgumentError, "Invalid shift. Must be one of: #{_join_elements(TURNOS)}"
      end
    end

    def id=(nuevo_id)
      if nuevo_id.class != Integer 
        raise ArgumentError, "ID must be an integer."
      end
      @id = nuevo_id
    end

    def turno=(nuevo_turno)
      validar_turno!(nuevo_turno)
      @turno = nuevo_turno
    end

    def nombre=(nuevo_nombre)
      if nuevo_nombre.class != String
        raise ArgumentError, "Name must be a string."
      end
      @nombre = nuevo_nombre
    end

    def to_s
      "Operating Room ID: #{id}\n" +
      "  Name: #{nombre}\n" +
      "  Shift: #{turno}"
    end

    def ==(otro)
      if self.id == otro.id && self.nombre == otro.nombre && self.turno == otro.turno
        return true
      else
        return false
      end
    end

    def _join_elements(array)
      result = ""
      i = 0
      if array[0] == nil
        return result
      end
      while array[i] != nil
        result += array[i]
        if array[i+1] != nil
          result += ", "
        end
        i += 1
      end
      result
    end

    public :==, :to_s
    protected :nombre=, :id=, :turno=
    private :_join_elements, :validar_turno!
  end

  class Cirujano < Personal

    ESPECIALIDADES_VALIDAS_CIRUJANO = ["general surgery", "neurosurgery", "plastic surgery"]

    attr_reader :especialidad

    def initialize(id, nombre, turno, especialidad)
      super(id, nombre, turno)
      validar_especialidad!(especialidad)
      @especialidad = especialidad
    end

    def validar_especialidad!(especialidad_a_verificar)
      encontrado = false
      for especialidad_permitida in ESPECIALIDADES_VALIDAS_CIRUJANO
        if especialidad_permitida == especialidad_a_verificar
          encontrado = true
          break 
        end
      end

      unless encontrado
        raise ArgumentError, "Invalid specialty. Must be one of: #{_join_elements(ESPECIALIDADES_VALIDAS_CIRUJANO)}"
      end
    end

    def especialidad=(nueva_especialidad)
      validar_especialidad!(nueva_especialidad)
      @especialidad = nueva_especialidad
    end

    def to_s
      "#{super}\n" +
      "  Specialty: #{especialidad}"
    end

    def ==(otro)
      if otro.class != Cirujano
        return false
      end
      herencia_igual = super(otro) 
      propio_igual = (self.especialidad == otro.especialidad)
      return herencia_igual && propio_igual
    end

    public :to_s, :==
    private :especialidad=, :validar_especialidad!
  end

  class AnestESIOLOGO < Personal; end # Para mantener compatibilidad si aplica

  class Anestesiologo < Personal

    ESPECIALIDADES_VALIDAS_ANESTESIOLOGO = ["cardiovascular", "obstetric", "neurosurgical"]

    attr_reader :especialidad
    
    def initialize(id, nombre, turno, especialidad)
      super(id, nombre, turno)
      validar_especialidad!(especialidad)
      @especialidad = especialidad
    end

    def validar_especialidad!(especialidad_a_verificar)
      encontrado = false
      for especialidad_permitida in ESPECIALIDADES_VALIDAS_ANESTESIOLOGO
        if especialidad_permitida == especialidad_a_verificar
          encontrado = true
          break 
        end
      end

      unless encontrado
        raise ArgumentError, "Invalid specialty. Must be one of: #{_join_elements(ESPECIALIDADES_VALIDAS_ANESTESIOLOGO)}"
      end
    end

    def especialidad=(nueva_especialidad)
      validar_especialidad!(nueva_especialidad)
      @especialidad = nueva_especialidad
    end

    def to_s
      "#{super}\n" +
      "  Specialty: #{especialidad}"
    end

    def ==(otro)
      if otro.class != Anestesiologo
        return false
      end
      herencia_igual = super(otro) 
      propio_igual = (self.especialidad == otro.especialidad)
      return herencia_igual && propio_igual
    end

    public :==, :to_s
    private :especialidad=, :validar_especialidad!
  end

  class Asistente < Personal

    ESPECIALIDADES_VALIDAS_ASISTENTE = ["first surgical assistant", "surgical technologist", "nurse anesthetist"]

    attr_reader :especialidad

    def initialize(id, nombre, turno, especialidad)
      super(id, nombre, turno)
      validar_especialidad!(especialidad)
      @especialidad = especialidad
    end

    def validar_especialidad!(especialidad_a_verificar)
      encontrado = false
      for especialidad_permitida in ESPECIALIDADES_VALIDAS_ASISTENTE
        if especialidad_permitida == especialidad_a_verificar
          encontrado = true
          break 
        end
      end

      unless encontrado
        raise ArgumentError, "Invalid specialty. Must be one of: #{_join_elements(ESPECIALIDADES_VALIDAS_ASISTENTE)}"
      end
    end

    def especialidad=(nueva_especialidad)
      validar_especialidad!(nueva_especialidad)
      @especialidad = nueva_especialidad
    end

    def to_s
      "#{super}\n" +
      "  Specialty: #{especialidad}"
    end

    def ==(otro)
      if otro.class != Asistente
        return false
      end
      herencia_igual = super(otro) 
      propio_igual = (self.especialidad == otro.especialidad)
      return herencia_igual && propio_igual
    end

    public :==, :to_s
    private :especialidad=, :validar_especialidad!
  end

  class Otros < Personal

    ESPECIALIDADES_VALIDAS_OTROS = ["circulating nurse", "resident", "student"]

    attr_reader :otro_especialidad

    def initialize(id, nombre, turno, otro_especialidad)
      super(id, nombre, turno)
      validar_otro_especialidad!(otro_especialidad)
      @otro_especialidad = otro_especialidad
    end

    def validar_otro_especialidad!(especialidad_a_verificar)
      encontrado = false
      for especialidad_permitida in ESPECIALIDADES_VALIDAS_OTROS
        if especialidad_permitida == especialidad_a_verificar
          encontrado = true
          break 
        end
      end

      unless encontrado
        raise ArgumentError, "Invalid specialty. Must be one of: #{_join_elements(ESPECIALIDADES_VALIDAS_OTROS)}"
      end
    end

    def otro_especialidad=(nueva_especialidad)
      validar_otro_especialidad!(nueva_especialidad)
      @otro_especialidad = nueva_especialidad
    end

    def to_s
      "#{super}\n" +
      "  Specialty: #{otro_especialidad}"
    end

    def ==(otro)
      if otro.class != Otros
        return false
      end
      herencia_igual = super(otro) 
      propio_igual = (self.otro_especialidad == otro.otro_especialidad)
      return herencia_igual && propio_igual
    end

    public :==, :to_s
    private :otro_especialidad=, :validar_otro_especialidad!
  end
end