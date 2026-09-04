require_relative 'spec_helper'

RSpec.describe Sanitarios::Otros do
  let(:id_valido) { 50 }
  let(:nombre_valido) { "Auxiliar María" }
  let(:turno_valido) { "MAÑANA" }
  
  let(:otro_especialidad_valida) { "residente" } 
  let(:otro_especialidad_alternativa) { "enfermero cirulante" }
  let(:otro_especialidad_invalida) { "voluntario" }

  let(:otros_base) { 
    Sanitarios::Otros.new(15, nombre_valido, "TARDE", otro_especialidad_valida) 
  }

  context "Pruebas de Clase Exacta (instance_of?)" do
    it "otros_base debe ser una instancia de Otros" do
      expect(otros_base).to be_an_instance_of(Sanitarios::Otros)
      expect(otros_base.class).to eq(Sanitarios::Otros)
    end
  end

  context "Pruebas de Herencia y Tipo (be_a / kind_of?)" do
    it "otros_base hereda correctamente de Personal" do
      expect(otros_base).to be_a(Sanitarios::Personal) 
    end
    
    it "otros_base hereda correctamente de Object y BasicObject" do
      expect(otros_base).to be_a(Object)
    end
  end

  context "Pruebas de Inicialización y Getters (attr_reader)" do
    it "debe devolver los atributos heredados (id, nombre, turno)" do
      expect(otros_base.id).to eq(15)
      expect(otros_base.nombre).to eq(nombre_valido)
      expect(otros_base.turno).to eq("TARDE")
    end
    
    it "debe devolver el nuevo atributo 'otro_especialidad' y ser un String" do
      expect(otros_base.otro_especialidad).to eq(otro_especialidad_valida)
      expect(otros_base.otro_especialidad).to be_an_instance_of(String)
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones)" do
    it "debe lanzar ArgumentError si el ID no es un Integer (Heredado)" do
      expect { Sanitarios::Otros.new("50", nombre_valido, turno_valido, otro_especialidad_valida) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/)
    end
    
    it "debe lanzar ArgumentError si el turno es inválido (Heredado)" do
      expect { Sanitarios::Otros.new(id_valido, nombre_valido, "TARDE_EXTREMA", otro_especialidad_valida) }
      .to raise_error(ArgumentError, /Turno inválido/)
    end
    
    it "debe lanzar ArgumentError si la 'otro_especialidad' no es válida" do
      expected_msg_regex = /Especialidad inválida\. Debe ser uno de: enfermero cirulante, residente, estudiante/
      expect { Sanitarios::Otros.new(id_valido, nombre_valido, turno_valido, otro_especialidad_invalida) }
      .to raise_error(ArgumentError, expected_msg_regex)
    end
  end

  context "Pruebas de Setter para #otro_especialidad=" do
    it "tiene que estar definido como metodo privado" do
      expect { otros_base.otro_especialidad = "estudiante" }.to raise_error(NoMethodError)
      expect(Sanitarios::Otros.private_method_defined?(:otro_especialidad=)).to be true
    end

    it "debe permitir modificar la 'otro_especialidad' a un valor válido" do
      nueva_especialidad = otro_especialidad_alternativa 
      expect { otros_base.send(:otro_especialidad=, nueva_especialidad) }
        .to change { otros_base.otro_especialidad }
        .from(otro_especialidad_valida)
        .to(nueva_especialidad)
    end

    it "debe lanzar ArgumentError si se intenta modificar la 'otro_especialidad' a un valor inválido" do
      expected_msg_regex = /Especialidad inválida\. Debe ser uno de: enfermero cirulante, residente, estudiante/
      expect { otros_base.send(:otro_especialidad=, otro_especialidad_invalida) }
        .to raise_error(ArgumentError, expected_msg_regex)
      expect(otros_base.otro_especialidad).to eq(otro_especialidad_valida)
    end
  end

  context "pruebas para validar la especilidad para saber si es privada" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect { otros_base.otro_especialidad = "estudiante" }.to raise_error(NoMethodError)
      expect(Sanitarios::Otros.private_method_defined?(:validar_otro_especialidad!)).to be true
    end
  end

	 context "Pruebas de Representación de Cadena (to_s)" do
    let(:id_esperado) { 15 }
    let(:nombre_esperado) { "Auxiliar María" }
    let(:turno_esperado) { "TARDE" }
    let(:especialidad_esperada) { "residente" }

    it "pruebas para validar que es publico" do
      expect(Sanitarios::Otros.public_method_defined?(:to_s)).to be true
    end

    it "debe generar la cadena formateada correcta con 4 líneas (heredadas + especialidad)" do
      expected_base = "Quirófano ID: #{id_esperado}\n" + "  Nombre: #{nombre_esperado}\n" + "  Turno: #{turno_esperado}"							
      expected_output = "#{expected_base}\n" + "  Especialidad: #{especialidad_esperada}"
                        
      expect(otros_base.to_s).to eq(expected_output)
    end

    it "debe tener exactamente cuatro líneas" do
      output_lines = otros_base.to_s.split("\n")
      expect(output_lines.length).to eq(4)
    end
    
    it "debe heredar las primeras 3 líneas del to_s del padre (Personal)" do
      output_lines = otros_base.to_s.split("\n")
      expect(output_lines[0]).to eq("Quirófano ID: #{id_esperado}")
      expect(output_lines[2]).to eq("  Turno: #{turno_esperado}")
    end

    it "debe añadir la información de la Especialidad como la última línea" do
      output_lines = otros_base.to_s.split("\n")
      expect(output_lines.last).to eq("  Especialidad: #{especialidad_esperada}")
    end
  end

  context "Pruebas de Sobrecarga de Igualdad (==)" do
    let(:otros_base) { Sanitarios::Otros.new(15, "Auxiliar María", "TARDE", "residente") }

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Otros.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto Personal con los mismos atributos" do
      otro_igual = Sanitarios::Otros.new(15, "Auxiliar María", "TARDE", "residente")
      expect(otros_base).to eq(otro_igual)
    end

    it "NO debe ser igual a otro objeto Personal con diferente atributos" do
      otro_diferente_id = Sanitarios::Otros.new(1, "Auxiliar María", "TARDE", "residente")
      otro_diferente_nombre = Sanitarios::Otros.new(15, "Auxiliar Mario", "TARDE", "residente")
      otro_diferente_turno = Sanitarios::Otros.new(15, "Auxiliar María", "MAÑANA", "residente")
      otro_diferente_especialidad = Sanitarios::Otros.new(15, "Auxiliar María", "TARDE", "estudiante")

      expect(otros_base).to_not eq(otro_diferente_id)
      expect(otros_base).to_not eq(otro_diferente_nombre)
      expect(otros_base).to_not eq(otro_diferente_turno)
      expect(otros_base).to_not eq(otro_diferente_especialidad)
    end

    it "NO debe ser igual a una instancia de una subclase (ej: Cirujano) con los mismos atributos, debido a la clase estricta" do
      otro_clase_diferente = Sanitarios::Bioseguridad.new(5, "OCUPADO", ["Biólogo", "Técnico"], "ISO 7")
      expect(otros_base).to_not eq(otro_clase_diferente)
    end
  end

  context "verificar que los setters siguen siendo protegidos" do
    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Otros.protected_method_defined?(:nombre=)).to be true
      expect(Sanitarios::Otros.protected_method_defined?(:id=)).to be true
      expect(Sanitarios::Otros.protected_method_defined?(:turno=)).to be true
    end
  end
end