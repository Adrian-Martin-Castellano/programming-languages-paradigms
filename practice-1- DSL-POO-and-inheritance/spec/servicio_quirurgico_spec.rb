require_relative 'spec_helper'


RSpec.describe Sanitarios::ServicioQuirurgico do
  let(:id_valido) { 1 }
  let(:nombre_valido) { "General" }
  let(:quirofanos_validos) { ["Q1", "Q2"] }
  let(:personal_valido) { ["Dr. Smith", "Enf. Pérez"] }
  
  let(:servicio1) do
    Sanitarios::ServicioQuirurgico.new(id_valido, nombre_valido, quirofanos_validos, personal_valido)
  end

  let(:id_valido2) { 99 }
  let(:nombre_valido2) { "Urgencias y Trauma" }
  let(:quirofanos_validos2) { ["Q_Trauma_1"] }
  let(:personal_validos2) { ["Dr. Johnson (Anestesista)"] }

  let(:servicio2) do
    Sanitarios::ServicioQuirurgico.new(id_valido2, nombre_valido2, quirofanos_validos2, personal_validos2)
  end

  let(:servicio_completo) do
    Sanitarios::ServicioQuirurgico.new(1, "General", ["Q1", "Q2"], ["Dr. Smith", "Enf. Pérez"])
  end

  let(:servicio_vacio) do
    Sanitarios::ServicioQuirurgico.new(2, "Ambulatorio", [], [])
  end

	context "Pruebas de Clase Exacta (instance_of?)" do
    it "servicio1 debe ser una instancia de ServicioQuirurgico" do
      expect(servicio1.class).to eq(Sanitarios::ServicioQuirurgico)
      expect(servicio1).to be_an_instance_of(Sanitarios::ServicioQuirurgico)
      expect(servicio1.instance_of?(Sanitarios::ServicioQuirurgico)).to be true
    end
    
    it "servicio1 debe ser una instancia de ServicioQuirurgico" do
      expect(servicio1.class).to eq(Sanitarios::ServicioQuirurgico)
      expect(servicio1).to be_an_instance_of(Sanitarios::ServicioQuirurgico)
    end
    
  end

	context "Pruebas de Herencia y Tipo (be_a / kind_of?)" do
    it "servicio1 se identifica como su propia clase" do
      expect(servicio1).to be_a(Sanitarios::ServicioQuirurgico)
      expect(servicio1).to be_kind_of(Sanitarios::ServicioQuirurgico)
    end

    it "servicio1 hereda correctamente de Object y BasicObject" do
      expect(servicio1).to be_a(Object)
      expect(servicio1).to be_a(BasicObject)
    end
  end

  context "Pruebas de Inicialización y Getters (attr_reader)" do
    it "debe devolver el ID correcto" do
      expect(servicio1.id).to eq(id_valido)
    end

    it "debe devolver el nombre correcto" do
      expect(servicio1.nombre).to eq(nombre_valido)
    end

    it "debe devolver la lista de quirófanos correcta y como Array" do
      expect(servicio1.quirofanos).to eq(quirofanos_validos)
      expect(servicio1.quirofanos).to be_an_instance_of(Array)
    end

    it "debe devolver la lista de personal correcta y como Array" do
      expect(servicio1.personal).to eq(personal_valido)
      expect(servicio1.personal).to be_an_instance_of(Array)
    end

    it "debe devolver el tipo de atención correcto (Atención Quirúrgica)" do
      expect(servicio1.tipo).to eq(Sanitarios::GruposServicios::QUIRURGICA)
      expect(servicio1.tipo.class).to eq(String)
    end
	end

  context "Prueba Única de Inicialización Correcta con Datos Alternativos" do
    it "debe inicializar el servicio correctamente con el conjunto de datos alternativo" do
      expect(servicio2.id).to eq(id_valido2)
      expect(servicio2.id.class).to eq(Integer)

      expect(servicio2.nombre).to eq(nombre_valido2)
      expect(servicio2.nombre.class).to eq(String)

      expect(servicio2.quirofanos).to eq(quirofanos_validos2)
      expect(servicio2.quirofanos).to be_an_instance_of(Array)

      expect(servicio2.quirofanos[0]).not_to be_nil 


      expect(servicio2.personal).to eq(personal_validos2)
      expect(servicio2.personal).to be_an_instance_of(Array)

      expect(servicio2.personal[0]).not_to be_nil
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones)" do
    let(:id_valido) { 1 }
    let(:nombre_valido) { "General" }
    let(:quirofanos_validos) { ["Q1", "Q2"] }
    let(:personal_valido) { ["Dr. Smith", "Enf. Pérez"] }

    it "debe lanzar ArgumentError si el ID no es un Integer" do
			expect { Sanitarios::ServicioQuirurgico.new("1", nombre_valido, quirofanos_validos, personal_valido) }
			.to raise_error(ArgumentError, /ID debe ser un número/)
    end

    it "debe lanzar ArgumentError si el nombre no es un String" do
			expect { Sanitarios::ServicioQuirurgico.new(id_valido, 12345, quirofanos_validos, personal_valido) }
			.to raise_error(ArgumentError, /nombre debe ser una cadena/)
    end

    it "debe lanzar ArgumentError si la lista de quirófanos está vacía ([])" do
			expect { Sanitarios::ServicioQuirurgico.new(id_valido, nombre_valido, [], personal_valido) }
			.to raise_error(ArgumentError, /quirófanos no puede estar vacía/)
    end
    
    it "debe lanzar ArgumentError si la lista de personal está vacía ([])" do
			expect { Sanitarios::ServicioQuirurgico.new(id_valido, nombre_valido, quirofanos_validos, []) }
			.to raise_error(ArgumentError, /personal no puede estar vacía/)
    end
  end

  context "Prueba de Inicialización Correcta (Valores Válidos)" do
		it "debe inicializar el servicio correctamente con todos los valores válidos" do
			expect(servicio1).to be_an_instance_of(Sanitarios::ServicioQuirurgico)

			expect(servicio1.id).to eq(1)
			expect(servicio1.id.class).to eq(Integer)

			expect(servicio1.nombre).to eq("General")
			expect(servicio1.nombre.class).to eq(String)

			expect(servicio1.quirofanos).to eq(["Q1", "Q2"])
			expect(servicio1.quirofanos).to be_an_instance_of(Array)

			expect(servicio1.quirofanos[0].class).to eq(String)

			expect(servicio1.personal).to eq(["Dr. Smith", "Enf. Pérez"])
			expect(servicio1.personal).to be_an_instance_of(Array)
			expect(servicio1.personal[0].class).to eq(String)
		end
	end

	context "Pruebas de Setters (Private con #send)" do
    let(:servicio) { Sanitarios::ServicioQuirurgico.new(1, "Antiguo Nombre", ["Q1"], ["Dr. A"]) }

    it "debe permitir modificar el ID" do
      expect { servicio.send(:id=, 99) }.to change { servicio.id }.from(1).to(99)
    end

    it "debe permitir modificar el nombre" do
      expect { servicio.send(:nombre=, "Nuevo Servicio") }.to change { servicio.nombre }.from("Antiguo Nombre").to("Nuevo Servicio")
    end

    it "debe permitir modificar la lista de quirófanos" do
      nueva_lista = ["Q3", "Q4"]
      expect { servicio.send(:quirofanos=, nueva_lista) }.to change { servicio.quirofanos }.from(["Q1"]).to(nueva_lista)
      expect(servicio.quirofanos).to eq(nueva_lista)
    end

    it "debe permitir modificar la lista de personal" do
      nuevo_personal = ["Enf. D", "Dr. Z"]
      expect { servicio.send(:personal=, nuevo_personal) }.to change { servicio.personal }.from(["Dr. A"]).to(nuevo_personal)
      expect(servicio.personal).to eq(nuevo_personal)
    end

    it "NO debe permitir modificar el ID a un valor que no sea Integer" do
      expect { servicio.send(:id=, "novalido") }.to raise_error(ArgumentError, /ID debe ser un número entero/)
    end

    it "NO debe permitir modificar el nombre a un valor que no sea String" do
      expect { servicio.send(:nombre=, 123) }.to raise_error(ArgumentError, /nombre debe ser una cadena/)
    end

    it "debe lanzar ArgumentError si se intenta modificar quirófanos a lista vacía" do
      expect { servicio.send(:quirofanos=, []) }.to raise_error(ArgumentError, /quirófanos no puede estar vacía/)
    end

    it "debe lanzar ArgumentError si se intenta modificar personal a lista vacía" do
      expect { servicio.send(:personal=, []) }.to raise_error(ArgumentError, /personal no puede estar vacía/)
    end
  end

	context "to_s (Representación de cadena)" do

    it "pruebas para validar que es publico" do
      expect(Sanitarios::ServicioQuirurgico.public_method_defined?(:to_s)).to be true
    end

    it "debe generar la cadena formateada correcta para un servicio completo" do
      expected_output = "Servicio: General (ID: 1)\n  Tipo de Atención: Atención Quirúrgica\n  Quirófanos Asignados: Q1, Q2\n" + "  Personal Asignado: Dr. Smith, Enf. Pérez"
      expect(servicio_completo.to_s).to eq(expected_output)
    end

    it "debe incluir el nombre y el ID correctos en la primera línea" do
      expect(servicio_completo.to_s).to include("Servicio: General (ID: 1)")
    end
    
    it "debe incluir el tipo de atención en la salida" do
      expect(servicio_completo.to_s).to include("Tipo de Atención: Atención Quirúrgica")
    end
  end

  context "pruebas para validar la especilidad para saber si es privada" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::ServicioQuirurgico.private_method_defined?(:_join_elements)).to be true
    end
  end

  context "Pruebas de Sobrecarga de Igualdad (==)" do
    let(:quirofanos_base) { ["Q1", "Q2"] }
    let(:personal_base) { ["Dr. Smith", "Enf. Pérez"] }
    let(:servicio_base) do
      Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_base, personal_base)
    end

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::ServicioQuirurgico.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto ServicioQuirurgico con todos los atributos iguales" do
      otro_igual = Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_base.dup, personal_base.dup) 
      expect(servicio_base).to eq(otro_igual)
      expect(servicio_base == otro_igual).to be true
    end

    it "NO debe ser igual a otro objeto ServicioQuirurgico si un atributo es diferente" do
      otro_diferente_id = Sanitarios::ServicioQuirurgico.new(2, "General", quirofanos_base, personal_base)
      otro_diferente_nombre = Sanitarios::ServicioQuirurgico.new(1, "Emergencia", quirofanos_base, personal_base)
      otro_diferente_quirofanos = Sanitarios::ServicioQuirurgico.new(1, "General", ["Q5", "Q6"], personal_base)
      otro_diferente_personal = Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_base, ["Dr. Jones"])
      
      expect(servicio_base).to_not eq(otro_diferente_id)
      expect(servicio_base).to_not eq(otro_diferente_nombre)
      expect(servicio_base).to_not eq(otro_diferente_quirofanos)
      expect(servicio_base).to_not eq(otro_diferente_personal)
    end

    it "NO debe ser igual a un objeto de diferente clase" do
      otro_clase_diferente = Sanitarios::Personal.new(100, "Dr. House", "TARDE") 
      expect(servicio_base).to_not eq(otro_clase_diferente)
    end
  end

  context "Pruebas de Método de Clase: self.count_personal" do
    let(:cirujano1) { Sanitarios::Cirujano.new(10, "Dr. House", "MAÑANA", "cirugia general") } 
    let(:anestesiologo1) { Sanitarios::Anestesiologo.new(20, "Dra. Smith", "TARDE", "obstetrica") }
    let(:asistente1) { Sanitarios::Asistente.new(30, "Enf. Pérez", "MAÑANA", "tecnologo quirurgico") } 
    let(:otros1) { Sanitarios::Otros.new(40, "Residente X", "NOCHE", "residente") }
    before(:all) do
      Sanitarios::ServicioQuirurgico.class_variable_set(:@@contador_personal, 0)
    end

    it "pruebas para validar que el metodo es público de clase" do
      expect(Sanitarios::ServicioQuirurgico).to respond_to(:count_personal)
      expect(Sanitarios::ServicioQuirurgico.respond_to?(:count_personal)).to be true
    end

    it "debe devolver 0 antes de la creación del primer servicio" do
      expect(Sanitarios::ServicioQuirurgico.count_personal).to eq(0)
    end

    it "debe acumular el personal del primer servicio" do
      servicio_a = Sanitarios::ServicioQuirurgico.new(100, "Servicio A", ["Q1", "Q2"], [cirujano1, anestesiologo1, asistente1, otros1])
      expect(Sanitarios::ServicioQuirurgico.count_personal).to eq(4) 
    end

    it "debe acumular el personal de un segundo servicio" do
      personal_extra = [
        Sanitarios::Cirujano.new(50, "Dr. Z", "TARDE", "neurocirugia"),
        Sanitarios::Asistente.new(60, "Enf. W", "NOCHE", "primer asistente quirurgico")
      ]
      servicio_b = Sanitarios::ServicioQuirurgico.new(101, "Servicio B", ["Q3"], personal_extra)
      expect(Sanitarios::ServicioQuirurgico.count_personal).to eq(6) 
    end
  end

  context "Pruebas de Método de Clase: self.count_quirofanos (Contador Global Acumulado)" do
    let(:equipo_base) { ["Lámpara Quirúrgica", "Máquina de Anestesia"] }
    let(:funcional1) { Sanitarios::Funcional.new(1, "DISPONIBLE", equipo_base, "Clase A") } # 1
    let(:bioseguridad1) { Sanitarios::Bioseguridad.new(2, "OCUPADO", equipo_base, "ISO 7") } # 1
    let(:quirofano_base1) { Sanitarios::Quirofano.new(3, "ESPERANDO", equipo_base) } # 1

    let(:funcional_extra) { Sanitarios::Funcional.new(4, "DISPONIBLE", equipo_base, "Clase C") } # 1
    let(:bioseguridad_extra) { Sanitarios::Bioseguridad.new(5, "OCUPADO", equipo_base, "ISO 5") } # 1

    before(:all) do
      Sanitarios::ServicioQuirurgico.class_variable_set(:@@contador_quirofanos, 0)
    end

    it "pruebas para validar que el metodo es público de clase" do
      expect(Sanitarios::ServicioQuirurgico).to respond_to(:count_quirofanos)
      expect(Sanitarios::ServicioQuirurgico.respond_to?(:count_quirofanos)).to be true
    end

    it "debe devolver 0 antes de la creación del primer servicio" do
      expect(Sanitarios::ServicioQuirurgico.count_quirofanos).to eq(0)
    end

    it "debe acumular los quirófanos del primer servicio (3 miembros)" do
      quirofanos_a = [funcional1, bioseguridad1, quirofano_base1]
      servicio_a = Sanitarios::ServicioQuirurgico.new(100, "Servicio Quirofanos Mix", quirofanos_a, ["Personal Dummy"])
      expect(Sanitarios::ServicioQuirurgico.count_quirofanos).to eq(3) 
    end

    it "debe acumular los quirófanos de un segundo servicio (3 + 2 = 5)" do
      quirofanos_b = [funcional_extra, bioseguridad_extra] 
      servicio_b = Sanitarios::ServicioQuirurgico.new(101, "Servicio Quirofanos Extra", quirofanos_b, ["Personal Dummy"])
      expect(Sanitarios::ServicioQuirurgico.count_quirofanos).to eq(5) 
    end
  end
end