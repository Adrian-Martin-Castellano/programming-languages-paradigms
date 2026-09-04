require_relative 'spec_helper'

RSpec.describe Sanitarios::Asistente do
  let(:id_valido) { 40 }
  let(:nombre_valido) { "Enfermero Peter" }
  let(:turno_valido) { "TARDE" }
  
  let(:especialidad_valida) { "tecnologo quirurgico" } 
  let(:especialidad_alternativa) { "primer asistente quirurgico" }
  let(:especialidad_invalida) { "pediatra quirurgico" }

  let(:asistente_base) { 
    Sanitarios::Asistente.new(12, nombre_valido, "NOCHE", especialidad_valida) 
  }

  let(:p_cirujano) { Sanitarios::Cirujano.new(100, "Dr. Equipo", "MAÑANA", "cirugia general") }
  let(:p_asistente) { Sanitarios::Asistente.new(101, "Enf. Equipo", "MAÑANA", "tecnologo quirurgico") }
  let(:p_anestesista) { Sanitarios::Anestesiologo.new(102, "Dr. Anestesia", "NOCHE", "obstetrica") }
  let(:equipo_completo_q) { [p_cirujano, p_asistente, p_anestesista] }

  context "Pruebas de Clase Exacta (instance_of?)" do
    it "asistente_base debe ser una instancia de Asistente" do
      expect(asistente_base).to be_an_instance_of(Sanitarios::Asistente)
    end
  end

  context "Pruebas de Herencia y Tipo (be_a / kind_of?)" do
    it "asistente_base hereda correctamente de Personal" do
      expect(asistente_base).to be_a(Sanitarios::Personal) 
    end
    
    it "asistente_base hereda correctamente de Object y BasicObject" do
      expect(asistente_base).to be_a(Object)
    end
  end

  context "Pruebas de Inicialización y Getters (attr_reader)" do
    it "debe devolver los atributos heredados (id, nombre, turno)" do
      expect(asistente_base.id).to eq(12)
      expect(asistente_base.nombre).to eq(nombre_valido)
      expect(asistente_base.turno).to eq("NOCHE")
    end
    
    it "debe devolver el nuevo atributo 'especialidad' y ser un String" do
      expect(asistente_base.especialidad).to eq(especialidad_valida)
      expect(asistente_base.especialidad).to be_an_instance_of(String)
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones)" do
    
    it "debe lanzar ArgumentError si el ID no es un Integer (Heredado)" do
      expect { Sanitarios::Asistente.new("40", nombre_valido, turno_valido, especialidad_valida) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/)
    end
    
    it "debe lanzar ArgumentError si el turno es inválido (Heredado)" do
      expect { Sanitarios::Asistente.new(id_valido, nombre_valido, "FINDE", especialidad_valida) }
      .to raise_error(ArgumentError, /Turno inválido/)
    end
    
    it "debe lanzar ArgumentError si la 'especialidad' no es válida" do
      expected_msg_regex = /Especialidad inválida\. Debe ser uno de: primer asistente quirurgico, tecnologo quirurgico, enfermero anestesista/
      
      expect { Sanitarios::Asistente.new(id_valido, nombre_valido, turno_valido, especialidad_invalida) }
      .to raise_error(ArgumentError, expected_msg_regex)
    end
  end

   context "pruebas para validar la especilidad para saber si es privada" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::Asistente.private_method_defined?(:validar_especialidad!)).to be true
    end
  end

  context "pruebas del setter" do
    it "NO debe permitir la asignación directa, confirmando que es PRIVATE" do
      expect { asistente_base.especialidad = "tecnologo quirurgico" }.to raise_error(NoMethodError)
      expect(Sanitarios::Asistente.private_method_defined?(:especialidad=)).to be true
    end

    it "debe permitir modificar la 'especialidad' a un valor válido (usando send)" do
      nueva_especialidad = especialidad_alternativa
      
      expect { asistente_base.send(:especialidad=, nueva_especialidad) }
        .to change { asistente_base.especialidad } 
        .from(especialidad_valida)
        .to(nueva_especialidad)
    end

    it "debe lanzar ArgumentError si se intenta modificar la 'especialidad' a un valor inválido (usando send)" do
      expected_msg_regex = /Especialidad inválida\. Debe ser uno de: primer asistente quirurgico, tecnologo quirurgico, enfermero anestesista/
      expect { asistente_base.send(:especialidad=, especialidad_invalida) }
        .to raise_error(ArgumentError, expected_msg_regex)
      expect(asistente_base.especialidad).to eq(especialidad_valida)
    end
  end

  context "Pruebas de Representación de Cadena (to_s)" do
    let(:id_esperado) { 12 }
    let(:nombre_esperado) { "Enfermero Peter" }
    let(:turno_esperado) { "NOCHE" }
    let(:especialidad_esperada) { "tecnologo quirurgico" }

     it "pruebas para validar que es publico" do
      expect(Sanitarios::Asistente.public_method_defined?(:to_s)).to be true
    end

    it "debe generar la cadena formateada correcta con 4 líneas (heredadas + especialidad)" do
      expected_base = "Quirófano ID: #{id_esperado}\n" +  "  Nombre: #{nombre_esperado}\n" + "  Turno: #{turno_esperado}"               
      expected_output = "#{expected_base}\n" + "  Especialidad: #{especialidad_esperada}"                
      expect(asistente_base.to_s).to eq(expected_output)
    end

    it "debe tener exactamente cuatro líneas" do
      output_lines = asistente_base.to_s.split("\n")
      expect(output_lines.length).to eq(4)
    end
    
    it "debe heredar las primeras 3 líneas del to_s del padre (Personal)" do
      output_lines = asistente_base.to_s.split("\n")
      expect(output_lines[0]).to eq("Quirófano ID: #{id_esperado}")
      expect(output_lines[2]).to eq("  Turno: #{turno_esperado}")
    end

    it "debe añadir la información de la Especialidad como la última línea" do
      output_lines = asistente_base.to_s.split("\n")
      expect(output_lines.last).to eq("  Especialidad: #{especialidad_esperada}")
    end
  end

  context "Pruebas de Sobrecarga de Igualdad (==)" do
    let(:otros_base) { Sanitarios::Asistente.new(15, "Auxiliar María", "TARDE", "tecnologo quirurgico") }

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Asistente.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto Personal con los mismos atributos" do
      otro_igual = Sanitarios::Asistente.new(15, "Auxiliar María", "TARDE", "tecnologo quirurgico")
      expect(otros_base).to eq(otro_igual)
    end

    it "NO debe ser igual a otro objeto Personal con diferente atributos" do
      otro_diferente_id = Sanitarios::Asistente.new(1, "Auxiliar María", "TARDE", "tecnologo quirurgico")
      otro_diferente_nombre = Sanitarios::Asistente.new(15, "Auxiliar Mario", "TARDE", "tecnologo quirurgico")
      otro_diferente_turno = Sanitarios::Asistente.new(15, "Auxiliar María", "MAÑANA", "tecnologo quirurgico")
      otro_diferente_especialidad = Sanitarios::Asistente.new(15, "Auxiliar María", "TARDE", "enfermero anestesista")

      expect(otros_base).to_not eq(otro_diferente_id)
      expect(otros_base).to_not eq(otro_diferente_nombre)
      expect(otros_base).to_not eq(otro_diferente_turno)
      expect(otros_base).to_not eq(otro_diferente_especialidad)
    end

    it "NO debe ser igual a una instancia de una subclase (ej: Cirujano) con los mismos atributos, debido a la clase estricta" do
      otro_clase_diferente = Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_completo_q, "ISO 7")
      expect(otros_base).to_not eq(otro_clase_diferente)
    end
  end

  context "verificar que los setters siguen siendo protegidos" do
    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Asistente.protected_method_defined?(:nombre=)).to be true
      expect(Sanitarios::Asistente.protected_method_defined?(:id=)).to be true
      expect(Sanitarios::Asistente.protected_method_defined?(:turno=)).to be true
    end
  end
end