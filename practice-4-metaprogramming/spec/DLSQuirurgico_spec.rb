require_relative 'spec_helper' 

RSpec.describe Sanitarios::DSLQuirurgico do
  
  let (:cirugia_mayor_dsl) do
    Sanitarios::DSLQuirurgico.new(400) do
      configuracion tipo: "cirugia mayor",
                    precio: 25000

      equipamiento do
        sistema_anestesia_general 1
        monitor_multiparametro 2
        equipo_reanimacion 1
        ventilador_mecanico 2
      end

      quirofano 105, estado: "OCUPADO", tipo: "ISO 7" do
        personal 5001, nombre: "Dr. LPP", turno: "MAÑANA", especialidad: "cirugia general"
        personal 5002, nombre: "Dra. Luz", turno: "MAÑANA", especialidad: "neurocirugia"
        personal 5020, nombre: "D. Struct", turno: "MAÑANA", especialidad: "cardiovascular"
        personal 5050, nombre: "Asistente A", turno: "MAÑANA", especialidad: "tecnologo quirurgico"
      end

      quirofano 106, estado: "DISPONIBLE", tipo: "Clase A" do
        personal 5003, nombre: "Dr. Mini", turno: "TARDE", especialidad: "cirugia plastica"
        personal 5021, nombre: "Dra. Struct", turno: "TARDE", especialidad: "obstetrica"
        personal 5022, nombre: "Dra. Struct", turno: "TARDE", especialidad: "neuroquirúrgica"
        personal 5051, nombre: "Asistente B", turno: "TARDE", especialidad: "primer asistente quirurgico"
        personal 5052, nombre: "Técnico C", turno: "TARDE", especialidad: "estudiante"
      end

      personal 5004, nombre: "Dr. LPP", turno: "MAÑANA", especialidad: "cirugia general"
      personal 5005, nombre: "Asistente C", turno: "NOCHE", especialidad: "tecnologo quirurgico"
      personal 5006, nombre: "Becario", turno: "TARDE", especialidad: "estudiante"
    end
  end

  let (:cirugia_menor_dsl) do
    Sanitarios::DSLQuirurgico.new(401) do
      configuracion tipo: "cirugia menor",
                    precio: 5000

      equipamiento do
        anestesia_local 1
        monitor_simple 1
      end
      
      quirofano 201, estado: "DISPONIBLE", tipo: "Clase B" do
        personal 6003, nombre: "Dr. Stock", turno: "TARDE", especialidad: "cirugia plastica"
        personal 6021, nombre: "Dra. Mily", turno: "TARDE", especialidad: "neuroquirúrgica"
        personal 6051, nombre: "Asistente B", turno: "TARDE", especialidad: "primer asistente quirurgico"
        personal 6053, nombre: "Técnico H", turno: "TARDE", especialidad: "estudiante"
      end
    end
  end

   context "Configuración de ServicioQuirurgico para Cirugia Mayor y Cirugia Menor" do
    it "pruebas de herencia de cirugia_mayor_dsl" do
      expect(cirugia_mayor_dsl).to be_an_instance_of(Sanitarios::DSLQuirurgico)
      expect(cirugia_mayor_dsl).to be_a(Object)
      expect(cirugia_mayor_dsl).to be_a(BasicObject)
    end

    it "pruebas de herencia de cirugia_menor_dsl" do
      expect(cirugia_menor_dsl).to be_an_instance_of(Sanitarios::DSLQuirurgico)
      expect(cirugia_menor_dsl).to be_a(Object)
      expect(cirugia_menor_dsl).to be_a(BasicObject)
    end
  end

  context "Verificación de la Clase del Servicio Final" do
    it "el objeto servicio final es CirugiaMayor" do
      expect(cirugia_mayor_dsl.servicio).to be_an_instance_of(Sanitarios::CirugiaMayor)
      expect(cirugia_mayor_dsl.servicio).to be_a(Sanitarios::ServicioQuirurgico) 
      expect(cirugia_mayor_dsl.servicio).to be_a(Object)
      expect(cirugia_mayor_dsl.servicio).to be_a(BasicObject)
    end
    it "el objeto servicio final es CirugiaMenor" do
      expect(cirugia_menor_dsl.servicio).to be_an_instance_of(Sanitarios::CirugiaMenor)
      expect(cirugia_menor_dsl.servicio).to be_a(Sanitarios::ServicioQuirurgico)
      expect(cirugia_menor_dsl.servicio).to be_a(Object)
      expect(cirugia_menor_dsl.servicio).to be_a(BasicObject)
    end
  end

  context "Manejo de la Clase Principal (DSLQuirurgico)" do
    it "cirugia_mayor_dsl responde a los diferentes métodos de clase" do
      expect(cirugia_mayor_dsl).to respond_to(:personal)
      expect(cirugia_mayor_dsl).to respond_to(:quirofano)
      expect(cirugia_mayor_dsl).to respond_to(:configuracion)
      expect(cirugia_mayor_dsl).to respond_to(:equipamiento)
    end

    it "cirugia_menor_dsl responde a los diferentes métodos de clase" do
      expect(cirugia_menor_dsl).to respond_to(:personal)
      expect(cirugia_menor_dsl).to respond_to(:quirofano)
      expect(cirugia_menor_dsl).to respond_to(:configuracion)
      expect(cirugia_menor_dsl).to respond_to(:equipamiento)
    end

    it "lanza un error si el tipo es incorrecto" do
      expect {
        Sanitarios::DSLQuirurgico.new(1) do
          configuracion tipo: "cirugia desconocida",
                        precio: 1000
        end
      }.to raise_error(ArgumentError, /Tipo de servicio inválido./)
    end
  end

  context "Pruebas de la configuracion de cirugia_mayor_dsl y cirugia_menor_dsl" do
    it "asigna correctamente el ID y el precio" do
      expect(cirugia_mayor_dsl.servicio.id).to eq(400)
      expect(cirugia_menor_dsl.servicio.id).to eq(401)
    end

    it "asigna correctamente el precio" do
      expect(cirugia_mayor_dsl.servicio.precio).to eq(25000)
      expect(cirugia_menor_dsl.servicio.precio).to eq(5000)
    end
    
    it "recolecta el equipamiento avanzado usando el DSL anidado" do
      expect(cirugia_mayor_dsl.servicio.equipos_avanzados).to include("sistema anestesia general", "monitor multiparametro", "equipo reanimacion", "ventilador mecanico")
      expect(cirugia_menor_dsl.servicio.equipo_simple).to include("anestesia local", "monitor simple")
    end

    it "cuentan con el numero de equipamiento correcto en cirugia mayor" do
      expect(cirugia_mayor_dsl.servicio.equipos_avanzados["sistema anestesia general"]).to eq(1)
      expect(cirugia_mayor_dsl.servicio.equipos_avanzados["monitor multiparametro"]).to eq(2)
      expect(cirugia_mayor_dsl.servicio.equipos_avanzados["equipo reanimacion"]).to eq(1)
      expect(cirugia_mayor_dsl.servicio.equipos_avanzados["ventilador mecanico"]).to eq(2)
      expect(cirugia_mayor_dsl.servicio.equipos_avanzados.count).to eq(4)
    end

    it "cuentan con el numero de equipamiento correcto en cirugia menor" do
      expect(cirugia_menor_dsl.servicio.equipo_simple["anestesia local"]).to eq(1)
      expect(cirugia_menor_dsl.servicio.equipo_simple["monitor simple"]).to eq(1)
      expect(cirugia_menor_dsl.servicio.equipo_simple.count).to eq(2)
    end

    it "crea el número correcto de quirófanos" do
      expect(cirugia_mayor_dsl.servicio.quirofanos.count).to eq(2)
      expect(cirugia_menor_dsl.servicio.quirofanos.count).to eq(1)
    end

    it "crea el quirófano 105 como Bioseguridad (ISO 7) con estado OCUPADO" do
      q1 = cirugia_mayor_dsl.servicio.quirofanos.find { |q| q.id == 105 }
      q2 = cirugia_menor_dsl.servicio.quirofanos.find { |q| q.id == 201 }
      expect(q1).to be_a(Sanitarios::Bioseguridad)
      expect(q1.iso).to eq("ISO 7")
      expect(q1.estado).to eq("OCUPADO")
      expect(q2).to be_a(Sanitarios::Funcional)
      expect(q2.clase).to eq("Clase B")
      expect(q2.estado).to eq("DISPONIBLE")
    end

    it "recolecta todo el personal, incluyendo el del quirófano y el adicional para cirugia mayor" do
      expect(cirugia_mayor_dsl.servicio.personal.count).to eq(12)
      expect(cirugia_mayor_dsl.servicio.personal.map(&:id)).to contain_exactly(5001, 5002, 5003, 5004, 5005, 5006, 5020, 5021, 5022, 5050, 5051, 5052)
    end

    it "crea el personal 5001 correctamente" do
      personal_5001 = cirugia_mayor_dsl.servicio.personal.find { |p| p.id == 5001 }
      expect(personal_5001).to be_a(Sanitarios::Personal)
      expect(personal_5001.nombre).to eq("Dr. LPP")
      expect(personal_5001.turno).to eq("MAÑANA")
      expect(personal_5001.especialidad).to eq("cirugia general")
    end

    it "recolecta todo el personal, incluyendo el del quirófano y el adicional para cirugia menor" do
      expect(cirugia_menor_dsl.servicio.personal.count).to eq(4)
      expect(cirugia_menor_dsl.servicio.personal.map(&:id)).to contain_exactly(6003, 6021, 6051, 6053)
    end

    it "crea el personal 6003 correctamente" do
      personal_6003 = cirugia_menor_dsl.servicio .personal.find { |p| p.id == 6003 }
      expect(personal_6003).to be_a(Sanitarios::Personal)
      expect(personal_6003.nombre).to eq("Dr. Stock")
      expect(personal_6003.turno).to eq("TARDE")
      expect(personal_6003.especialidad).to eq("cirugia plastica")
    end

    it "el personal de quirófano está asignado al quirófano correcto para cirugia mayor" do
      q1 = cirugia_mayor_dsl.servicio.quirofanos.find { |q| q.id == 105 }
      q2 = cirugia_mayor_dsl.servicio.quirofanos.find { |q| q.id == 106 }
      expect(q1.equipo_medico.map(&:id)).to contain_exactly(5001, 5002, 5020, 5050)
      expect(q2.equipo_medico.map(&:id)).to contain_exactly(5003, 5021, 5051, 5022, 5052)
    end

    it "el personal de quirófano está asignado al quirófano correcto para menor mayor" do
      q1 = cirugia_menor_dsl.servicio.quirofanos.find { |q| q.id == 201 }
      expect(q1.equipo_medico.map(&:id)).to contain_exactly(6003, 6021, 6051, 6053)
    end
  end

  context "Pruebas de Restricciones y Errores de Secuencia" do
    it "lanza error si se intenta definir equipamiento antes de definir el tipo" do
      expect {
        Sanitarios::DSLQuirurgico.new(10) do
          equipamiento do
            anestesia_local 1
          end
        end
      }.to raise_error(ArgumentError, /Debe definir el 'tipo' de servicio antes de configurar el equipamiento./)
    end
    
    it "lanza error si el precio no es numérico" do
      expect {
        Sanitarios::DSLQuirurgico.new(10) do
          configuracion precio: "cien"
        end
      }.to raise_error(ArgumentError)
    end
  end

  context "Método to_s del Builder (Documentación de Palabras Reservadas)" do
    let(:output) { cirugia_mayor_dsl.to_s }
    
    it "genera la salida completa del DSL y verifica la estructura principal" do
      expect(output).to be_a(String)
      expect(output).to include("Servicio Quirúrgico: Unidad Quirúrgica LPP")
      expect(output).to include("Tipo: Cirugía Mayor")
      expect(output).to include("Precio : 25000")
      
      expect(output).to include("Equipamiento:")
      expect(output).to include("Salas:")
      expect(output).to include("Personal:")
      
      expect(output).to include(" - Ventilador mecanico : 2")
      
      expect(output).to include(" - Quirófano 105, estado: ocupado, tipo: ISO 7, equipo: (Dr. LPP, Dra. Luz, D. Struct, Asistente A)")
      expect(output).to include(" - Quirófano 106, estado: disponible, tipo: Clase A, equipo: (Dr. Mini, Dra. Struct, Dra. Struct, Asistente B, Técnico C)")
      
      expect(output).to start_with("Servicio Quirúrgico:") 

      expect(output).to include(" - Cirujano 5001, nombre: Dr. LPP")

      expect(output).to include(" - Asistente 5050, nombre: Asistente A")
      
      expect(output).to include(" - Otros 5052, nombre: Técnico C")
    end

    it "genera la salida completa del DSL y verifica la estructura principal para cirugia menor" do
      dsl_menor_output = cirugia_menor_dsl.to_s
      expect(dsl_menor_output).to include("Tipo: Cirugía Menor")
      expect(dsl_menor_output).to include(" - Anestesia local : 1")
      expect(dsl_menor_output).to include(" - Quirófano 201, estado: disponible, tipo: Clase B, equipo: (Dr. Stock, Dra. Mily, Asistente B, Técnico H)")
    end
  end
end