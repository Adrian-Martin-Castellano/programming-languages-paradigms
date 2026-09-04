require_relative 'spec_helper'

RSpec.describe Sanitarios::Funcional do
  let(:clase_valida) { "Clase A" }
  let(:clase_invalida) { "Clase Z" }

  let(:servicio_funcional_base) { Sanitarios::Funcional.new(1, "DISPONIBLE", ["Anestesista", "Cirujano"], clase_valida) }
  
  let(:id_valido) { 10 }
  let(:estado_valido) { "ESPERANDO" }
  let(:equipo_valido) { ["Enfermera B"] }

  context "Pruebas de Clase Exacta (instance_of?)" do
    it "servicio_funcional_base debe ser una instancia de Funcional" do
      expect(servicio_funcional_base).to be_an_instance_of(Sanitarios::Funcional)
      expect(servicio_funcional_base.class).to eq(Sanitarios::Funcional)
    end
  end

  context "Pruebas de Herencia y Tipo (be_a / kind_of?)" do
    it "servicio_funcional_base se identifica como su propia clase" do
      expect(servicio_funcional_base).to be_a(Sanitarios::Funcional)
      expect(servicio_funcional_base).to be_kind_of(Sanitarios::Funcional)
    end

    it "servicio_funcional_base hereda correctamente de Quirofano" do
      expect(servicio_funcional_base).to be_a(Sanitarios::Quirofano) 
    end
    
    it "servicio_funcional_base hereda correctamente de Object y BasicObject" do
      expect(servicio_funcional_base).to be_a(Object)
      expect(servicio_funcional_base).to be_a(BasicObject)
    end
  end

  context "Pruebas de Inicialización y Getters (attr_reader)" do
    it "debe devolver los atributos heredados y el nuevo atributo 'clase'" do
      expect(servicio_funcional_base.id).to eq(1)
      expect(servicio_funcional_base.estado).to eq("DISPONIBLE")
      expect(servicio_funcional_base.equipo_medico).to eq(["Anestesista", "Cirujano"])
    
      expect(servicio_funcional_base.clase).to eq(clase_valida)
      expect(servicio_funcional_base.clase).to be_an_instance_of(String)
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones)" do
     
    it "debe lanzar ArgumentError si el ID no es un Integer (Heredado)" do
      expect { Sanitarios::Funcional.new("10", estado_valido, equipo_valido, clase_valida) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/)
    end
    
    it "debe lanzar ArgumentError si el estado no es permitido (Heredado)" do
      expect { Sanitarios::Funcional.new(id_valido, "INEXISTENTE", equipo_valido, clase_valida) }
      .to raise_error(ArgumentError, /Estado inválido/)
    end
    
    it "debe lanzar ArgumentError si el equipo médico es nil (Heredado)" do
      expect { Sanitarios::Funcional.new(id_valido, estado_valido, nil, clase_valida) }
      .to raise_error(ArgumentError, /equipo médico no puede estar vacía/)
    end
    
    it "debe lanzar ArgumentError si la 'clase' no es permitida" do
      expect { Sanitarios::Funcional.new(id_valido, estado_valido, equipo_valido, clase_invalida) }
      .to raise_error(ArgumentError, /Estado inválido\. Debe ser uno de: Clase A, Clase B, Clase C/)
    end
  end

	context "Pruebas de Setters para Clase Funcional (Protected)" do
    let(:clase_valida) { "Clase A" }
    let(:clase_invalida) { "Clase Z" }
    let(:estado_valido) { "DISPONIBLE" }
    let(:equipo_valido) { ["Cirujano X"] } 
    let(:servicio_funcional) { 
        Sanitarios::Funcional.new(10, estado_valido, equipo_valido, clase_valida) 
    }

    it "NO debe permitir la asignación directa, confirmando que es PRIVATE" do
      expect { servicio_funcional.clase = "Clase A" }.to raise_error(NoMethodError)
      expect(Sanitarios::Funcional.private_method_defined?(:clase=)).to be true
    end

    it "debe permitir modificar la 'clase' a un valor válido (usando send)" do
      nueva_clase = "Clase C"
      expect { servicio_funcional.send(:clase=, nueva_clase) }
      .to change { servicio_funcional.clase }.from(clase_valida).to(nueva_clase)
    end

    it "debe lanzar ArgumentError si se intenta modificar la 'clase' a un valor inválido (usando send)" do
      expect { servicio_funcional.send(:clase=, clase_invalida) }
      .to raise_error(ArgumentError, /Estado inválido/)
      expect(servicio_funcional.clase).to eq(clase_valida)
    end
  end

	context "Pruebas de Representación de Cadena " do
		let(:equipo_join_esperado) { "Anestesista, Cirujano" }
		let(:clase_esperada) { "Clase A" }

    it "pruebas para validar que es publico" do
      expect(Sanitarios::Funcional.public_method_defined?(:to_s)).to be true
    end

		it "debe generar la cadena formateada correcta incluyendo atributos heredados y propios" do
			expected_output = "Quirófano ID: 1\n" +	"  Estado: DISPONIBLE\n" +	"  Equipo Médico: #{equipo_join_esperado}\n" + 	"  Clase Funcional: #{clase_esperada}"       								
			expect(servicio_funcional_base.to_s).to eq(expected_output)
		end

		it "debe incluir la información base del Quirófano llamando a super" do
			output_lines = servicio_funcional_base.to_s.split("\n")
			expect(output_lines[0]).to eq("Quirófano ID: 1")
			expect(output_lines[2]).to end_with("Equipo Médico: #{equipo_join_esperado}")
		end

		it "debe añadir la información de la clase funcional como la última línea" do
			output_lines = servicio_funcional_base.to_s.split("\n")
			expect(output_lines.length).to eq(4) 
			expect(output_lines.last).to eq("  Clase Funcional: #{clase_esperada}")
		end
	end

  context "pruebas para validar la especilidad para saber si es privada" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::Funcional.private_method_defined?(:validar_clase!)).to be true
    end
  end

  context "Pruebas de Sobrecarga de Igualdad (==)" do
    let(:id_base) { 1 }
    let(:estado_base) { "DISPONIBLE" }
    let(:equipo_base) { ["Anestesista", "Cirujano"] }
    let(:clase_base) { "Clase A" }
    let(:servicio_funcional_base) { Sanitarios::Funcional.new(id_base, estado_base, equipo_base, clase_base) }

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Funcional.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto Funcional con los mismos atributos" do
      otro_igual = Sanitarios::Funcional.new(id_base, estado_base, equipo_base.dup, clase_base)
      expect(servicio_funcional_base).to eq(otro_igual)
    end

    it "NO debe ser igual a otro objeto Funcional si un atributo es diferente" do
      otro_diferente_id = Sanitarios::Funcional.new(2, estado_base, equipo_base, clase_base)
      otro_diferente_estado = Sanitarios::Funcional.new(id_base, "OCUPADO", equipo_base, clase_base)
      otro_diferente_equipo = Sanitarios::Funcional.new(id_base, estado_base, ["Enfermero"], clase_base)
      otro_diferente_clase = Sanitarios::Funcional.new(id_base, estado_base, equipo_base, "Clase C")

      expect(servicio_funcional_base).to_not eq(otro_diferente_id)
      expect(servicio_funcional_base).to_not eq(otro_diferente_estado)
      expect(servicio_funcional_base).to_not eq(otro_diferente_equipo)
      expect(servicio_funcional_base).to_not eq(otro_diferente_clase)
    end

    it "NO debe ser igual a una instancia de la clase base (Quirofano) con los mismos atributos" do
      otro_clase_diferente = Sanitarios::Quirofano.new(id_base, estado_base, equipo_base)
      expect(servicio_funcional_base).to_not eq(otro_clase_diferente)
    end
  end

  context "verificar que los setters siguen siendo protegidos" do
    it "pruebas para validar que el metodo esta definido como protegido" do
      expect(Sanitarios::Funcional.protected_method_defined?(:estado=)).to be true
      expect(Sanitarios::Funcional.protected_method_defined?(:id=)).to be true
      expect(Sanitarios::Funcional.protected_method_defined?(:equipo_medico=)).to be true
    end
  end
end