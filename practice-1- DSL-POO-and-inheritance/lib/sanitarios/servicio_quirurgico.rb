module Sanitarios
  class ServicioQuirurgico

    attr_reader :id, :nombre, :quirofanos, :personal, :tipo

    @@contador_personal = 0
    @@contador_quirofanos = 0

    def initialize(id, nombre, quirofanos = [], personal = [])
      if id.class != Integer 
        raise ArgumentError, "ID must be an integer."
      end
      @id = id

      if nombre.class != String
        raise ArgumentError, "Name must be a string."
      end
      @nombre = nombre

      temp_quirofanos = Array(quirofanos)
      if temp_quirofanos[0] == nil
        raise ArgumentError, "Operating rooms list cannot be empty."
      end
      @quirofanos = temp_quirofanos
      
      temp_personal = Array(personal)
      if temp_personal[0] == nil
        raise ArgumentError, "Staff list cannot be empty."
      end
      @personal = temp_personal

      @tipo = Sanitarios::GruposServicios::QUIRURGICA

      @@contador_personal += personal.length
      @@contador_quirofanos += quirofanos.length
    end

    def self.count_personal 
      @@contador_personal
    end

    def self.count_quirofanos
      @@contador_quirofanos
    end

    def id=(nuevo_id)
      if nuevo_id.class != Integer 
        raise ArgumentError, "ID must be an integer."
      end
      @id = nuevo_id
    end
    
    def nombre=(nuevo_nombre)
      if nuevo_nombre.class != String
        raise ArgumentError, "Name must be a string."
      end
      @nombre = nuevo_nombre
    end
    
    def quirofanos=(nuevos_quirofanos)
      temp_quirofanos = Array(nuevos_quirofanos)
      if temp_quirofanos[0] == nil
        raise ArgumentError, "Operating rooms list cannot be empty."
      end
      @quirofanos = temp_quirofanos
    end

    def personal=(nuevo_personal)
      temp_personal = Array(nuevo_personal)
      if temp_personal[0] == nil
        raise ArgumentError, "Staff list cannot be empty."
      end
      @personal = temp_personal
    end

    def to_s
      quirofanos_str = _join_elements(@quirofanos)
      personal_str = _join_elements(@personal)

      "Service: #{nombre} (ID: #{id})\n" +
      "  Care Type: #{tipo}\n" +
      "  Assigned Operating Rooms: #{quirofanos_str}\n" +
      "  Assigned Staff: #{personal_str}"
    end

    def ==(otro)
      if otro.class != ServicioQuirurgico
        return false
      end
      propiedades_iguales = (
        self.id == otro.id && 
        self.nombre == otro.nombre && 
        self.quirofanos == otro.quirofanos && 
        self.personal == otro.personal &&
        self.tipo == otro.tipo 
      )
      return propiedades_iguales
    end

    def _join_elements(array)
      result = ""
      i = 0
      if array[0] == nil 
        return result
      end
      while array[i] != nil
        result = result + array[i].to_s 
        if array[i+1] != nil
          result += ", "
        end
        i += 1
      end
      result
    end

    public :to_s, :==
    private :_join_elements, :personal=, :quirofanos=, :nombre=, :id=
  end
end