module Sanitarios
  class ServicioQuirurgico

    include Comparable

    attr_reader :id, :nombre, :quirofanos, :personal, :tipo, :precio

    def initialize(id, nombre, quirofanos = [], personal = [], precio)
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

      if precio.class != Integer 
        raise ArgumentError, "Price must be an integer."
      end
      @precio = precio
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

    def precio=(nuevo_precio)
      if nuevo_precio.class != Integer 
        raise ArgumentError, "Price must be an integer."
      end
      @precio = nuevo_precio
    end

    def to_s
      quirofanos_ids = []
      i = 0
      while i < @quirofanos.length
        quirofano = @quirofanos[i]
        quirofanos_ids[i] = quirofano.id.to_s
        i += 1
      end
      quirofanos_str = _join_elements(quirofanos_ids)
      personal_nombres = []

      i = 0
      while i < @personal.length
        persona = @personal[i]
        personal_nombres[i] = persona.nombre.to_s
        i += 1
      end

      personal_str = _join_elements(personal_nombres)

      "Service: #{nombre} (ID: #{id})\n" +
      "  Care Type: #{tipo}\n" +
      "  Assigned Operating Rooms: #{quirofanos_str}\n" +
      "  Assigned Staff: #{personal_str}\n" +
      "  Usage Price: #{@precio}"
    end

    def ==(otro)
      unless otro.is_a?(ServicioQuirurgico) 
        return false
      end
      propiedades_iguales = (
        self.id == otro.id && 
        self.nombre == otro.nombre && 
        self.quirofanos == otro.quirofanos && 
        self.personal == otro.personal &&
        self.tipo == otro.tipo &&
        self.precio == otro.precio
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

    def num_quirofanos
      contador = 0
      i = 0
      while i < @quirofanos.length
        contador = contador + 1
        i = i + 1
      end
      return contador
    end

    def num_personal
      contador = 0
      i = 0
      while i < @personal.length
        contador = contador + 1
        i = i + 1
      end
      return contador
    end

    def obtener_estados_individuales
      resultados = [] 
      i = 0
      while i < @quirofanos.length
        quirofano = @quirofanos[i]
        resultado_str = "Operating Room ID Status: #{quirofano.id} = #{quirofano.estado}"
        resultados << resultado_str
        i = i + 1
      end
      return resultados
    end

    def total_personal_turno
      conteo_turnos = {}
      i = 0
      while i < @personal.length
        persona = @personal[i]
        turno_actual = persona.turno 
        contador_actual = conteo_turnos[turno_actual]
        if contador_actual == nil 
          conteo_turnos[turno_actual] = 1
        else
          conteo_turnos[turno_actual] = contador_actual + 1
        end
        i += 1
      end
      
      return conteo_turnos
    end

    def <=>(other)
      self.precio <=> other.precio 
    end

    def coste_total
      @precio
    end

    public :to_s, :==, :num_quirofanos, :num_personal, :obtener_estados_individuales, :total_personal_turno, :<=>, :coste_total
    protected :personal=, :quirofanos=, :nombre=, :id=, :precio=
    private :_join_elements
  end

  class CirugiaMayor < ServicioQuirurgico

    EQUIPOS_REQUERIDOS = ["general anesthesia", "multiparameter monitors", "resuscitation equipment", "mechanical ventilators"]

    attr_reader :equipos_avanzados

    def initialize(id, nombre, quirofanos = [], personal = [], precio)
      super(id, nombre, quirofanos, personal, precio)
      @equipos_avanzados = []
      i = 0
      while i < EQUIPOS_REQUERIDOS.length
        @equipos_avanzados[i] = EQUIPOS_REQUERIDOS[i]
        i += 1
      end
    end

    def to_s
      parent_string = super 
      equipos_str = _join_elements(@equipos_avanzados) 
      return parent_string + "\n  Required Advanced Equipment: #{equipos_str}"
    end

    def coste_total
      coste_base = super
      coste_add = 0
      i = 0
      while i < @equipos_avanzados.length
        coste_add += 150
        i += 1
      end
      coste_base + coste_add
    end

    public :to_s, :coste_total
  end

  class CirugiaMenor < ServicioQuirurgico

    EQUIPOS_REQUERIDOS = ["local anesthesia", "basic monitors"]

    attr_reader :equipo_simple

    def initialize(id, nombre, quirofanos = [], personal = [], precio)
      super(id, nombre, quirofanos, personal, precio)
      @equipo_simple = []
      i = 0
      
      while i < EQUIPOS_REQUERIDOS.length
        @equipo_simple[i] = EQUIPOS_REQUERIDOS[i]
        i += 1
      end
    end

    def to_s
      parent_string = super 
      equipos_str = _join_elements(@equipo_simple) 
      return parent_string + "\n \tRequired Basic Equipment: #{equipos_str}"
    end

    def coste_total
      coste_base = super
      coste_add = 0
      i = 0
      while i < @equipo_simple.length
        coste_add += 45
        i += 1
      end
      coste_base + coste_add
    end

    public :to_s, :coste_total
  end
end