module Sanitarios
  class Quirofano

    ESTADOS_PERMITIDOS = ["AVAILABLE", "WAITING", "OCCUPIED"]

    attr_reader :id, :estado, :equipo_medico

    def initialize(id, estado, equipo_medico)
      if id.class != Integer 
        raise ArgumentError, "ID must be an integer."
      end
      @id = id

      validar_estado!(estado)
      @estado = estado

      temp_equipo_medico = Array(equipo_medico)
      if temp_equipo_medico[0] == nil
        raise ArgumentError, "Medical team list cannot be empty."
      end
      @equipo_medico = temp_equipo_medico
    end

    def validar_estado!(estado_a_verificar)
      encontrado = false
      for estado_permitido in ESTADOS_PERMITIDOS
        if estado_permitido == estado_a_verificar
          encontrado = true
          break 
        end
      end

      unless encontrado
        raise ArgumentError, "Invalid status. Must be one of: #{_join_elements(ESTADOS_PERMITIDOS)}"
      end
    end

    def id=(nuevo_id)
      if nuevo_id.class != Integer 
        raise ArgumentError, "ID must be an integer."
      end
      @id = nuevo_id
    end

    def estado=(nuevo_estado)
      validar_estado!(nuevo_estado)
      @estado = nuevo_estado
    end

    def equipo_medico=(nuevo_equipo)
      temp_equipo_medico = Array(nuevo_equipo)
      if temp_equipo_medico.empty? || temp_equipo_medico[0] == nil
        raise ArgumentError, "Medical team list cannot be empty."
      end
      @equipo_medico = temp_equipo_medico
    end

    def to_s
      "Operating Room ID: #{id}\n" +
      "  Status: #{estado}\n" +
      "  Medical Team: #{_join_elements(@equipo_medico)}"
    end

    def ==(otro)
      if self.id == otro.id && self.estado == otro.estado && self.equipo_medico == otro.equipo_medico
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
        result += array[i].to_s 
        if array[i+1] != nil
          result += ", "
        end
        i += 1
      end
      result
    end

    public :==, :to_s
    protected :equipo_medico=, :estado=, :id=
    private :_join_elements, :validar_estado!
  end

  class Funcional < Quirofano

    ESTADOS_PERMITIDOS = ["Class A", "Class B", "Class C"]

    attr_reader :clase

    def initialize(id, estado, equipo_medico, clase)
      super(id, estado, equipo_medico)

      validar_clase!(clase)
      @clase = clase
    end

    def validar_clase!(clase_a_verificar)
      encontrado = false
      for clase_permitida in ESTADOS_PERMITIDOS
        if clase_permitida == clase_a_verificar
          encontrado = true
          break 
        end
      end

      unless encontrado
        raise ArgumentError, "Invalid class. Must be one of: #{_join_elements(ESTADOS_PERMITIDOS)}"
      end
    end

    def clase=(nueva_clase)
      validar_clase!(nueva_clase)
      @clase = nueva_clase
    end

    def to_s
      "#{super}\n" +
      "  Functional Class: #{clase}"
    end

    def ==(otro)
      if otro.class != Funcional
        return false
      end
      herencia_igual = super(otro) 
      propio_igual = (self.clase == otro.clase)
      return herencia_igual && propio_igual
    end

    public :to_s, :==
    private :clase=, :validar_clase!
  end

  class Bioseguridad < Quirofano
    
    ISO_PERMITIDOS = ["ISO 5", "ISO 6", "ISO 7"]

    attr_reader :iso

    def initialize(id, estado, equipo_medico, iso)
      super(id, estado, equipo_medico)

      validar_iso!(iso)
      @iso = iso
    end

    def validar_iso!(iso_a_verificar)
      encontrado = false
      for iso_permitido in ISO_PERMITIDOS
        if iso_permitido == iso_a_verificar
          encontrado = true
          break 
        end
      end

      unless encontrado
        raise ArgumentError, "Invalid ISO level. Must be one of: #{_join_elements(ISO_PERMITIDOS)}"
      end
    end

    def iso=(nuevo_iso)
      validar_iso!(nuevo_iso)
      @iso = nuevo_iso
    end

    def to_s
      "#{super}\n" +
      "  ISO Type: #{iso}"
    end

    def ==(otro)
      if otro.class != Bioseguridad
        return false
      end
      herencia_igual = super(otro) 
      propio_igual = (self.iso == otro.iso)
      return herencia_igual && propio_igual
    end

    public :==, :to_s
    private :iso=, :validar_iso!
  end
end