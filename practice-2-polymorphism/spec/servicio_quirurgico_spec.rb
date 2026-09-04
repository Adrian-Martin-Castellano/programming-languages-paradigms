require_relative 'spec_helper'

RSpec.describe Sanitarios::ServicioQuirurgico do
  let(:id_valido) { 1 }
  let(:nombre_valido) { "General" }
  let(:precio_valido) { 5000 }

  let(:id_valido2) { 99 }
  let(:nombre_valido2) { "Urgencias y Trauma" }
  let(:precio_valido2) { 15000 }

  let(:p_cirujano) { Sanitarios::Cirujano.new(1, "Dr. Smith", "MAÑANA", "cirugia general") }
  let(:p_asistente) { Sanitarios::Asistente.new(2, "Enf. Pérez", "MAÑANA", "tecnologo quirurgico") }
  let(:p_anestesista) { Sanitarios::Anestesiologo.new(99, "Dr. Johnson", "NOCHE", "neuroquirúrgica") }
  let(:p_otro) { Sanitarios::Otros.new(100, "Residente X", "MAÑANA", "residente") }

  let(:equipo_completo_q) { [p_cirujano, p_asistente, p_anestesista] }
  let(:equipo_completo_q2) { [p_cirujano, p_asistente, p_anestesista, p_otro] }

  let(:personal_valido) { [p_cirujano, p_asistente] }
  let(:personal_validos2) { [p_anestesista] }

  let(:q_general_1) { Sanitarios::Quirofano.new(201, "DISPONIBLE", equipo_completo_q) }
  let(:q_general_2) { Sanitarios::Bioseguridad.new(202, "OCUPADO", equipo_completo_q2, Sanitarios::Bioseguridad::ISO_PERMITIDOS.first) }
  let(:quirofanos_validos) { [q_general_1, q_general_2] }

  let(:q_trauma_1) { Sanitarios::Funcional.new(901, "ESPERANDO", equipo_completo_q, Sanitarios::Funcional::ESTADOS_PERMITIDOS.first) }
  let(:quirofanos_validos2) { [q_trauma_1] }

  let(:servicio1) do
    Sanitarios::ServicioQuirurgico.new(id_valido, nombre_valido, quirofanos_validos, personal_valido,precio_valido)
  end

  let(:servicio2) do
    Sanitarios::ServicioQuirurgico.new(id_valido2, nombre_valido2, quirofanos_validos2, personal_validos2, precio_valido2)
  end

  let(:servicio_completo) do
    Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_validos, personal_valido, 5000)
  end

  let(:p_tarde) { Sanitarios::Cirujano.new(3, "Dr. House", "TARDE", "neurocirugia") }
  let(:p_noche_extra) { Sanitarios::Asistente.new(4, "Enf. Jane", "NOCHE", "enfermero anestesista") }
  let(:personal_variado) { [p_cirujano, p_asistente, p_tarde, p_noche_extra, p_anestesista] }

  let(:servicio_turnos_variados) do
    Sanitarios::ServicioQuirurgico.new(5, "Turnos Varios", quirofanos_validos, personal_variado, 1000)
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
      expect(servicio1).to be_a(Comparable)
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
      expect(servicio1.quirofanos.length).to eq(quirofanos_validos.length)
      expect(servicio1.quirofanos).to be_an_instance_of(Array)
      expect(servicio1.quirofanos[0]).to be_a(Sanitarios::Quirofano)
    end

    it "debe devolver la lista de personal correcta y como Array" do
      expect(servicio1.personal.length).to eq(personal_valido.length)
      expect(servicio1.personal).to be_an_instance_of(Array)
      expect(servicio1.personal[0]).to be_a(Sanitarios::Personal)
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

      expect(servicio2.quirofanos.length).to eq(1)
      expect(servicio2.quirofanos).to be_an_instance_of(Array)

      expect(servicio2.quirofanos[0]).not_to be_nil
      expect(servicio2.quirofanos[0]).to be_a(Sanitarios::Funcional)

      expect(servicio2.personal.length).to eq(1)
      expect(servicio2.personal).to be_an_instance_of(Array)

      expect(servicio2.personal[0]).not_to be_nil
      expect(servicio2.personal[0]).to be_a(Sanitarios::Anestesiologo)

      expect(servicio2.precio).to eq(precio_valido2)
      expect(servicio2.precio.class).to eq(Integer)
    end
  end

  context "Pruebas de Validación de Inicialización (Restricciones)" do
    let(:id_valido) { 1 }
    let(:nombre_valido) { "General" }
    let(:quirofanos_validos) { [q_general_1] }
    let(:personal_valido) { [p_cirujano] }

    it "debe lanzar ArgumentError si el ID no es un Integer" do
      expect { Sanitarios::ServicioQuirurgico.new("1", nombre_valido, quirofanos_validos, personal_valido, precio_valido) }
      .to raise_error(ArgumentError, /ID debe ser un número/)
    end

    it "debe lanzar ArgumentError si el nombre no es un String" do
      expect { Sanitarios::ServicioQuirurgico.new(id_valido, 12345, quirofanos_validos, personal_valido, precio_valido) }
      .to raise_error(ArgumentError, /nombre debe ser una cadena/)
    end

    it "debe lanzar ArgumentError si la lista de quirófanos está vacía ([])" do
      expect { Sanitarios::ServicioQuirurgico.new(id_valido, nombre_valido, [], personal_valido, precio_valido) }
      .to raise_error(ArgumentError, /quirófanos no puede estar vacía/)
    end

    it "debe lanzar ArgumentError si la lista de personal está vacía ([])" do
      expect { Sanitarios::ServicioQuirurgico.new(id_valido, nombre_valido, quirofanos_validos, [], precio_valido) }
      .to raise_error(ArgumentError, /personal no puede estar vacía/)
    end

    it "debe lanzar ArgumentError si el precio es nil" do
      expect { Sanitarios::ServicioQuirurgico.new(id_valido, nombre_valido, quirofanos_validos, personal_valido, nil) }
      .to raise_error(ArgumentError, /debe ser un número entero/)
    end
  end

  context "Prueba de Inicialización Correcta (Valores Válidos)" do
    it "debe inicializar el servicio correctamente con todos los valores válidos" do
      expect(servicio1).to be_an_instance_of(Sanitarios::ServicioQuirurgico)

      expect(servicio1.id).to eq(1)
      expect(servicio1.id.class).to eq(Integer)

      expect(servicio1.nombre).to eq("General")
      expect(servicio1.nombre.class).to eq(String)

      expect(servicio1.quirofanos.length).to eq(2)
      expect(servicio1.quirofanos).to be_an_instance_of(Array)
      expect(servicio1.quirofanos[0]).to be_a(Sanitarios::Quirofano)

      expect(servicio1.personal.length).to eq(2)
      expect(servicio1.personal).to be_an_instance_of(Array)
      expect(servicio1.personal[0]).to be_a(Sanitarios::Personal)

      expect(servicio1.precio).to eq(5000)
      expect(servicio1.precio.class).to eq(Integer)
    end
  end

  context "Pruebas de Setters (Private con #send)" do
    let(:servicio) { Sanitarios::ServicioQuirurgico.new(1, "Antiguo Nombre", [q_general_1], personal_valido, 1000) }

    it "debe permitir modificar el ID" do
      expect { servicio.send(:id=, 99) }.to change { servicio.id }.from(1).to(99)
    end

    it "debe permitir modificar el nombre" do
      expect { servicio.send(:nombre=, "Nuevo Servicio") }.to change { servicio.nombre }.from("Antiguo Nombre").to("Nuevo Servicio")
    end

    it "debe permitir modificar el precio" do
      expect { servicio.send(:precio=, 10000) }.to change { servicio.precio }.from(1000).to(10000)
    end

    it "NO debe permitir modificar el precio a un valor que no sea Integer" do
      expect { servicio.send(:precio=, "novalido") }.to raise_error(ArgumentError, /debe ser un número entero/)
      expect(servicio.precio).to eq(1000)
    end

    it "debe permitir modificar la lista de quirófanos" do
      nueva_lista = [q_general_2, q_trauma_1]
      expect { servicio.send(:quirofanos=, nueva_lista) }.to change { servicio.quirofanos.length }.from(1).to(2)
      expect(servicio.quirofanos).to eq(nueva_lista)
    end

    it "debe permitir modificar la lista de personal" do
      nuevo_personal = [Sanitarios::Cirujano.new(5, "Dr. Z", "TARDE", "neurocirugia"), Sanitarios::Asistente.new(6, "Enf. D", "TARDE", "enfermero anestesista")]
      expect { servicio.send(:personal=, nuevo_personal) }.to change { servicio.personal }.to(nuevo_personal)
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
      personal_join = "#{p_cirujano.nombre}, #{p_asistente.nombre}"
      quirofanos_ids = "#{q_general_1.id}, #{q_general_2.id}"

      expected_output = "Servicio: General (ID: 1)\n   Tipo de Atención: Atención Quirúrgica\n   Quirófanos Asignados: #{quirofanos_ids}\n" +
                        "   Personal Asignado: #{personal_join}\n   Precio de uso: 5000"

      expect(servicio_completo.to_s).to eq(expected_output)
    end

    it "debe incluir el nombre y el ID correctos en la primera línea" do
      expect(servicio_completo.to_s).to include("Servicio: General (ID: 1)")
    end

    it "debe incluir el tipo de atención en la salida" do
      expect(servicio_completo.to_s).to include("Tipo de Atención: Atención Quirúrgica")
    end

    it "debe incluir el precio de uso en la salida" do
      expect(servicio_completo.to_s).to include("Precio de uso: 5000")
    end
  end

  context "pruebas para validar la especilidad para saber si es privada" do
    it "pruebas para validar tanto NoMethoderror y saber si esta definida como privada" do
      expect(Sanitarios::ServicioQuirurgico.private_method_defined?(:_join_elements)).to be true
    end
  end

  context "Pruebas de Sobrecarga de Igualdad (==)" do

    let(:servicio_base) do
      Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_validos, personal_valido,1000)
    end

    it "pruebas para validar que el metodo es publico" do
      expect(Sanitarios::ServicioQuirurgico.public_method_defined?(:==)).to be true
    end

    it "debe ser IGUAL a otro objeto ServicioQuirurgico con todos los atributos iguales" do
      otro_igual = Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_validos.dup, personal_valido.dup,1000)
      expect(servicio_base).to eq(otro_igual)
      expect(servicio_base == otro_igual).to be true
    end

    it "NO debe ser igual a otro objeto ServicioQuirurgico si un atributo es diferente" do
      otro_diferente_id = Sanitarios::ServicioQuirurgico.new(2, "General", quirofanos_validos, personal_valido, 1000)
      otro_diferente_nombre = Sanitarios::ServicioQuirurgico.new(1, "Emergencia", quirofanos_validos, personal_valido, 1000)
      otro_diferente_quirofanos = Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_validos2, personal_valido, 1000)
      otro_diferente_personal = Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_validos, personal_validos2, 1000)
      otro_diferente_precio = Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_validos, personal_valido, 6000)

      expect(servicio_base).to_not eq(otro_diferente_id)
      expect(servicio_base).to_not eq(otro_diferente_nombre)
      expect(servicio_base).to_not eq(otro_diferente_quirofanos)
      expect(servicio_base).to_not eq(otro_diferente_personal)
      expect(servicio_base).to_not eq(otro_diferente_precio)
    end

    it "NO debe ser igual a un objeto de diferente clase" do
      otro_clase_diferente = Sanitarios::Personal.new(100, "Dr. House", "TARDE")
      expect(servicio_base).to_not eq(otro_clase_diferente)
    end
  end

  context "Pruebas de Funcionalidad: Número de Quirófanos (#num_quirofanos)" do
    it "el método num_quirofanos debe estar definido como público" do
      expect(Sanitarios::ServicioQuirurgico.public_method_defined?(:num_quirofanos)).to be true
    end

    it "debe devolver la cantidad correcta de quirófanos para servicio1 (2)" do
      expect(servicio1.num_quirofanos).to eq(2)
      expect(servicio1.num_quirofanos).to be_an_instance_of(Integer)
    end

    it "debe devolver la cantidad correcta de quirófanos para servicio2 (1)" do
      expect(servicio2.num_quirofanos).to eq(1)
    end
  end

  context "Pruebas de Funcionalidad: Cantidad de Personal (#num_personal)" do
    it "el método num_personal debe estar definido como público" do
      expect(Sanitarios::ServicioQuirurgico.public_method_defined?(:num_personal)).to be true
    end

    it "debe devolver la cantidad correcta de personal para servicio1 (2)" do
      expect(servicio1.num_personal).to eq(2)
      expect(servicio1.num_personal).to be_an_instance_of(Integer)
    end

    it "debe devolver la cantidad correcta de personal para servicio2 (1)" do
      expect(servicio2.num_personal).to eq(1)
    end
  end

  context "Pruebas de Funcionalidad: Determinación de Estados Individuales (#obtener_estados_individuales)" do

    it "el método obtener_estados_individuales debe estar definido como público" do
        expect(Sanitarios::ServicioQuirurgico.public_method_defined?(:obtener_estados_individuales)).to be true
    end

    it "debe devolver un array de strings con el estado individual de cada quirófano, incluyendo su ID" do
        resultados_esperados = [
            "Estado de Quirofano ID: 201 = DISPONIBLE",
            "Estado de Quirofano ID: 202 = OCUPADO"
        ]

        resultado = servicio1.obtener_estados_individuales

        expect(resultado).to be_an_instance_of(Array)
        expect(resultado.length).to eq(2)
        expect(resultado).to eq(resultados_esperados)
    end

    it "debe funcionar correctamente con el servicio2 (1 quirófano)" do
        resultados_esperados = [
            "Estado de Quirofano ID: 901 = ESPERANDO"
        ]

        resultado = servicio2.obtener_estados_individuales
        expect(resultado).to eq(resultados_esperados)
    end

    it "debe devolver un array vacío si la lista de quirófanos estuviera vacía" do
        servicio_temporal_vacio = Sanitarios::ServicioQuirurgico.new(4, "Test Vacio", quirofanos_validos, personal_valido, 1)
        servicio_temporal_vacio.instance_variable_set(:@quirofanos, [])
        expect(servicio_temporal_vacio.obtener_estados_individuales).to eq([])
    end
  end

  context "Pruebas de Funcionalidad: Total Personal por Turno (#total_personal_turno)" do
    it "el método total_personal_turno debe estar definido como público" do
      expect(Sanitarios::ServicioQuirurgico.public_method_defined?(:total_personal_turno)).to be true
    end

    it "debe devolver la cantidad correcta para un único turno (servicio_completo)" do
      resultados_esperados = { "MAÑANA" => 2 }
      expect(servicio_completo.total_personal_turno).to eq(resultados_esperados)
    end

    it "debe devolver la cantidad correcta para un único turno con una sola persona (servicio2)" do
      resultados_esperados = { "NOCHE" => 1 }
      expect(servicio2.total_personal_turno).to eq(resultados_esperados)
    end

    it "debe devolver la cantidad correcta para múltiples turnos" do
      resultados_esperados = { "MAÑANA" => 2, "TARDE" => 1, "NOCHE" => 2 }
      resultado = servicio_turnos_variados.total_personal_turno
      expect(resultado).to be_an_instance_of(Hash)
      expect(resultado).to eq(resultados_esperados)
    end

    it "debe devolver un Hash vacío si el servicio no tiene personal asignado" do
      servicio_temporal_vacio = Sanitarios::ServicioQuirurgico.new(4, "Test Vacio", quirofanos_validos, personal_valido, 1)
      servicio_temporal_vacio.instance_variable_set(:@personal, [])
      expect(servicio_temporal_vacio.total_personal_turno).to eq({})
    end
  end

  context "Pruebas de Comparación (Comparable y <=>)" do
    let(:precio_igual) { 5000 }
    let(:servicio_igual) do
      Sanitarios::ServicioQuirurgico.new(id_valido, nombre_valido, quirofanos_validos.dup, personal_valido.dup, precio_igual)
    end

    let(:servicio_barato) { servicio1 }
    let(:servicio_caro) { servicio2 }

    it "el método <=> debe estar definido como público (heredado del módulo Comparable)" do
      expect(Sanitarios::ServicioQuirurgico.public_method_defined?(:<=>)).to be true
    end

    it "debe implementar el método <=> basado en el precio" do
      expect(servicio_caro <=> servicio_barato).to eq(1)
      expect(servicio_barato <=> servicio_caro).to eq(-1)
      expect(servicio_barato <=> servicio_igual).to eq(0)
    end

    it "debe permitir usar el operador > (Mayor que)" do
      expect(servicio_caro > servicio_barato).to be true
      expect(servicio_barato > servicio_caro).to be false
    end

    it "debe permitir usar el operador < (Menor que)" do
      expect(servicio_barato < servicio_caro).to be true
      expect(servicio_caro < servicio_barato).to be false
    end

    it "debe permitir usar el operador == (Igual que) para la IGUALDAD COMPLETA de atributos" do
      expect(servicio_barato == servicio_igual).to be true
      expect(servicio_barato == servicio_caro).to be false
    end

    it "debe permitir usar el operador >= (Mayor o igual que)" do
      expect(servicio_caro >= servicio_barato).to be true
      expect(servicio_barato >= servicio_igual).to be true
      expect(servicio_barato >= servicio_caro).to be false
    end

    it "debe permitir usar el método #between?" do
      expect(servicio_barato.between?(servicio_igual, servicio_caro)).to be true
      expect(servicio_caro.between?(servicio_barato, servicio_igual)).to be false
    end
  end

  context "pruebas de coste total de servicio_quiruugico" do
    it "el método coste total debe estar definido como público" do
      expect(Sanitarios::ServicioQuirurgico.public_method_defined?(:coste_total)).to be true
    end

    it "deberia de dar el valor precio correcto" do
      expect(servicio1.coste_total).to eq(5000)
      expect(servicio2.coste_total).to eq(15000)
    end
  end
end