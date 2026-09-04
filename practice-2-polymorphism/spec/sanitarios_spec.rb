# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Sanitarios do
  let(:p_cirujano) { Sanitarios::Cirujano.new(1, "Dr. Smith", "MAÑANA", "cirugia general") }
  let(:p_asistente) { Sanitarios::Asistente.new(2, "Enf. Pérez", "MAÑANA", "tecnologo quirurgico") }
  let(:p_anestesista) { Sanitarios::Anestesiologo.new(99, "Dr. Johnson (Anestesista)", "NOCHE", "neuroquirúrgica") }
  let(:p_otro) { Sanitarios::Otros.new(100, "Residente Y", "TARDE", "residente") }

  let(:equipo_completo_q) { [p_cirujano, p_asistente, p_anestesista] } 
  let(:equipo_grande_q) { [p_cirujano, p_asistente, p_anestesista, p_otro] } 
  let(:personal_valido) { [p_cirujano, p_asistente] }
  let(:personal_validos2) { [p_anestesista] } 

  let(:q_general_1) { Sanitarios::Quirofano.new(201, "DISPONIBLE", equipo_completo_q) } 
  let(:q_general_2) { Sanitarios::Bioseguridad.new(202, "OCUPADO", equipo_grande_q, Sanitarios::Bioseguridad::ISO_PERMITIDOS.first) } 
  let(:quirofanos_validos) { [q_general_1, q_general_2] } 

  let(:q_trauma_1) { Sanitarios::Funcional.new(901, "ESPERANDO", equipo_completo_q, Sanitarios::Funcional::ESTADOS_PERMITIDOS.first) } 
  let(:quirofanos_validos2) { [q_trauma_1] } 

  let(:servicio1) do
    Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_validos, personal_valido, 5000)
  end

  let(:servicio2) do
    Sanitarios::ServicioQuirurgico.new(99, "Urgencias", quirofanos_validos2, personal_validos2, 15000) 
  end

  let(:servicio3) do
    Sanitarios::ServicioQuirurgico.new(3, "Neuro", quirofanos_validos, personal_validos2, 10000) 
  end

  let(:servicios_coleccion) { [servicio1, servicio2, servicio3] } 

  it "debe tener un número de versión definido" do
    expect(Sanitarios::VERSION).not_to be nil
  end

  context "Método de Clase: .total_quirofanos" do
    it "debe devolver el número total de quirófanos sumados de todos los servicios" do
      total_esperado = 5
      expect(Sanitarios.total_quirofanos(servicios_coleccion)).to eq(total_esperado)
    end

    it "debe devolver 0 si la colección de servicios está vacía" do
      expect(Sanitarios.total_quirofanos([])).to eq(0)
    end

    it "debe devolver el conteo correcto si solo hay un servicio en la colección" do
      expect(Sanitarios.total_quirofanos([servicio2])).to eq(1)
    end

    it "debe lanzar ArgumentError si el argumento no es un Array" do
      expect { Sanitarios.total_quirofanos("no es un array") }
        .to raise_error(ArgumentError, /servicios tiene que ser un array/)
    end

    it "debe lanzar ArgumentError si un elemento del Array no es ServicioQuirurgico" do
      coleccion_invalida = servicios_coleccion + [p_anestesista]
      expect { Sanitarios.total_quirofanos(coleccion_invalida) }
        .to raise_error(ArgumentError, /servicios tiene que ser un array de instancias de ServicioQuirurgico/)
    end
  end

  context "Método de Clase: .total_personal" do
    it "debe devolver la cantidad total de personal sumada de todos los servicios" do
      total_esperado = 4
      expect(Sanitarios.total_personal(servicios_coleccion)).to eq(total_esperado)
    end

    it "debe devolver 0 si la colección de servicios está vacía" do
      expect(Sanitarios.total_personal([])).to eq(0)
    end

    it "debe lanzar ArgumentError si el argumento no es un Array" do
      expect { Sanitarios.total_personal(nil) }
        .to raise_error(ArgumentError, /servicios tiene que ser un array/)
    end

    it "debe lanzar ArgumentError si un elemento del Array no es ServicioQuirurgico" do
      coleccion_invalida = [servicio1, "esto no es un servicio"]

      expect { Sanitarios.total_personal(coleccion_invalida) }
        .to raise_error(ArgumentError, /servicios tiene que ser un array de instancias de ServicioQuirurgico/)
    end
  end

  context "pruebas para el metodo de fusion de servicioQuirurgico" do
    let(:servicio1_alt) do
    Sanitarios::CirugiaMayor.new(1, "General", quirofanos_validos, personal_valido, 5000)
    end

    let(:servicio2_alt) do
      Sanitarios::CirugiaMenor.new(99, "Urgencias", quirofanos_validos2, personal_validos2, 15000) 
    end

    let(:servicio3_alt) do
      Sanitarios::CirugiaMenor.new(3, "Neuro", quirofanos_validos, personal_valido, 10000) 
    end

    let(:servicio4_alt) do
      Sanitarios::CirugiaMayor.new(100, "Otro", quirofanos_validos2, personal_validos2, 15000) 
    end

    it "debe fusionar dos Cirugia mayor en uno nuevo correctamente" do
      servicio_fusionado = Sanitarios.fusion(servicio1_alt, servicio4_alt)

      expect(servicio_fusionado).to be_a(Sanitarios::ServicioQuirurgico)
      expect(servicio_fusionado).to be_a(Sanitarios::CirugiaMayor)

      expect(servicio_fusionado.nombre).to eq("General-Otro")
      expect(servicio_fusionado.id).to eq(1100)
      expect(servicio_fusionado.precio).to eq(20000) 
      expect(servicio_fusionado.quirofanos.length).to eq(3) 
      expect(servicio_fusionado.personal.length).to eq(3) 
    end

    it "debe fusionar un cirugiamayor y cirugiamenor  en uno nuevo correctamente" do
      servicio_fusionado = Sanitarios.fusion(servicio1_alt, servicio2_alt)

      expect(servicio_fusionado).to be_a(Sanitarios::ServicioQuirurgico)

      expect(servicio_fusionado.nombre).to eq("General-Urgencias")
      expect(servicio_fusionado.id).to eq((1 .to_s + 99 .to_s).to_i)
      expect(servicio_fusionado.precio).to eq(20000) 
      expect(servicio_fusionado.quirofanos.length).to eq(3) 
      expect(servicio_fusionado.personal.length).to eq(3) 
    end

    it "debe fusionar dos cirugiamenor en uno nuevo correctamente" do
      servicio_fusionado = Sanitarios.fusion(servicio2_alt, servicio3_alt)

      expect(servicio_fusionado).to be_a(Sanitarios::ServicioQuirurgico)

      expect(servicio_fusionado.nombre).to eq("Urgencias-Neuro")
      expect(servicio_fusionado.id).to eq((99 .to_s + 3 .to_s).to_i)
      expect(servicio_fusionado.precio).to eq(25000) 
      expect(servicio_fusionado.quirofanos.length).to eq(3) 
      expect(servicio_fusionado.personal.length).to eq(3) 
    end

    it "debe lanzar ArgumentError si el primer argumento no es ServicioQuirurgico" do
      expect { Sanitarios.fusion("no es un servicio", servicio2) }
        .to raise_error(ArgumentError, /El objeto debe ser una instancia de ServicioQuirurgico/)
    end
  end
end