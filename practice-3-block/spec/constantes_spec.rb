require_relative 'spec_helper'

RSpec.describe Sanitarios::GruposServicios do

  let(:grupos) { Sanitarios::GruposServicios }

  context "Verificación de la Existencia y Valores de Constantes" do
    
    it "La constante QUIRURGICA debe existir y tener el valor correcto" do
      expect(grupos.const_defined?(:QUIRURGICA)).to be true
      expect(grupos::QUIRURGICA).to eq("Atención Quirúrgica")
    end

    it "La constante AMBULATORIA tiene el valor correcto" do
      expect(grupos::AMBULATORIA).to eq("Atención Ambulatoria")
    end

    it "La constante HOSPITALARIA tiene el valor correcto" do
      expect(grupos::HOSPITALARIA).to eq("Atención Hospitalaria")
    end

    it "La constante DOMICILIARIA tiene el valor correcto" do
      expect(grupos::DOMICILIARIA).to eq("Atención Domiciliaria")
    end

    it "La constante RESIDENCIAL tiene el valor correcto" do
      expect(grupos::RESIDENCIAL).to eq("Atención Residencial")
    end

    it "El módulo contiene las 6 constantes esperadas" do
      expect(grupos.constants.size).to eq(6)
      expect(grupos.constants).to include(:AMBULATORIA, :EMERGENCIA, :QUIRURGICA, :HOSPITALARIA, :DOMICILIARIA, :RESIDENCIAL)
    end
  end
end