require_relative 'spec_helper'

RSpec.describe Sanitarios::Otros do
  let(:id_valido) { 100 }
  let(:nombre_valido) { "Residente de Prueba" }
  let(:turno_valido) { "TARDE" }
  let(:turno_valido_alt) { "MAÑANA" }
  let(:turno_invalido) { "NO TURNO" }
  
  let(:especialidad_valida) { Sanitarios::Otros::ESPECIALIDADES_VALIDAS_OTROS.first }
  let(:especialidad_valida_alt) { Sanitarios::Otros::ESPECIALIDADES_VALIDAS_OTROS.last } 
  let(:especialidad_invalida) { "traumatologo" }

  let(:otro_base) { Sanitarios::Otros.new(id_valido, nombre_valido, turno_valido, especialidad_valida) }

  context "Pruebas de Clase Exacta (instance_of?)" do
    it "otro_base debe ser una instancia EXACTA de Sanitarios::Otros" do
      expect(otro_base).to be_an_instance_of(Sanitarios::Otros)
      expect(otro_base.class).to eq(Sanitarios::Otros)
      expect(otro_base).to_not be_an_instance_of(Sanitarios::Personal)
    end
  end

  context "Pruebas de Herencia y Tipo (be_a / kind_of?)" do
    it "otro_base se identifica como su propia clase y sus ancestros (Personal, Object, BasicObject)" do
      expect(otro_base).to be_a(Sanitarios::Otros)
      expect(otro_base).to be_a(Sanitarios::Personal)
      expect(otro_base).to be_kind_of(Sanitarios::Otros)
      expect(otro_base).to be_kind_of(Sanitarios::Personal)
      expect(otro_base).to be_a(Object)
    end
  end

  context "Pruebas de Inicialización y Getters (attr_reader)" do
    it "debe devolver los atributos heredados (id, nombre, turno) y propios (otro_especialidad)" do
      expect(otro_base.id).to eq(id_valido)
      expect(otro_base.nombre).to eq(nombre_valido)
      expect(otro_base.turno).to eq(turno_valido)
      expect(otro_base.otro_especialidad).to eq(especialidad_valida)
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones)" do
    it "debe lanzar ArgumentError si el ID no es un Integer" do
      expect { Sanitarios::Otros.new("101", nombre_valido, turno_valido, especialidad_valida) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/)
    end

    it "debe lanzar ArgumentError si el turno no es permitido" do
      expected_msg = /Turno inválido\. Debe ser uno de: MAÑANA, TARDE, NOCHE/
      expect { Sanitarios::Otros.new(id_valido, nombre_valido, turno_invalido, especialidad_valida) }
      .to raise_error(ArgumentError, expected_msg)
    end

    it "debe lanzar ArgumentError si la especialidad no es permitida" do
      expected_msg = /Especialidad inválida\. Debe ser uno de: enfermero cirulante, residente, estudiante/
      expect { Sanitarios::Otros.new(id_valido, nombre_valido, turno_valido, especialidad_invalida) }
      .to raise_error(ArgumentError, expected_msg)
    end
  end

  context "Pruebas de Setters (Protected y Private)" do
    it "debe permitir modificar el id a un valor válido (usando send)" do
      expect { otro_base.send(:id=, 200) }
      .to change { otro_base.id }
      .from(id_valido)
      .to(200)
    end

    it "debe permitir modificar el turno a un valor válido (usando send)" do
      expect { otro_base.send(:turno=, turno_valido_alt) }
      .to change { otro_base.turno }
      .from(turno_valido)
      .to(turno_valido_alt)
    end

    it "debe permitir modificar la otro_especialidad a un valor válido (usando send)" do
      expect { otro_base.send(:otro_especialidad=, especialidad_valida_alt) }
      .to change { otro_base.otro_especialidad }
      .from(especialidad_valida)
      .to(especialidad_valida_alt)
    end
    
    it "debe lanzar ArgumentError si se intenta modificar la especialidad a un valor inválido (usando send)" do
      expected_msg = /Especialidad inválida/
      expect { otro_base.send(:otro_especialidad=, especialidad_invalida) }
      .to raise_error(ArgumentError, expected_msg)
      expect(otro_base.otro_especialidad).to eq(especialidad_valida)
    end
    
    it "debe confirmar que el setter propio es private" do
      expect(Sanitarios::Otros.private_method_defined?(:otro_especialidad=)).to be true
    end
  end

  context "Pruebas de Representación de Cadena (to_s) - Sobrescrito" do
    it "pruebas para validar que es publico" do
      expect(Sanitarios::Otros.public_method_defined?(:to_s)).to be true
    end

    it "debe generar la cadena formateada correcta, incluyendo especialidad propia" do
      expected_output = "Quirófano ID: #{id_valido}\n" +
                        "  Nombre: #{nombre_valido}\n" +
                        "  Turno: #{turno_valido}\n" +
                        "  Especialidad: #{especialidad_valida}"
      
      output = otro_base.to_s
      
      expect(output).to eq(expected_output)
      expect(output).to include(especialidad_valida)
      expect(output).to include("Especialidad")
    end
  end
  
  context "Pruebas de Sobrecarga de Igualdad (==) - Sobrescrito" do
    let(:otro_base_eq) { Sanitarios::Otros.new(10, "Pepe", turno_valido, especialidad_valida) }

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Otros.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto Otros con los mismos atributos" do
      otro_igual = Sanitarios::Otros.new(10, "Pepe", turno_valido, especialidad_valida)
      expect(otro_base_eq).to eq(otro_igual)
    end

    it "NO debe ser igual a otro objeto Otros si un atributo propio (otro_especialidad) es diferente" do
      otro_diferente_especialidad = Sanitarios::Otros.new(10, "Pepe", turno_valido, especialidad_valida_alt)
      expect(otro_base_eq).to_not eq(otro_diferente_especialidad)
    end

    it "NO debe ser igual a una instancia de una clase hermana (ej: Cirujano)" do
      otro_clase_diferente = Sanitarios::Cirujano.new(10, "Pepe", turno_valido, "cirugia general")
      expect(otro_base_eq).to_not eq(otro_clase_diferente)
    end
  end

  context "Pruebas de Comparación (Comparable y <=>) - Heredado" do
    let(:otro_A) { Sanitarios::Otros.new(1, "Ana", "MAÑANA", especialidad_valida) } 
    let(:otro_B) { Sanitarios::Otros.new(2, "Beto", "TARDE", especialidad_valida) }
    let(:otro_C) { Sanitarios::Otros.new(3, "Carlos", "NOCHE", especialidad_valida) }
    let(:otro_A_igual) { Sanitarios::Otros.new(4, "Ana", "TARDE", especialidad_valida) }

    it "el método <=> debe estar definido como público (heredado)" do
      expect(Sanitarios::Otros.public_method_defined?(:<=>)).to be true
    end

    it "debe implementar el método <=> basado en el atributo nombre (heredado)" do
      expect(otro_C <=> otro_A).to eq(1) 
      expect(otro_A <=> otro_C).to eq(-1) 
      expect(otro_A <=> otro_A_igual).to eq(0) 
    end

    it "debe permitir usar el operador > (Mayor que)" do
      expect(otro_C > otro_B).to be true
      expect(otro_A > otro_C).to be false
    end
  end
end