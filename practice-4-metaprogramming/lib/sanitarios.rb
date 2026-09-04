# frozen_string_literal: true

require_relative "sanitarios/version"
require_relative "sanitarios/constantes"
require_relative "sanitarios/servicio_quirurgico"
require_relative "sanitarios/quirofano"
require_relative "sanitarios/personal"
require_relative "sanitarios/utilidades"
require_relative "sanitarios/DSLQuirurgico"

module Sanitarios
  class Error < StandardError; end

  def self.total_quirofanos(servicios)
    raise ArgumentError, "Services must be an Array." unless servicios.is_a?(Array)

    total = 0
    servicios.each do |servicio|
      unless servicio.is_a?(Sanitarios::ServicioQuirurgico)
        raise ArgumentError, "Array elements must be instances of ServicioQuirurgico."
      end
      total += servicio.num_quirofanos
    end
    total
  end

  def self.total_personal(servicios)
    raise ArgumentError, "Services must be an Array." unless servicios.is_a?(Array)

    total = 0
    servicios.each do |servicio|
      unless servicio.is_a?(Sanitarios::ServicioQuirurgico)
        raise ArgumentError, "Array elements must be instances of ServicioQuirurgico."
      end
      total += servicio.num_personal
    end
    total
  end

  def self.fusion(miembro, miembro2)
    unless miembro.is_a?(Sanitarios::ServicioQuirurgico) && miembro2.is_a?(Sanitarios::ServicioQuirurgico)
      raise ArgumentError, "Both objects must be instances of ServicioQuirurgico."
    end

    nuevo_nombre = "#{miembro.nombre}-#{miembro2.nombre}"
    nuevo_id = "#{miembro.id}#{miembro2.id}".to_i

    nuevos_quirofanos = (miembro.quirofanos + miembro2.quirofanos).uniq
    nuevos_personal   = (miembro.personal + miembro2.personal).uniq
    nuevo_precio     = miembro.precio + miembro2.precio

    clase_destino = if miembro.is_a?(Sanitarios::CirugiaMayor) || miembro2.is_a?(Sanitarios::CirugiaMayor)
                      Sanitarios::CirugiaMayor
                    else
                      Sanitarios::CirugiaMenor
                    end

    clase_destino.new(nuevo_id, nuevo_nombre, nuevos_quirofanos, nuevos_personal, nuevo_precio)
  end
end