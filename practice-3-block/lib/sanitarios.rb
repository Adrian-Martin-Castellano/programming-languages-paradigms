# frozen_string_literal: true

require_relative "sanitarios/version"
require_relative "sanitarios/constantes"
require_relative "sanitarios/servicio_quirurgico"
require_relative "sanitarios/quirofano"
require_relative "sanitarios/personal"
require_relative "sanitarios/utilidades"

module Sanitarios
  class Error < StandardError; end

  def self.total_quirofanos(servicios)
    raise ArgumentError, "servicios must be an array" unless servicios.is_a?(Array)
    total = 0
    for servicio in servicios
      raise ArgumentError, "servicios must be an array of ServicioQuirurgico instances" unless servicio.is_a?(Sanitarios::ServicioQuirurgico)
      total += servicio.num_quirofanos
    end
    total
  end

  def self.total_personal(servicios)
    raise ArgumentError, "servicios must be an array" unless servicios.is_a?(Array)
    total = 0
    for servicio in servicios
      raise ArgumentError, "servicios must be an array of ServicioQuirurgico instances" unless servicio.is_a?(Sanitarios::ServicioQuirurgico)
      total += servicio.num_personal
    end
    total
  end

  def self.fusion(miembro, miembro2)
    unless miembro.is_a?(Sanitarios::ServicioQuirurgico)
      raise ArgumentError, "The object must be an instance of ServicioQuirurgico, CirugiaMayor, or CirugiaMenor."
    end

    nuevo_nombre = miembro.nombre + "-" + miembro2.nombre
    nuevo_id = miembro.id.to_s + miembro2.id.to_s
    nuevos_quirofanos = miembro.quirofanos
    nuevos_personal = miembro.personal

    for quirofano in miembro2.quirofanos
      for q in nuevos_quirofanos
        if q != quirofano
          nuevos_quirofanos << quirofano
          break
        end
      end
    end

    for personal in miembro2.personal
      for p in nuevos_personal
        if p != personal
          nuevos_personal << personal
          break
        end
      end
    end

    nuevo_precio = miembro.precio + miembro2.precio

    if (miembro.class == Sanitarios::CirugiaMayor) || (miembro2.class == Sanitarios::CirugiaMayor)
      Sanitarios::CirugiaMayor.new(nuevo_id.to_i, nuevo_nombre, nuevos_quirofanos, nuevos_personal, nuevo_precio)
    else
      Sanitarios::CirugiaMenor.new(nuevo_id.to_i, nuevo_nombre, nuevos_quirofanos, nuevos_personal, nuevo_precio)
    end
  end
end