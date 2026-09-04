require_relative 'spec_helper' 

RSpec.describe Sanitarios::Anestesiologo do
  let(:id_valido) { 303 }
  let(:nombre_valido) { "Dr. Harris" }
  let(:turno_valido) { "MAÑANA" }
  let(:turno_invalido) { "MADRUGADA" }
  let(:especialidad1) { "cardiovascular" }
  let(:especialidad_invalida) { "no existe" }

  let(:anestesiologo_base) { Sanitarios::Anestesiologo.new(60, nombre_valido, turno_valido, especialidad1) }

  let(:p_cirujano) { Sanitarios::Cirujano.new(100, "Dr. Equipo", "MAÑANA", "cirugia general") }
  let(:p_asistente) { Sanitarios::Asistente.new(101, "Enf. Equipo", "MAÑANA", "tecnologo quirurgico") }
  let(:p_anestesista) { Sanitarios::Anestesiologo.new(102, "Dr. Anestesia", "NOCHE", "obstetrica") }
  let(:equipo_completo_q) { [p_cirujano, p_asistente, p_anestesista] }

  context "Pruebas de Clase Exacta (instance_of?)" do
    it "anestesiologo_base debe ser una instancia de Anestesiologo" do
      expect(anestesiologo_base).to be_an_instance_of(Sanitarios::Anestesiologo)
      expect(anestesiologo_base.class).to eq(Sanitarios::Anestesiologo)
    end
  end

  context "Pruebas de Herencia y Tipo (be_a / kind_of?)" do
    it "anestesiologo_base se identifica como su propia clase" do
      expect(anestesiologo_base).to be_a(Sanitarios::Anestesiologo)
      expect(anestesiologo_base).to be_kind_of(Sanitarios::Anestesiologo)
    end

    it "anestesiologo_base hereda correctamente de Personal" do
      expect(anestesiologo_base).to be_a(Sanitarios::Personal) 
    end
    
    it "anestesiologo_base hereda correctamente de Object y BasicObject" do
      expect(anestesiologo_base).to be_a(Object)
      expect(anestesiologo_base).to be_a(BasicObject)
    end
  end

  context "Pruebas de Inicialización y Getters (Heredados)" do
    it "debe devolver los atributos ID, Nombre y Turno correctamente desde la clase base" do
      expect(anestesiologo_base.id).to eq(60)
      expect(anestesiologo_base.nombre).to eq(nombre_valido)
      expect(anestesiologo_base.turno).to eq(turno_valido)
      expect(anestesiologo_base.especialidad).to eq(especialidad1)
    end
    
    it "debe mantener los tipos correctos (Integer y String)" do
      expect(anestesiologo_base.id).to be_an_instance_of(Integer)
      expect(anestesiologo_base.nombre).to be_an_instance_of(String)
      expect(anestesiologo_base.turno).to be_an_instance_of(String)
      expect(anestesiologo_base.especialidad).to be_an_instance_of(String)
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones Heredadas)" do
    
    it "debe lanzar ArgumentError si el ID no es un Integer (Validación de Personal)" do
      expect { Sanitarios::Anestesiologo.new("60", nombre_valido, turno_valido, especialidad1) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/)
    end
    
    it "debe lanzar ArgumentError si el nombre no es una String (Validación de Personal)" do
      expect { Sanitarios::Anestesiologo.new(id_valido, 123, turno_valido, especialidad1) }
      .to raise_error(ArgumentError, /El nombre debe ser una cadena de texto/)
    end

    it "debe lanzar ArgumentError si el turno no es permitido (Validación de Personal)" do
      expect { Sanitarios::Anestesiologo.new(id_valido, nombre_valido, turno_invalido, especialidad1) }
      .to raise_error(ArgumentError, /Turno inválido\. Debe ser uno de: MAÑANA, TARDE, NOCHE/)
    end

    it "debe lanzar ArgumentError si la especialidad no esta permitida" do 
      expect { Sanitarios::Anestesiologo.new(id_valido, nombre_valido, turno_valido, especialidad_invalida) }
      .to raise_error(ArgumentError, /Especialidad inválida\. Debe ser uno de: cardiovascular, obstetrica, neuroquirúrgica/)
    end
  end

  context "pruebas para validar la especilidad para saber si es privada" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::Anestesiologo.private_method_defined?(:validar_especialidad!)).to be true
    end
  end

  context "Pruebas de Setter para especialidad" do
    let(:especialidad_valida) { "obstetrica" }
    let(:especialidad_invalida2) { "algo" }

    it "NO debe permitir la asignación directa, confirmando que es PRIVATE" do
      expect { anestesiologo_base.especialidad = "obstetrica" }.to raise_error(NoMethodError)
      expect(Sanitarios::Anestesiologo.private_method_defined?(:especialidad=)).to be true
    end

		it "debe permitir modificar la 'especialidad' a un valor válido (usando send)" do
      nueva_especialidad = especialidad_valida 
      expect { anestesiologo_base.send(:especialidad=, nueva_especialidad) }
        .to change { anestesiologo_base.especialidad }
        .from(especialidad1)
        .to(nueva_especialidad)
    end

    it "debe lanzar ArgumentError si se intenta modificar la 'especialidad' a un valor inválido" do
      expected_msg_regex = /Especialidad inválida\. Debe ser uno de: cardiovascular, obstetrica, neuroquirúrgica/
      expect { anestesiologo_base.send(:especialidad=, especialidad_invalida2) }
        .to raise_error(ArgumentError, expected_msg_regex)
        
      expect(anestesiologo_base.especialidad).to eq(especialidad1)
    end
	end

  context "Pruebas de Representación de Cadena (to_" do
    let(:id_valido) { 202 }
    let(:nombre_valido) { "Dr. Smith" }
    let(:turno_valido) { "NOCHE" }
    let(:especialidad1) { "neuroquirúrgica" }
    let(:anestesiologo_base) { Sanitarios::Anestesiologo.new(id_valido, nombre_valido, turno_valido, especialidad1) }

    it "pruebas para validar que es publico" do
      expect(Sanitarios::Anestesiologo.public_method_defined?(:to_s)).to be true
    end

    it "debe generar la cadena formateada correcta con 4 líneas (heredadas + especialidad)" do
      expected_base = "Quirófano ID: #{id_valido}\n" + "  Nombre: #{nombre_valido}\n" + "  Turno: #{turno_valido}"							
      expected_output = "#{expected_base}\n" + "  Especialidad: #{especialidad1}"
                        
      expect(anestesiologo_base.to_s).to eq(expected_output)
    end
    
    it "debe heredar las primeras 3 líneas del to_s del padre (Personal)" do
      output_lines = anestesiologo_base.to_s.split("\n")
      expect(output_lines[0]).to eq("Quirófano ID: #{id_valido}")
      expect(output_lines[2]).to eq("  Turno: #{turno_valido}")
    end

    it "debe añadir la información de la Especialidad como la última línea" do
      output_lines = anestesiologo_base.to_s.split("\n")
      expect(output_lines.last).to eq("  Especialidad: #{especialidad1}")
    end
  end

  context "Pruebas de Sobrecarga de Igualdad (==)" do
    let(:otros_base) { Sanitarios::Anestesiologo.new(15, "Auxiliar María", "TARDE", "cardiovascular") }

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Anestesiologo.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto Personal con los mismos atributos" do
      otro_igual = Sanitarios::Anestesiologo.new(15, "Auxiliar María", "TARDE", "cardiovascular")
      expect(otros_base).to eq(otro_igual)
    end

    it "NO debe ser igual a otro objeto Personal con diferente atributos" do
      otro_diferente_id = Sanitarios::Anestesiologo.new(1, "Auxiliar María", "TARDE", "cardiovascular")
      otro_diferente_nombre = Sanitarios::Anestesiologo.new(15, "Auxiliar Mario", "TARDE", "cardiovascular")
      otro_diferente_turno = Sanitarios::Anestesiologo.new(15, "Auxiliar María", "MAÑANA", "cardiovascular")
      otro_diferente_especialidad = Sanitarios::Anestesiologo.new(15, "Auxiliar María", "TARDE", "obstetrica")

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
      expect(Sanitarios::Anestesiologo.protected_method_defined?(:nombre=)).to be true
      expect(Sanitarios::Anestesiologo.protected_method_defined?(:id=)).to be true
      expect(Sanitarios::Anestesiologo.protected_method_defined?(:turno=)).to be true
    end
  end
end