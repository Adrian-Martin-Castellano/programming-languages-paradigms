require_relative 'spec_helper'

RSpec.describe Sanitarios::Personal do
  let(:id_valido) { 101 }
  let(:nombre_valido) { "Dra. Ana López" }
  let(:turno_valido) { "TARDE" }
  let(:turno_invalido) { "MADRUGADA" }
  let(:personal_base) { Sanitarios::Personal.new(1, "Enfermero Juan", "MAÑANA") }

  let(:p_cirujano) { Sanitarios::Cirujano.new(100, "Dr. Equipo", "MAÑANA", "cirugia general") }
  let(:p_asistente) { Sanitarios::Asistente.new(101, "Enf. Equipo", "MAÑANA", "tecnologo quirurgico") }
  let(:p_anestesista) { Sanitarios::Anestesiologo.new(102, "Dr. Anestesia", "NOCHE", "obstetrica") }
  let(:equipo_completo_q) { [p_cirujano, p_asistente, p_anestesista] }

  context "Pruebas de Clase Exacta (instance_of?)" do
    it "personal_base debe ser una instancia de Personal" do
      expect(personal_base).to be_an_instance_of(Sanitarios::Personal)
      expect(personal_base.class).to eq(Sanitarios::Personal)
    end
  end

  context "Pruebas de Herencia y Tipo (be_a / kind_of?)" do
    it "personal_base se identifica como su propia clase" do
      expect(personal_base).to be_a(Sanitarios::Personal)
      expect(personal_base).to be_kind_of(Sanitarios::Personal)
    end

    it "personal_base hereda correctamente de Object y BasicObject" do
      expect(personal_base).to be_a(Comparable)
      expect(personal_base).to be_a(Object)
      expect(personal_base).to be_a(BasicObject)
    end
  end

  context "Pruebas de Inicialización y Getters (attr_reader)" do
    it "debe devolver el ID correcto y como Integer" do
      expect(personal_base.id).to eq(1)
      expect(personal_base.id).to be_an_instance_of(Integer)
    end

    it "debe devolver el nombre correcto y como String" do
      expect(personal_base.nombre).to eq("Enfermero Juan")
      expect(personal_base.nombre).to be_an_instance_of(String)
    end

    it "debe devolver el turno correcto y como String" do
      expect(personal_base.turno).to eq("MAÑANA")
      expect(personal_base.turno).to be_an_instance_of(String)
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones)" do
    
    it "debe lanzar ArgumentError si el ID no es un Integer" do
      expect { Sanitarios::Personal.new("1", nombre_valido, turno_valido) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/)
    end

    it "debe lanzar ArgumentError si el ID es nil" do
      expect { Sanitarios::Personal.new(nil, nombre_valido, turno_valido) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/) 
    end
    
    it "debe lanzar ArgumentError si el nombre no es una String" do
      expect { Sanitarios::Personal.new(id_valido, 123, turno_valido) }
      .to raise_error(ArgumentError, /El nombre debe ser una cadena de texto/)
    end
    
    it "debe lanzar ArgumentError si el nombre es nil" do
      expect { Sanitarios::Personal.new(id_valido, nil, turno_valido) }
      .to raise_error(ArgumentError, /El nombre debe ser una cadena de texto/)
    end

    it "debe lanzar ArgumentError si el turno no es permitido" do
      expect { Sanitarios::Personal.new(id_valido, nombre_valido, turno_invalido) }
      .to raise_error(ArgumentError, /Turno inválido\. Debe ser uno de: MAÑANA, TARDE, NOCHE/)
    end
  end

  context "Prueba de Inicialización Correcta (Verificación de Tipos)" do
    it "debe inicializar el personal correctamente con tipos válidos" do
      expect(personal_base).to be_an_instance_of(Sanitarios::Personal)
      expect(personal_base.id).to be_an_instance_of(Integer)
      expect(personal_base.nombre).to be_an_instance_of(String)
      expect(personal_base.turno).to be_an_instance_of(String)
    end
  end

  context "Pruebas de Setters (con métodos Protected)" do
    let(:personal) { Sanitarios::Personal.new(500, "Dra. Pura", "NOCHE") }

    it "NO debe permitir la asignación directa, confirmando que es PRIVATE" do
      expect { personal_base.nombre = "algo" }.to raise_error(NoMethodError)
      expect { personal_base.id = 34 }.to raise_error(NoMethodError)
      expect { personal_base.turno = "NOCHE" }.to raise_error(NoMethodError)
      expect(Sanitarios::Personal.protected_method_defined?(:turno=)).to be true
      expect(Sanitarios::Personal.protected_method_defined?(:id=)).to be true
      expect(Sanitarios::Personal.protected_method_defined?(:nombre=)).to be true
    end

    it "debe permitir modificar el ID a un valor Integer válido" do
      expect { personal.send(:id=, 600) }.to change { personal.id }.from(500).to(600)
    end

    it "NO debe permitir modificar el ID a un valor que no sea Integer" do
      expect { personal.send(:id=, "invalido") }.to raise_error(ArgumentError, /ID debe ser un número entero/)
      expect(personal.id).to eq(500)
    end
    
    
    it "debe permitir modificar el nombre a un valor String válido" do
      nuevo_nombre = "Dr. Nuevo"
      expect { personal.send(:nombre=, nuevo_nombre) }.to change { personal.nombre }.from("Dra. Pura").to(nuevo_nombre)
    end

    it "NO debe permitir modificar el nombre a un valor que no sea String" do
      expect { personal.send(:nombre=, 999) }.to raise_error(ArgumentError, /El nombre debe ser una cadena de texto/)
      expect(personal.nombre).to eq("Dra. Pura")
    end
    
    it "debe permitir modificar el turno a un valor válido" do
      nuevo_turno = "MAÑANA"
      expect { personal.send(:turno=, nuevo_turno) }.to change { personal.turno }.from("NOCHE").to(nuevo_turno)
    end

    it "debe lanzar ArgumentError si se intenta modificar el turno a un valor inválido" do
      expect { personal.send(:turno=, turno_invalido) }.to raise_error(ArgumentError, /Turno inválido/)
      expect(personal.turno).to eq("NOCHE")
    end
  end

  context "Pruebas de Representación de Cadena (to_s)" do
    let(:id_esperado) { 1 }
    let(:nombre_esperado) { "Enfermero Juan" }
    let(:turno_esperado) { "MAÑANA" }

     it "pruebas para validar que es publico" do
      expect(Sanitarios::Personal.public_method_defined?(:to_s)).to be true
    end

    it "debe generar la cadena formateada correcta con ID, Nombre y Turno" do
      expected_output = "Quirófano ID: #{id_esperado}\n" + "  Nombre: #{nombre_esperado}\n" + "  Turno: #{turno_esperado}"
      expect(personal_base.to_s).to eq(expected_output)
    end

    it "debe tener exactamente tres líneas" do
      output_lines = personal_base.to_s.split("\n")
      expect(output_lines.length).to eq(3)
    end

    it "la primera línea debe contener el ID" do
      output_lines = personal_base.to_s.split("\n")
      expect(output_lines[0]).to eq("Quirófano ID: #{id_esperado}")
    end

    it "la última línea debe contener el Turno" do
      output_lines = personal_base.to_s.split("\n")
      expect(output_lines.last).to eq("  Turno: #{turno_esperado}")
    end
  end

  context "Pruebas de Sobrecarga de Igualdad (==)" do
    let(:personal_base) { Sanitarios::Personal.new(1, "Enfermero Juan", "MAÑANA") }

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Personal.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto Personal con los mismos atributos" do
      otro_igual = Sanitarios::Personal.new(1, "Enfermero Juan", "MAÑANA")
      expect(personal_base).to eq(otro_igual)
    end

    it "NO debe ser igual a otro objeto Personal con diferente ID" do
      otro_diferente_id = Sanitarios::Personal.new(2, "Enfermero Juan", "MAÑANA")
      otro_diferente_nombre = Sanitarios::Personal.new(1, "Enfermero Pedro", "MAÑANA")
      otro_diferente_turno = Sanitarios::Personal.new(1, "Enfermero Juan", "TARDE")

      expect(personal_base).to_not eq(otro_diferente_id)
      expect(personal_base).to_not eq(otro_diferente_nombre)
      expect(personal_base).to_not eq(otro_diferente_turno)
    end

    it "NO debe ser igual a una instancia de una subclase (ej: Cirujano) con los mismos atributos, debido a la clase estricta" do
      otro_clase_diferente = Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_completo_q, "ISO 7")
      expect(personal_base).to_not eq(otro_clase_diferente)
    end
  end

  context "pruebas para validar la join_elements para saber si es privada" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::Personal.private_method_defined?(:_join_elements)).to be true
    end
  end

  context "pruebas para validar el turno para saber si es privada" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::Personal.private_method_defined?(:validar_turno!)).to be true
    end
  end

  context "Pruebas de Conteo de Instancias (@@contador_personal)" do
    it "el método de clase count_personal debe ser público" do
      expect(Sanitarios::Personal.public_methods).to include(:count_personal)
      expect(Sanitarios::Personal.count_personal).to be_an_instance_of(Integer)
    end

    it "debe incrementar el contador de clase en 1 por cada nueva instancia de Personal creada" do      
      initial_count = Sanitarios::Personal.count_personal
      
      p1 = Sanitarios::Personal.new(90, "Personal Auxiliar 1", "MAÑANA")
      expect(Sanitarios::Personal.count_personal).to eq(initial_count + 1)
      
      p2 = Sanitarios::Personal.new(91, "Personal Auxiliar 2", "TARDE")
      expect(Sanitarios::Personal.count_personal).to eq(initial_count + 2)
    end
  end

  context "Pruebas de Comparación (Comparable y <=>)" do
    let(:personal_pequeño) { Sanitarios::Personal.new(10, "Andrea", "MAÑANA") }
    let(:personal_medio) { Sanitarios::Personal.new(20, "Marta", "TARDE") }
    let(:personal_grande) { Sanitarios::Personal.new(30, "Sofia", "MAÑANA") }
    let(:personal_igual) { Sanitarios::Personal.new(40, "Andrea", "NOCHE") }

    it "el método <=> debe estar definido como público (heredado del módulo Comparable)" do
      expect(Sanitarios::Personal.public_method_defined?(:<=>)).to be true
    end

    it "debe implementar el método <=> basado en el nombre" do
      expect(personal_grande <=> personal_pequeño).to eq(1)
      expect(personal_pequeño <=> personal_grande).to eq(-1)
      expect(personal_pequeño <=> personal_igual).to eq(0)
    end

    it "debe permitir usar el operador > (Mayor que)" do
      expect(personal_grande > personal_medio).to be true
      expect(personal_pequeño > personal_grande).to be false
    end

    it "debe permitir usar el operador < (Menor que)" do
      expect(personal_pequeño < personal_medio).to be true
      expect(personal_grande < personal_pequeño).to be false
    end

    it "debe permitir usar el operador >= (Mayor o igual que)" do
      expect(personal_medio >= personal_pequeño).to be true
      expect(personal_pequeño >= personal_igual).to be true
      expect(personal_pequeño >= personal_medio).to be false
    end

    it "debe permitir usar el método #between?" do
      expect(personal_medio.between?(personal_pequeño, personal_grande)).to be true
      expect(personal_pequeño.between?(personal_medio, personal_grande)).to be false
    end
  end
end