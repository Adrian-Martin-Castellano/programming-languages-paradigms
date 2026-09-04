# frozen_string_literal: true

require_relative 'spec_helper' 

RSpec.describe Sanitarios::CirugiaMayor do
  let(:p_cirujano_q) { Sanitarios::Cirujano.new(10, "Dr. Equipo", "MAÑANA", "cirugia general") }
  let(:p_asistente_q) { Sanitarios::Asistente.new(11, "Enf. Equipo", "MAÑANA", "tecnologo quirurgico") }
  let(:p_anestesista_q) { Sanitarios::Anestesiologo.new(12, "Dr. Anestesia", "NOCHE", "neuroquirúrgica") }
  
  let(:equipo_completo_q) { [p_cirujano_q, p_asistente_q, p_anestesista_q] }
  
  let(:id_valido) { 1 }
  let(:nombre_valido) { "General" }
  let(:precio_valido) { 5000 }

  let(:id_valido2) { 99 }
  let(:nombre_valido2) { "Urgencias y Trauma" }
  let(:precio_valido2) { 15000 }

  let(:p_cirujano) { Sanitarios::Cirujano.new(1, "Dr. Smith", "MAÑANA", "cirugia general") }
  let(:p_asistente) { Sanitarios::Asistente.new(2, "Enf. Pérez", "MAÑANA", "tecnologo quirurgico") }
  let(:personal_valido) { [p_cirujano, p_asistente] } 

  let(:p_anestesista) { Sanitarios::Anestesiologo.new(99, "Dr. Johnson (Anestesista)", "NOCHE", "neuroquirúrgica") }
  let(:personal_validos2) { [p_anestesista] } 

  let(:q_general_1) { Sanitarios::Quirofano.new(201, "DISPONIBLE", equipo_completo_q) }
  let(:q_general_2) { Sanitarios::Bioseguridad.new(202, "OCUPADO", equipo_completo_q, Sanitarios::Bioseguridad::ISO_PERMITIDOS.first) } 
  let(:quirofanos_validos) { [q_general_1, q_general_2] }

  let(:q_trauma_1) { Sanitarios::Funcional.new(901, "ESPERANDO", equipo_completo_q, Sanitarios::Funcional::ESTADOS_PERMITIDOS.first) }
  let(:quirofanos_validos2) { [q_trauma_1] } 

  let(:equipos_requeridos_array) { Sanitarios::CirugiaMayor::EQUIPOS_REQUERIDOS }

  let(:cirugia_mayor_base_temp) do
    Sanitarios::CirugiaMayor.new(id_valido, nombre_valido, quirofanos_validos, personal_valido, precio_valido)
  end

  let(:equipos_requeridos_str) { 
    cirugia_mayor_base_temp.send(:_join_elements, equipos_requeridos_array) 
  }

  let(:cirugia_mayor_base) do
    Sanitarios::CirugiaMayor.new(id_valido, nombre_valido, quirofanos_validos, personal_valido, precio_valido)
  end

  let(:cirugia_mayor_alternativa) do 
    Sanitarios::CirugiaMayor.new(id_valido2, nombre_valido2, quirofanos_validos2, personal_validos2, precio_valido2)
  end

  context "Pruebas de Herencia y Clase" do
    it "cirugia_mayor_base debe ser una instancia de CirugiaMayor" do
      expect(cirugia_mayor_base).to be_an_instance_of(Sanitarios::CirugiaMayor)
      expect(cirugia_mayor_base.class).to eq(Sanitarios::CirugiaMayor)
    end

    it "cirugia_mayor_base debe heredar de ServicioQuirurgico" do
      expect(cirugia_mayor_base).to be_a(Sanitarios::ServicioQuirurgico)
      expect(cirugia_mayor_base).to be_kind_of(Sanitarios::ServicioQuirurgico)
    end

    it "cirugia_mayor_base hereda correctamente de Object y BasicObject" do
      expect(cirugia_mayor_base).to be_a(Object)
      expect(cirugia_mayor_base).to be_a(BasicObject)
    end
  end

  context "Pruebas de Inicialización y Getters (Clase Hija)" do
    it "debe inicializar correctamente y devolver los atributos heredados" do
      expect(cirugia_mayor_base.id).to eq(id_valido)
      expect(cirugia_mayor_base.nombre).to eq(nombre_valido)
      expect(cirugia_mayor_base.precio).to eq(precio_valido)
      expect(cirugia_mayor_base.quirofanos.length).to eq(quirofanos_validos.length)
      expect(cirugia_mayor_base.personal.length).to eq(personal_valido.length)
    end

    it "debe devolver el atributo nuevo 'equipos_avanzados' como un Array fijo de requerimientos" do
      expect(cirugia_mayor_base.equipos_avanzados).to eq(equipos_requeridos_array)
      expect(cirugia_mayor_base.equipos_avanzados).to be_an_instance_of(Array)
    end

    it "debe asegurar que el array de equipos asignado es una COPIA independiente y no la constante original" do
      temp_cm = Sanitarios::CirugiaMayor.new(id_valido, nombre_valido, quirofanos_validos, personal_valido, precio_valido)
      temp_cm.equipos_avanzados << "nuevo_equipo_extra"
      expect(Sanitarios::CirugiaMayor::EQUIPOS_REQUERIDOS.length).to eq(4) 
      expect(temp_cm.equipos_avanzados.length).to eq(5) 
    end
  end

  context "Pruebas de Validación (Heredadas de ServicioQuirurgico)" do
    it "debe lanzar ArgumentError si el nombre no es un String" do
      expect { 
        Sanitarios::CirugiaMayor.new(id_valido, 12345, quirofanos_validos, personal_valido, precio_valido) 
      }.to raise_error(ArgumentError, /nombre debe ser una cadena/)
    end

    it "debe lanzar ArgumentError si el precio no es un Integer" do
      expect { 
        Sanitarios::CirugiaMayor.new(id_valido, nombre_valido, quirofanos_validos, personal_valido, nil) 
      }.to raise_error(ArgumentError, /debe ser un número entero/)
    end


    it "debe lanzar ArgumentError si el ID no es un Integer" do
      expect { 
        Sanitarios::CirugiaMayor.new("1", nombre_valido, quirofanos_validos, personal_valido, precio_valido) 
      }.to raise_error(ArgumentError, /ID debe ser un número/)
    end
  end

  context "to_s (Representación de cadena) para CirugiaMayor" do
    let(:tipo_atencion) { Sanitarios::GruposServicios::QUIRURGICA }

    let(:personal_join_esperado) { personal_valido.map(&:nombre).join(", ") } 
    let(:quirofanos_join_esperado) { quirofanos_validos.map(&:id).join(", ") }

    it "debe tener el to_s definido como publico" do
      expect(Sanitarios::CirugiaMayor.public_method_defined?(:to_s)).to be true
    end

    it "debe sobreescribir el método to_s e incluir todos los Equipos Avanzados Requeridos" do
      parent_output = "Servicio: #{nombre_valido} (ID: #{id_valido})\n" +
                      "   Tipo de Atención: #{tipo_atencion}\n" + 
                      "   Quirófanos Asignados: #{quirofanos_join_esperado}\n" +
                      "   Personal Asignado: #{personal_join_esperado}\n" +
                      "   Precio de uso: #{precio_valido}"

      expected_output = parent_output + "\n   Equipos Avanzados Requeridos: #{equipos_requeridos_str}"
      expect(cirugia_mayor_base.to_s).to eq(expected_output)
    end

    it "debe incluir la lista completa y formateada de equipos requeridos" do
      expect(cirugia_mayor_base.to_s).to include("Equipos Avanzados Requeridos: #{equipos_requeridos_str}")
    end
  end

  context "Pruebas de Comparación (Comparable y <=>)" do
    let(:id_igual) { id_valido }
    let(:nombre_igual) { nombre_valido }
    let(:quirofanos_igual) { quirofanos_validos }
    let(:personal_igual) { personal_valido }
    let(:precio_igual) { 5000 } 

    let(:servicio_igual) do
      Sanitarios::CirugiaMayor.new(id_igual, nombre_igual, quirofanos_igual, personal_igual, precio_igual)
    end

    let(:servicio_barato) { cirugia_mayor_base }
    let(:servicio_caro) { cirugia_mayor_alternativa }

    it "debe tener el <=> definido como publico (Heredado de Comparable)" do
      expect(Sanitarios::CirugiaMayor.public_method_defined?(:<=>)).to be true
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

    it "debe permitir usar el operador == (Igual que) para el precio" do
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

  context "pruebas de coste total de cirugia_mayor" do
    it "el método coste total debe estar definido como público" do
      expect(Sanitarios::CirugiaMayor.public_method_defined?(:coste_total)).to be true
    end

    it "deberia de dar el valor precio correcto" do
      expect(cirugia_mayor_base.coste_total).to eq(5600)
      expect(cirugia_mayor_alternativa.coste_total).to eq(15600)
    end
  end
end