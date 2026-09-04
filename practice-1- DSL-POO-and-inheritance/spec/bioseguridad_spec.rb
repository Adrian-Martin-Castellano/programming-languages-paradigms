require_relative 'spec_helper'

RSpec.describe Sanitarios::Bioseguridad do
  let(:iso_valido) { "ISO 7" }
  let(:iso_invalido) { "ISO 4" }

  let(:servicio_bioseguridad_base) { Sanitarios::Bioseguridad.new(5, "OCUPADO", ["Biólogo", "Técnico"], iso_valido) }
  
  let(:id_valido) { 20 }
  let(:estado_valido) { "ESPERANDO" }
  let(:equipo_valido) { ["Limpiador"] }

  context "Pruebas de Clase Exacta (instance_of?)" do
    it "servicio_bioseguridad_base debe ser una instancia de Bioseguridad" do
      expect(servicio_bioseguridad_base).to be_an_instance_of(Sanitarios::Bioseguridad)
      expect(servicio_bioseguridad_base.class).to eq(Sanitarios::Bioseguridad)
    end
  end

  context "Pruebas de Herencia y Tipo (be_a / kind_of?)" do
    it "servicio_bioseguridad_base se identifica como su propia clase" do
      expect(servicio_bioseguridad_base).to be_a(Sanitarios::Bioseguridad)
      expect(servicio_bioseguridad_base).to be_kind_of(Sanitarios::Bioseguridad)
    end

    it "servicio_bioseguridad_base hereda correctamente de Quirofano" do
      expect(servicio_bioseguridad_base).to be_a(Sanitarios::Quirofano) 
    end
    
    it "servicio_bioseguridad_base hereda correctamente de Object y BasicObject" do
      expect(servicio_bioseguridad_base).to be_a(Object)
      expect(servicio_bioseguridad_base).to be_a(BasicObject)
    end
  end

  context "Pruebas de Inicialización y Getters (attr_reader)" do
    it "debe devolver los atributos heredados y el nuevo atributo 'iso'" do
      expect(servicio_bioseguridad_base.id).to eq(5)
      expect(servicio_bioseguridad_base.estado).to eq("OCUPADO")
      expect(servicio_bioseguridad_base.equipo_medico).to eq(["Biólogo", "Técnico"])
      
      expect(servicio_bioseguridad_base.iso).to eq(iso_valido)
      expect(servicio_bioseguridad_base.iso).to be_an_instance_of(String)
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones)" do
    
    it "debe lanzar ArgumentError si el ID no es un Integer (Heredado)" do
      expect { Sanitarios::Bioseguridad.new("20", estado_valido, equipo_valido, iso_valido) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/)
    end
    
    it "debe lanzar ArgumentError si el estado no es permitido (Heredado)" do
      expect { Sanitarios::Bioseguridad.new(id_valido, "INEXISTENTE", equipo_valido, iso_valido) }
      .to raise_error(ArgumentError, /Estado inválido/)
    end
    
    it "debe lanzar ArgumentError si el equipo médico es nil (Heredado)" do
      expect { Sanitarios::Bioseguridad.new(id_valido, estado_valido, nil, iso_valido) }
      .to raise_error(ArgumentError, /equipo médico no puede estar vacía/)
    end
    
    it "debe lanzar ArgumentError si el 'iso' no es permitido" do
      expect { Sanitarios::Bioseguridad.new(id_valido, estado_valido, equipo_valido, iso_invalido) }
      .to raise_error(ArgumentError, /ISO inválido\. Debe ser uno de: ISO 5, ISO 6, ISO 7/)
    end
  end

  context "Pruebas de Setters para Bioseguridad (ISO)" do
    let(:servicio_bioseguridad) { 
        Sanitarios::Bioseguridad.new(id_valido, estado_valido, equipo_valido, iso_valido) 
    }

    it "NO debe permitir la asignación directa, confirmando que es PRIVATE" do
      expect { servicio_bioseguridad.iso = "ISO 6" }.to raise_error(NoMethodError)
      expect(Sanitarios::Bioseguridad.private_method_defined?(:iso=)).to be true
    end

    it "debe permitir modificar el 'iso' a un valor válido (usando send)" do
      nuevo_iso = "ISO 5"
      expect { servicio_bioseguridad.send(:iso=, nuevo_iso) }
        .to change { servicio_bioseguridad.iso }
        .from(iso_valido)
        .to(nuevo_iso)
    end

    it "debe lanzar ArgumentError si se intenta modificar el 'iso' a un valor inválido (usando send)" do
      expect { servicio_bioseguridad.send(:iso=, iso_invalido) }
        .to raise_error(ArgumentError, /ISO inválido/)
      expect(servicio_bioseguridad.iso).to eq(iso_valido)
    end
  end

	context "Pruebas de Representación de Cadena (to_s)" do
		let(:equipo_join_esperado) { "Biólogo, Técnico" }
		let(:iso_esperado) { "ISO 7" }

    it "pruebas para validar que es publico" do
      expect(Sanitarios::Bioseguridad.public_method_defined?(:to_s)).to be true
    end

		it "debe generar la cadena formateada correcta con 4 líneas (incluyendo el ISO)" do
			expected_output = "Quirófano ID: 5\n" + "  Estado: OCUPADO\n" + "  Equipo Médico: #{equipo_join_esperado}\n" + "  Tipo de ISO: #{iso_esperado}" 
												
			expect(servicio_bioseguridad_base.to_s).to eq(expected_output)
		end

		it "debe heredar las primeras 3 líneas del to_s del padre (Quirofano)" do
			output_lines = servicio_bioseguridad_base.to_s.split("\n")
			expect(output_lines[0]).to eq("Quirófano ID: 5")
			expect(output_lines[2]).to end_with("Equipo Médico: #{equipo_join_esperado}")
		end

		it "debe añadir la información del ISO como la última línea" do
			output_lines = servicio_bioseguridad_base.to_s.split("\n")
			expect(output_lines.length).to eq(4) 
			expect(output_lines.last).to eq("  Tipo de ISO: #{iso_esperado}")
		end
	end

  context "pruebas para validar la especilidad para saber si es privada" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::Bioseguridad.private_method_defined?(:validar_iso!)).to be true
    end
  end

  context "Pruebas de Sobrecarga de Igualdad (==)" do
    let(:equipo_base) { ["Biólogo", "Técnico"] }
    let(:iso_base) { "ISO 7" }
    let(:servicio_bioseguridad_base) { Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_base, iso_base) }

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Bioseguridad.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto Bioseguridad con los mismos atributos" do
      otro_igual = Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_base.dup, iso_base)
      expect(servicio_bioseguridad_base).to eq(otro_igual)
    end

    it "NO debe ser igual a otro objeto Bioseguridad si un atributo es diferente" do
      otro_diferente_id = Sanitarios::Bioseguridad.new(6, "OCUPADO", equipo_base, iso_base)
      otro_diferente_estado = Sanitarios::Bioseguridad.new(5, "DISPONIBLE", equipo_base, iso_base)
      otro_diferente_equipo = Sanitarios::Bioseguridad.new(5, "OCUPADO", ["Biólogo"], iso_base)
      otro_diferente_iso = Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_base, "ISO 5")

      expect(servicio_bioseguridad_base).to_not eq(otro_diferente_id)
      expect(servicio_bioseguridad_base).to_not eq(otro_diferente_estado)
      expect(servicio_bioseguridad_base).to_not eq(otro_diferente_equipo)
      expect(servicio_bioseguridad_base).to_not eq(otro_diferente_iso)
    end

    it "NO debe ser igual a una instancia de la clase base (Quirofano) con los mismos atributos" do
      otro_clase_diferente = Sanitarios::Quirofano.new(5, "OCUPADO", equipo_base)
      expect(servicio_bioseguridad_base).to_not eq(otro_clase_diferente)
    end
  end

  context "verificar que los setters siguen siendo protegidos" do
    it "pruebas para validar que el metodo esta definido como protegido" do
      expect(Sanitarios::Bioseguridad.protected_method_defined?(:estado=)).to be true
      expect(Sanitarios::Bioseguridad.protected_method_defined?(:id=)).to be true
      expect(Sanitarios::Bioseguridad.protected_method_defined?(:equipo_medico=)).to be true
    end
  end
end