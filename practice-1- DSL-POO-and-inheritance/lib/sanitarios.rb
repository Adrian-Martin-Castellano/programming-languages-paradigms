# frozen_string_literal: true

require_relative "sanitarios/version"
require_relative "sanitarios/constantes"
require_relative "sanitarios/servicio_quirurgico"
require_relative "sanitarios/quirofano"
require_relative "sanitarios/personal"

module Sanitarios
  class Error < StandardError; end
  # Main entrypoint for the Sanitarios gem
end