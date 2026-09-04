require_relative 'spec_helper'


RSpec.describe Sanitarios::Bioseguridad do

  let(:cirujano_q) { Sanitarios::Cirujano.new(100, "Dr. Alfa", "MAÑANA", "cirugia general") }
  let(:anestesiologo_q) { Sanitarios::Anestesiologo.new(101, "Dra. Beta", "TARDE", "obstetrica") }
  let(:asistente_q) { Sanitarios::Asistente.new(102, "Enf. Gamma", "NOCHE", "tecnologo quirurgico") }
  let(:otro_q) { Sanitarios::Otros.new(103, "Residente Z", "MAÑANA", "residente") }

  let(:equipo_completo_base) { [cirujano_q, anestesiologo_q, asistente_q] }
  let(:equipo_completo_alternativo) { [asistente_q, otro_q, cirujano_q, anestesiologo_q] }

  let(:equipo_invalido_sin_cirujano) { [anestesiologo_q, asistente_q, otro_q] }
  let(:equipo_invalido_sin_anestesiologo) { [cirujano_q, asistente_q, otro_q] }
  
  let(:iso_valido) { "ISO 7" }
  let(:iso_invalido) { "ISO 4" }

  let(:servicio_bioseguridad_base) { Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_completo_base, iso_valido) }

  let(:id_valido) { 20 }
  let(:estado_valido) { "ESPERANDO" }
  let(:equipo_valido) { equipo_completo_alternativo }

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

      expect(servicio_bioseguridad_base.equipo_medico).to eq(equipo_completo_base)
      expect(servicio_bioseguridad_base.equipo_medico).to be_an_instance_of(Array)
      expect(servicio_bioseguridad_base.equipo_medico.first).to be_a(Sanitarios::Personal)

      expect(servicio_bioseguridad_base.iso).to eq(iso_valido)
      expect(servicio_bioseguridad_base.iso).to be_an_instance_of(String)
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones)" do

    it "debe lanzar ArgumentError si el ID no es un Integer (Heredado)" do
      expect { Sanitarios::Bioseguridad.new("20", estado_valido, equipo_completo_base, iso_valido) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/)
    end

    it "debe lanzar ArgumentError si el estado no es permitido (Heredado)" do
      expect { Sanitarios::Bioseguridad.new(id_valido, "INEXISTENTE", equipo_completo_base, iso_valido) }
      .to raise_error(ArgumentError, /Estado inválido/)
    end

    it "debe lanzar ArgumentError si el equipo médico es nil (Heredado)" do
      expect { Sanitarios::Bioseguridad.new(id_valido, estado_valido, nil, iso_valido) }
      .to raise_error(ArgumentError, /equipo médico no puede estar vacía/)
    end

    it "debe lanzar ArgumentError si el equipo médico está vacío ([]) (Heredado)" do
      expect { Sanitarios::Bioseguridad.new(id_valido, estado_valido, [], iso_valido) }
      .to raise_error(ArgumentError, /equipo médico no puede estar vacía/)
    end
    
    it "debe lanzar ArgumentError si el equipo médico NO tiene al menos un Cirujano" do
      expect { Sanitarios::Bioseguridad.new(id_valido, estado_valido, equipo_invalido_sin_cirujano, iso_valido) }
      .to raise_error(ArgumentError, /debe incluir al menos un Cirujano, un Asistente y un Anestesiólogo/)
    end

    it "debe lanzar ArgumentError si el equipo médico NO tiene al menos un Anestesiólogo" do
      expect { Sanitarios::Bioseguridad.new(id_valido, estado_valido, equipo_invalido_sin_anestesiologo, iso_valido) }
      .to raise_error(ArgumentError, /debe incluir al menos un Cirujano, un Asistente y un Anestesiólogo/)
    end

    it "debe lanzar ArgumentError si el 'iso' no es permitido" do
      expect { Sanitarios::Bioseguridad.new(id_valido, estado_valido, equipo_completo_base, iso_invalido) }
      .to raise_error(ArgumentError, /ISO inválido\. Debe ser uno de: ISO 5, ISO 6, ISO 7/)
    end
  end

  context "Pruebas de Setters para Bioseguridad (ISO y Heredados)" do
    let(:servicio_bioseguridad) {
        Sanitarios::Bioseguridad.new(id_valido, estado_valido, equipo_completo_base, iso_valido)
    }

    it "NO debe permitir la asignación directa de 'iso', confirmando que es PRIVATE" do
      expect { servicio_bioseguridad.iso = "ISO 6" }.to raise_error(NoMethodError)
      expect(Sanitarios::Bioseguridad.private_method_defined?(:iso=)).to be true
    end

    it "debe permitir modificar la lista del equipo medico a un valor válido (usando send)" do
      nuevo_equipo = equipo_completo_alternativo
      expect { servicio_bioseguridad.send(:equipo_medico=, nuevo_equipo) }
        .to change { servicio_bioseguridad.equipo_medico }
        .from(equipo_completo_base)
        .to(nuevo_equipo)
    end

    it "debe lanzar ArgumentError si se intenta modificar el equipo médico a una lista vacía (usando send)" do
      expect { servicio_bioseguridad.send(:equipo_medico=, []) }
      .to raise_error(ArgumentError, /equipo médico no puede estar vacía/)
      expect(servicio_bioseguridad.equipo_medico).to eq(equipo_completo_base)
    end

    it "debe lanzar ArgumentError si se intenta modificar el equipo médico a un equipo incompleto (usando send)" do
      expect { servicio_bioseguridad.send(:equipo_medico=, equipo_invalido_sin_anestesiologo) }
      .to raise_error(ArgumentError, /debe incluir al menos un Cirujano, un Asistente y un Anestesiólogo/)
      expect(servicio_bioseguridad.equipo_medico).to eq(equipo_completo_base)
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
    let(:equipo_join_esperado) { "#{cirujano_q.to_s}, #{anestesiologo_q.to_s}, #{asistente_q.to_s}" }
    let(:iso_esperado) { "ISO 7" }

    it "pruebas para validar que es publico" do
      expect(Sanitarios::Bioseguridad.public_method_defined?(:to_s)).to be true
    end

    it "debe generar la cadena formateada correcta con 4 líneas (incluyendo el ISO y Personal)" do
      expected_output = "Quirófano ID: 5\n" + "  Estado: OCUPADO\n" + "  Equipo Médico: #{equipo_join_esperado}\n" + "  Tipo de ISO: #{iso_esperado}"
      output = servicio_bioseguridad_base.to_s
      expect(output).to eq(expected_output)
      expect(output).to include(cirujano_q.to_s)
    end

    it "debe heredar las líneas del to_s del padre (Quirofano) y añadir el ISO" do
      output_lines = servicio_bioseguridad_base.to_s.split("\n")
      expect(output_lines[0]).to eq("Quirófano ID: 5")
      expect(output_lines.last).to eq("  Tipo de ISO: #{iso_esperado}")
    end
  end

  context "pruebas para validar que es privado" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::Bioseguridad.private_method_defined?(:validar_iso!)).to be true
    end
  end

  context "Pruebas de Sobrecarga de Igualdad (==)" do
    let(:equipo_base_eq) { equipo_completo_base }
    let(:iso_base) { "ISO 7" }
    let(:servicio_bioseguridad_base_eq) { Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_base_eq, iso_base) }

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Bioseguridad.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto Bioseguridad con los mismos atributos" do
      otro_igual = Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_base_eq.dup, iso_base)
      expect(servicio_bioseguridad_base_eq).to eq(otro_igual)
    end

    it "NO debe ser igual a otro objeto Bioseguridad si un atributo es diferente" do
      otro_diferente_id = Sanitarios::Bioseguridad.new(6, "OCUPADO", equipo_base_eq, iso_base)
      otro_diferente_estado = Sanitarios::Bioseguridad.new(5, "DISPONIBLE", equipo_base_eq, iso_base)
      otro_diferente_equipo = Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_completo_alternativo, iso_base)
      otro_diferente_iso = Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_base_eq, "ISO 5")

      expect(servicio_bioseguridad_base_eq).to_not eq(otro_diferente_id)
      expect(servicio_bioseguridad_base_eq).to_not eq(otro_diferente_estado)
      expect(servicio_bioseguridad_base_eq).to_not eq(otro_diferente_equipo)
      expect(servicio_bioseguridad_base_eq).to_not eq(otro_diferente_iso)
    end

    it "NO debe ser igual a una instancia de la clase base (Quirofano) con los mismos atributos" do
      otro_clase_diferente = Sanitarios::Quirofano.new(5, "OCUPADO", equipo_base_eq)
      expect(servicio_bioseguridad_base_eq).to_not eq(otro_clase_diferente)
    end
  end

  context "verificar que los setters siguen siendo protegidos" do
    it "pruebas para validar que el metodo esta definido como protegido" do
      expect(Sanitarios::Bioseguridad.protected_method_defined?(:estado=)).to be true
      expect(Sanitarios::Bioseguridad.protected_method_defined?(:id=)).to be true
      expect(Sanitarios::Bioseguridad.protected_method_defined?(:equipo_medico=)).to be true
    end
  end

  context "Pruebas de Comparación (Comparable y <=>, Heredado)" do
    let(:equipo_pequeno) { equipo_completo_base }
    let(:equipo_medio) { equipo_completo_alternativo } 
    let(:equipo_grande) { [cirujano_q, anestesiologo_q, asistente_q, otro_q, cirujano_q] } 

    let(:quirofano_pequeno) { Sanitarios::Bioseguridad.new(10, "DISPONIBLE", equipo_pequeno, "ISO 7") }
    let(:quirofano_medio) { Sanitarios::Bioseguridad.new(20, "ESPERANDO", equipo_medio, "ISO 6") }
    let(:quirofano_grande) { Sanitarios::Bioseguridad.new(30, "OCUPADO", equipo_grande, "ISO 5") }
    let(:quirofano_igual) { Sanitarios::Bioseguridad.new(99, "ESPERANDO", equipo_pequeno.dup, "ISO 6") }

    it "el método <=> debe estar definido como público (heredado)" do
      expect(Sanitarios::Bioseguridad.public_method_defined?(:<=>)).to be true
    end

    it "debe implementar el método <=> basado en la cantidad de equipo médico" do
      expect(quirofano_grande <=> quirofano_pequeno).to eq(1)
      expect(quirofano_pequeno <=> quirofano_grande).to eq(-1)
      expect(quirofano_pequeno <=> quirofano_igual).to eq(0)
    end

    it "debe permitir usar el operador > (Mayor que)" do
      expect(quirofano_grande > quirofano_medio).to be true
      expect(quirofano_pequeno > quirofano_grande).to be false
    end

    it "debe permitir usar el operador < (Menor que)" do
      expect(quirofano_pequeno < quirofano_medio).to be true
      expect(quirofano_grande < quirofano_pequeno).to be false
    end

    it "debe permitir usar el operador >= (Mayor o igual que)" do
      expect(quirofano_medio >= quirofano_pequeno).to be true
      expect(quirofano_pequeno >= quirofano_igual).to be true
      expect(quirofano_pequeno >= quirofano_medio).to be false
    end
  end
end