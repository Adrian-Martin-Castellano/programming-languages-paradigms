require_relative 'spec_helper'


RSpec.describe Sanitarios::Quirofano do
  let(:cirujano_q) { Sanitarios::Cirujano.new(100, "Dr. Alfa", "MAÑANA", "cirugia general") }
  let(:anestesiologo_q) { Sanitarios::Anestesiologo.new(101, "Dra. Beta", "TARDE", "obstetrica") }
  let(:asistente_q) { Sanitarios::Asistente.new(102, "Enf. Gamma", "NOCHE", "tecnologo quirurgico") }
  let(:otro_q) { Sanitarios::Otros.new(103, "Residente Z", "MAÑANA", "residente") }

  let(:equipo_valido_objetos) { [cirujano_q, anestesiologo_q] } 
  let(:equipo_alternativo_objetos) { [asistente_q, otro_q] } 
  let(:equipo_diferente_objetos) { [cirujano_q, asistente_q] } 
  
  let(:servicio_base) { Sanitarios::Quirofano.new(1, "DISPONIBLE", equipo_valido_objetos) }
  
  let(:id_valido) { 10 }
  let(:estado_valido) { "ESPERANDO" }
  context "Pruebas de Clase Exacta (instance_of?)" do
    it "servicio_base debe ser una instancia de Quirofano" do
      expect(servicio_base.class).to eq(Sanitarios::Quirofano)
      expect(servicio_base).to be_an_instance_of(Sanitarios::Quirofano)
    end

    it "servicio_base debe ser una instancia de Quirofano" do
      expect(servicio_base.class).to eq(Sanitarios::Quirofano)
      expect(servicio_base).to be_an_instance_of(Sanitarios::Quirofano)
    end
  end

  context "Pruebas de Herencia y Tipo (be_a / kind_of?)" do
    it "servicio_base se identifica como su propia clase" do
      expect(servicio_base).to be_a(Sanitarios::Quirofano)
      expect(servicio_base).to be_kind_of(Sanitarios::Quirofano)
    end

    it "servicio_base hereda correctamente de Object y BasicObject" do
      expect(servicio_base).to be_a(Object)
      expect(servicio_base).to be_a(BasicObject)
    end
  end
  
  context "Pruebas de Inicialización y Getters (attr_reader)" do
    let(:id_esperado) { 1 }
    let(:estado_esperado) { "DISPONIBLE" }
    
    it "debe devolver el ID correcto" do
      expect(servicio_base.id).to eq(id_esperado)
    end

    it "debe devolver el estado correcto" do
      expect(servicio_base.estado).to eq(estado_esperado)
    end

    it "debe devolver el equipo médico correcto y como Array de objetos Personal" do
      expect(servicio_base.equipo_medico).to eq(equipo_valido_objetos)
      expect(servicio_base.equipo_medico).to be_an_instance_of(Array)
      expect(servicio_base.equipo_medico.first).to be_a(Sanitarios::Personal)
      expect(servicio_base.equipo_medico.first).to be_an_instance_of(Sanitarios::Cirujano)
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones)" do
    it "debe lanzar ArgumentError si el ID no es un Integer" do
      expect { Sanitarios::Quirofano.new("10", estado_valido, equipo_valido_objetos) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/)
    end
    
    it "debe lanzar ArgumentError si el estado no es permitido" do
      expect { Sanitarios::Quirofano.new(id_valido, "INEXISTENTE", equipo_valido_objetos) }
      .to raise_error(ArgumentError, /Estado inválido/)
    end

    it "debe lanzar ArgumentError si el ID es nil o vacío (String)" do
      expect { Sanitarios::Quirofano.new(nil, estado_valido, equipo_valido_objetos) }
      .to raise_error(ArgumentError, /ID debe ser un número entero/) 
    end

    it "debe lanzar ArgumentError si el equipo médico está vacío ([])" do
      expect { Sanitarios::Quirofano.new(id_valido, estado_valido, []) }
      .to raise_error(ArgumentError, /equipo médico no puede estar vacía/)
    end
    
    it "debe lanzar ArgumentError si el equipo médico es nil" do
      expect { Sanitarios::Quirofano.new(id_valido, estado_valido, nil) }
      .to raise_error(ArgumentError, /equipo médico no puede estar vacía/)
    end
  end

  context "Prueba de Inicialización Correcta (Verificación de Tipos)" do
    it "debe inicializar el quirófano correctamente con tipos válidos (Personal)" do
      expect(servicio_base).to be_an_instance_of(Sanitarios::Quirofano)

      expect(servicio_base.id).to eq(1)
      expect(servicio_base.id).to be_an_instance_of(Integer)

      expect(servicio_base.estado).to eq("DISPONIBLE")
      expect(servicio_base.estado).to be_an_instance_of(String)

      expect(servicio_base.equipo_medico).to eq(equipo_valido_objetos)
      expect(servicio_base.equipo_medico).to be_an_instance_of(Array)
      expect(servicio_base.equipo_medico.first).to be_a(Sanitarios::Personal)
    end
  end

  context "Pruebas de Clase Exacta (instance_of?)" do
    it "servicio_base debe ser una instancia de Quirofano" do
      expect(servicio_base.class).to eq(Sanitarios::Quirofano)
      expect(servicio_base).to be_an_instance_of(Sanitarios::Quirofano)
    end

    it "servicio_base debe ser una instancia de Quirofano" do
      expect(servicio_base.class).to eq(Sanitarios::Quirofano)
      expect(servicio_base).to be_an_instance_of(Sanitarios::Quirofano)
    end
  end

  context "Pruebas de Herencia y Tipo (be_a / kind_of?)" do
    it "servicio_base se identifica como su propia clase" do
      expect(servicio_base).to be_a(Sanitarios::Quirofano)
      expect(servicio_base).to be_kind_of(Sanitarios::Quirofano)
    end

    it "servicio_base hereda correctamente de Object y BasicObject" do
      expect(servicio_base).to be_a(Object)
      expect(servicio_base).to be_a(BasicObject)
    end
  end

  context "Verificar que los setters son protected" do
    it "deberia estar definido como metodo protegido" do
      expect(Sanitarios::Quirofano.protected_method_defined?(:estado=)).to be true
      expect(Sanitarios::Quirofano.protected_method_defined?(:id=)).to be true
      expect(Sanitarios::Quirofano.protected_method_defined?(:equipo_medico=)).to be true
    end
  end

  context "Pruebas de Setters (Protected con #send)" do 
    let(:servicio) { Sanitarios::Quirofano.new(1, "DISPONIBLE", equipo_alternativo_objetos) }
    
    it "debe permitir modificar el ID a un valor Integer válido (usando send)" do
      expect { servicio.send(:id=, 99) }.to change { servicio.id }.from(1).to(99)
    end

    it "debe permitir modificar el estado a un valor válido (usando send)" do
      expect { servicio.send(:estado=, "OCUPADO") }.to change { servicio.estado }.from("DISPONIBLE").to("OCUPADO")
    end

    it "debe permitir modificar la lista del equipo medico a un valor válido (usando send)" do
      expect { servicio.send(:equipo_medico=, equipo_valido_objetos) }
        .to change { servicio.equipo_medico }.from(equipo_alternativo_objetos).to(equipo_valido_objetos)
      expect(servicio.equipo_medico).to eq(equipo_valido_objetos)
    end

    it "NO debe permitir modificar el ID a un valor que no sea Integer (usando send)" do
      expect { servicio.send(:id=, "novalido") }.to raise_error(ArgumentError, /ID debe ser un número entero/)
      expect(servicio.id).to eq(1)
    end
    
    it "debe lanzar ArgumentError si se intenta modificar el estado a un valor inválido (usando send)" do
      expect { servicio.send(:estado=, "FUERA_DE_SERVICIO") }.to raise_error(ArgumentError, /Estado inválido/)
      expect(servicio.estado).to eq("DISPONIBLE")
    end

    it "debe lanzar ArgumentError si se intenta modificar el equipo médico a una lista vacía (usando send)" do
      expect { servicio.send(:equipo_medico=, []) }.to raise_error(ArgumentError, /equipo médico no puede estar vacía/)
      expect(servicio.equipo_medico).to eq(equipo_alternativo_objetos)
    end
    
    it "debe lanzar ArgumentError si se intenta modificar el equipo médico a nil (usando send)" do
      expect { servicio.send(:equipo_medico=, nil) }.to raise_error(ArgumentError, /equipo médico no puede estar vacía/)
      expect(servicio.equipo_medico).to eq(equipo_alternativo_objetos)
    end
  end

  context "Pruebas de Representación de Cadena (to_s)" do
    
    it "pruebas para validar que es publico" do
      expect(Sanitarios::Quirofano.public_method_defined?(:to_s)).to be true
    end

    it "debe generar la cadena formateada correcta, incluyendo el to_s completo de los objetos Personal" do
      cirujano_str = cirujano_q.to_s
      anestesiologo_str = anestesiologo_q.to_s
      equipo_join_esperado = "#{cirujano_str}, #{anestesiologo_str}"
      expected_output = "Quirófano ID: 1\n" + "  Estado: DISPONIBLE\n" + "  Equipo Médico: #{equipo_join_esperado}"
      output = servicio_base.to_s
      expect(output).to eq(expected_output)
      expect(output).to include(cirujano_str)
      expect(output).to include(anestesiologo_str)
    end
  end

  context "Pruebas de Sobrecarga de Igualdad (==)" do
    let(:equipo_base_objetos_eq) { equipo_valido_objetos }
    let(:servicio_base_eq) { Sanitarios::Quirofano.new(1, "DISPONIBLE", equipo_base_objetos_eq) }

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::Quirofano.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto Quirofano con los mismos atributos" do
      otro_igual = Sanitarios::Quirofano.new(1, "DISPONIBLE", equipo_base_objetos_eq.dup) 
      expect(servicio_base_eq).to eq(otro_igual)
    end

    it "NO debe ser igual a otro objeto Quirofano si un atributo es diferente" do
      otro_diferente_id = Sanitarios::Quirofano.new(2, "DISPONIBLE", equipo_base_objetos_eq)
      otro_diferente_estado = Sanitarios::Quirofano.new(1, "OCUPADO", equipo_base_objetos_eq)
      otro_diferente_equipo = Sanitarios::Quirofano.new(1, "DISPONIBLE", equipo_diferente_objetos)

      expect(servicio_base_eq).to_not eq(otro_diferente_id)
      expect(servicio_base_eq).to_not eq(otro_diferente_estado)
      expect(servicio_base_eq).to_not eq(otro_diferente_equipo)
    end
    
    it "NO debe ser igual a un objeto de diferente clase" do
      otro_clase_diferente= Sanitarios::Anestesiologo.new(60, "Dr. Harris", "MAÑANA", "cardiovascular")
      expect(servicio_base_eq).to_not eq(otro_clase_diferente)
    end
  end

  context "pruebas para validar que es privado" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::Quirofano.private_method_defined?(:validar_estado!)).to be true
    end
  end

  context "pruebas para validar que es privado" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::Quirofano.private_method_defined?(:_join_elements)).to be true
    end
  end
end