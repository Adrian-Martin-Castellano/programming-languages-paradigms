module Sanitarios
  module Utilidades
    def media(coleccion)
      return 0.0 if coleccion.empty?
      resultado = coleccion.map { |variable| yield(variable) }
      resultado.sum.to_f / resultado.size
    end

    def mediana(coleccion)
      return 0.0 if coleccion.empty?
      lista_ordenada = coleccion.map { |item| yield(item) }.sort
      n = lista_ordenada.size
      cociente, resto = n.divmod(2)
      indice_inicial = cociente - (1 - resto) 
      elementos_centrales = lista_ordenada.slice(indice_inicial, 2 - resto) 
      elementos_centrales.inject(:+) / elementos_centrales.size.to_f
    end

    def moda(coleccion)
      return 0.0 if coleccion.empty?
      valores_analisis = coleccion.map { |item| yield(item) }
      frecuencias = valores_analisis.group_by(&:itself).transform_values(&:count)
      max_frecuencia = frecuencias.values.max
      frecuencias.select { |_, count| count == max_frecuencia }.keys
    end

    def maximo(coleccion)
      raise ArgumentError, "Collection cannot be empty" if coleccion.empty?
      coleccion.max_by { |item| yield(item) }
    end

    def minimo(coleccion)
      raise ArgumentError, "Collection cannot be empty" if coleccion.empty?
      coleccion.min_by { |item| yield(item) }
    end

    def desviacion_estandar(coleccion)
      raise ArgumentError, "Collection must have at least two elements to calculate standard deviation" if coleccion.size < 2
      valores_analisis = coleccion.map { |item| yield(item) }
      mean = media(valores_analisis) { |x| x } 
      suma_cuadrados_diferencias = valores_analisis.map do |x| 
        (x - mean)**2 
      end.inject(:+)
      varianza = suma_cuadrados_diferencias / (valores_analisis.size - 1).to_f
      Math.sqrt(varianza)
    end
  end
end