require_relative 'spec_helper' 

RSpec.describe "Pruebas de polimorfismo" do
  let(:p_cirujano) { Sanitarios::Cirujano.new(1, "Dr. Smith", "MAÑANA", "cirugia general") }
  let(:p_asistente) { Sanitarios::Asistente.new(2, "Enf. Pérez", "MAÑANA", "tecnologo quirurgico") }
  let(:p_anestesista) { Sanitarios::Anestesiologo.new(99, "Dr. Johnson (Anestesista)", "NOCHE", "neuroquirúrgica") }
  let(:p_otro) { Sanitarios::Otros.new(100, "Residente Y", "TARDE", "residente") }

  let(:equipo_completo_q) { [p_cirujano, p_asistente, p_anestesista] } 
  let(:equipo_grande_q) { [p_cirujano, p_asistente, p_anestesista, p_otro] } 
  let(:personal_valido) { [p_cirujano, p_asistente] }
  let(:personal_validos2) { [p_anestesista] } 

  let(:q_general_1) { Sanitarios::Quirofano.new(201, "DISPONIBLE", equipo_completo_q) } 
  let(:q_general_2) { Sanitarios::Bioseguridad.new(202, "OCUPADO", equipo_grande_q, Sanitarios::Bioseguridad::ISO_PERMITIDOS.first) } 
  let(:quirofanos_validos) { [q_general_1, q_general_2] } 

  let(:q_trauma_1) { Sanitarios::Funcional.new(901, "ESPERANDO", equipo_completo_q, Sanitarios::Funcional::ESTADOS_PERMITIDOS.first) } 
  let(:quirofanos_validos2) { [q_trauma_1] } 

  let(:servicio1) do
    Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_validos, personal_valido, 5000)
  end

  let(:servicio2) do
    Sanitarios::ServicioQuirurgico.new(99, "Urgencias", quirofanos_validos2, personal_validos2, 15000) 
  end

  let(:servicio3) do
    Sanitarios::ServicioQuirurgico.new(3, "Neuro", quirofanos_validos, personal_validos2, 10000) 
  end

  let(:cirugia_mayor) { Sanitarios::CirugiaMayor.new(10, "Cirugía Mayor Test", quirofanos_validos, personal_valido, 20000) }
  let(:cirugia_menor) { Sanitarios::CirugiaMenor.new(20, " Cirugía Menor Test", quirofanos_validos2, personal_validos2, 8000) }
  let(:personal_base) { Sanitarios::Personal.new(1000, "Base Prof.", "MAÑANA") }

  context "Pruebas de polimorfismo del método .fusion" do
    it "debe permitir fusionar instancias de las subclases CirugiaMayor y CirugiaMenor" do
      cirugia_mayor = Sanitarios::CirugiaMayor.new(10, "Cirugía Mayor Test", quirofanos_validos, personal_valido, 20000)
      cirugia_menor = Sanitarios::CirugiaMenor.new(20, " Cirugía Menor Test", quirofanos_validos2, personal_validos2, 8000)
      servicio_fusionado = Sanitarios.fusion(cirugia_mayor, cirugia_menor)
      expect(servicio_fusionado).to be_a(Sanitarios::ServicioQuirurgico)
      expect(servicio_fusionado.nombre).to eq("Cirugía Mayor Test- Cirugía Menor Test")
      expect(servicio_fusionado.id).to eq(1020)
      expect(servicio_fusionado.precio).to eq(28000)  
    end

    it "uitlizar respond to para verificar que el objeto fusionado responde a los métodos de ServicioQuirurgico" do
      cirugia_mayor = Sanitarios::CirugiaMayor.new(10, "Cirugía Mayor Test", quirofanos_validos, personal_valido, 20000)
      cirugia_menor = Sanitarios::CirugiaMenor.new(20, " Cirugía Menor Test", quirofanos_validos2, personal_validos2, 8000)
      servicio_fusionado = Sanitarios.fusion(cirugia_mayor, cirugia_menor)  
      expect(servicio_fusionado).to respond_to(:id)
      expect(servicio_fusionado).to respond_to(:nombre)
      expect(servicio_fusionado).to respond_to(:quirofanos)
      expect(servicio_fusionado).to respond_to(:personal)
      expect(servicio_fusionado).to respond_to(:precio)
      expect(servicio_fusionado).to respond_to(:==)
      expect(servicio_fusionado).to respond_to(:to_s)
      expect(servicio_fusionado).to respond_to(:num_personal)
      expect(servicio_fusionado).to respond_to(:num_personal)
      expect(servicio_fusionado).to respond_to(:obtener_estados_individuales)
      expect(servicio_fusionado).to respond_to(:total_personal_turno)
    end
  end

  let(:quirofano1) do 
    q_general_1 = Sanitarios::Quirofano.new(201, "DISPONIBLE", equipo_completo_q) 
  end

  let(:personal1) do 
    p_cirujano = Sanitarios::Cirujano.new(1, "Dr. Smith", "MAÑANA", "cirugia general")
    [p_cirujano] 
  end

  context "Pruebas de Polimorfismo del método to_s" do
    it "cada tipo de servicio debe mostrar información específica en su to_s " do
      servicios = [
        Sanitarios::ServicioQuirurgico.new(1, "Base", [quirofano1], personal1, 1000),
        Sanitarios::CirugiaMayor.new(2, "Mayor", [quirofano1], personal1, 5000),
        Sanitarios::CirugiaMenor.new(3, "Menor", [quirofano1], personal1, 3000)
      ]

      textos = servicios.map(&:to_s)
      expect(textos[0]).to_not eq(textos[1])
      expect(textos[1]).to_not eq(textos[2])
      expect(textos[0]).to_not eq(textos[2])
    end

    it "el to_s de CirugiaMayor contiene la sección de 'Equipos Avanzados Requeridos'" do
      cirugia_mayor = Sanitarios::CirugiaMayor.new(2, "Mayor", [quirofano1], personal1, 5000)
      expect(cirugia_mayor.to_s).to include("Equipos Avanzados Requeridos")
    end

    it "el to_s de CirugiaMenor contiene la sección de 'Equipos Simples Requeridos'" do
      cirugia_menor = Sanitarios::CirugiaMenor.new(3, "Menor", [quirofano1], personal1, 3000)
      expect(cirugia_menor.to_s).to include("Equipos Simples Requeridos")
    end

    it "el to_s de ServicioQuirurgico NO contiene secciones especializadas" do
      servicio_base = Sanitarios::ServicioQuirurgico.new(1, "Base", [quirofano1], personal1, 1000)
      output = servicio_base.to_s
      expect(output).to_not include("Equipos Avanzados Requeridos")
      expect(output).to_not include("Equipos Simples Requeridos")
    end
  end

  context "Pruebas de Polimorfismo del método to_s en la jerarquía Personal" do
    it "cada tipo de personal debe mostrar información específica en su to_s" do
      personal_servicios = [
        Sanitarios::Personal.new(100, "Base", "MAÑANA"),
        Sanitarios::Cirujano.new(101, "Cirujano A", "MAÑANA", "cirugia general"),
        Sanitarios::Asistente.new(102, "Asistente B", "TARDE", "tecnologo quirurgico"),
        Sanitarios::Anestesiologo.new(103, "Anestesista C", "NOCHE", "cardiovascular"),
        Sanitarios::Otros.new(104, "Residente D", "MAÑANA", "residente")
      ]
      
      textos = personal_servicios.map(&:to_s)
      expect(textos[0]).to_not eq(textos[1]) 
      expect(textos[1]).to_not eq(textos[2])
      expect(textos[2]).to_not eq(textos[3]) 
      expect(textos[3]).to_not eq(textos[4])
      expect(textos[0]).to_not eq(textos[2]) 
    end
    
    it "el to_s de Cirujano incluye la sección 'Especialidad', demostrando sobreescritura" do
      cirujano = Sanitarios::Cirujano.new(101, "A", "MAÑANA", "cirugia general")
      expect(cirujano.to_s).to include("Especialidad: cirugia general")
    end
  end

  context "Pruebas de Polimorfismo del método to_s en la jerarquía Quirofano" do
    it "cada tipo de Quirofano debe mostrar información específica en su to_s" do
      quirofanos_servicios = [
        Sanitarios::Quirofano.new(200, "DISPONIBLE", equipo_completo_q),
        Sanitarios::Funcional.new(201, "ESPERANDO", equipo_completo_q, Sanitarios::Funcional::ESTADOS_PERMITIDOS.first),
        Sanitarios::Bioseguridad.new(202, "OCUPADO", equipo_completo_q, Sanitarios::Bioseguridad::ISO_PERMITIDOS.last)
      ]

      textos = quirofanos_servicios.map(&:to_s)
      expect(textos[0]).to_not eq(textos[1]) 
      expect(textos[1]).to_not eq(textos[2]) 
      expect(textos[0]).to_not eq(textos[2]) 
    end
    
    it "el to_s de Bioseguridad incluye la sección 'Tipo de ISO', demostrando sobreescritura" do
      bioseguridad = Sanitarios::Bioseguridad.new(202, "OCUPADO", equipo_completo_q, Sanitarios::Bioseguridad::ISO_PERMITIDOS.last)
      expect(bioseguridad.to_s).to include("Tipo de ISO: ISO 7")
      expect(bioseguridad.to_s).to_not include("Clase Funcional")
    end

    it "el to_s de Funcional incluye la sección 'Clase Funcional', demostrando sobreescritura" do
      funcional = Sanitarios::Funcional.new(201, "ESPERANDO", equipo_completo_q, "Clase B")
      expect(funcional.to_s).to include("Clase Funcional: Clase B")
      expect(funcional.to_s).to_not include("Tipo de ISO")
    end
  end

  context "Polimorfismo de Interfaz en la jerarquía Quirofano" do
    let(:q_base) { Sanitarios::Quirofano.new(200, "DISPONIBLE", equipo_completo_q) }
    let(:q_funcional) { Sanitarios::Funcional.new(901, "ESPERANDO", equipo_completo_q, Sanitarios::Funcional::ESTADOS_PERMITIDOS.first) } 
    let(:q_bioseguridad) { Sanitarios::Bioseguridad.new(202, "OCUPADO", equipo_completo_q, Sanitarios::Bioseguridad::ISO_PERMITIDOS.first) } 
    
    it "Todos los tipos de quirófanos responden a la misma interfaz pública" do
      lista_quirofanos = [q_base, q_funcional, q_bioseguridad]
      metodos_esperados = [ :id, :estado, :equipo_medico, :nuevo_equipo_medico!,  :==, :to_s ] 
      i = 0
      while i < lista_quirofanos.length
        quirofano = lista_quirofanos[i]
        j = 0
        while j < metodos_esperados.length
          metodo = metodos_esperados[j]
          expect(quirofano).to respond_to(metodo), 
            "El quirófano ID: #{quirofano.id} (Clase: #{quirofano.class}) no responde al método :#{metodo}"
          j += 1
        end
        i += 1
      end
    end
  end

  context "Polimorfismo de Interfaz en la jerarquía Personal" do
    let(:p_base) { Sanitarios::Personal.new(100, "Base Prof.", "MAÑANA") }
    let(:p_cirujano) { Sanitarios::Cirujano.new(1, "Dr. Smith", "MAÑANA", "cirugia general") }
    let(:p_asistente) { Sanitarios::Asistente.new(2, "Enf. Pérez", "MAÑANA", "tecnologo quirurgico") }
    let(:p_anestesista) { Sanitarios::Anestesiologo.new(99, "Dr. Johnson (Anestesista)", "NOCHE", "neuroquirúrgica") }
    let(:p_otros) { Sanitarios::Otros.new(1000, "Residente Y", "TARDE", "residente") }

    it "Todos los tipos de personal responden a la misma interfaz pública" do
      lista_personal = [p_base, p_cirujano, p_asistente, p_anestesista, p_otros]
      metodos_esperados = [ :id, :nombre, :turno, :==, :to_s ]
      i = 0
      while i < lista_personal.length
        personal = lista_personal[i]
        j = 0
        while j < metodos_esperados.length
          metodo = metodos_esperados[j]
          expect(personal).to respond_to(metodo), 
            "El personal ID: #{personal.id} (Clase: #{personal.class}) no responde al método :#{metodo}"
          j += 1
        end
        i += 1
      end
    end
  end

  context "Polimorfismo de Interfaz en la jerarquía ServicioQuirurgico" do
    it "Todos los servicios quirúrgicos responden a la misma interfaz pública" do
      lista_servicios = [servicio1, cirugia_mayor, cirugia_menor]
      metodos_esperados = [:id, :nombre, :quirofanos, :personal, :precio, :num_quirofanos, :num_personal, :obtener_estados_individuales,
        :total_personal_turno, :==, :to_s, :<=> ]
      i = 0
      while i < lista_servicios.length
        servicio = lista_servicios[i]
        j = 0
        while j < metodos_esperados.length
          metodo = metodos_esperados[j]
          expect(servicio).to respond_to(metodo), 
            "El servicio ID: #{servicio.id} (Clase: #{servicio.class}) no responde al método :#{metodo}"
          j += 1
        end
        i += 1
      end
    end
  end

  context "Pruebas del metodo polimorfico coste_total" do
    let(:servicio_alt)  { Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_validos, personal_valido, 20000)}
    let(:cirugia_mayor_alt) { Sanitarios::CirugiaMayor.new(10, "Cirugía Mayor Test", quirofanos_validos, personal_valido, 20000) }
    let(:cirugia_menor_at) { Sanitarios::CirugiaMenor.new(20, " Cirugía Menor Test", quirofanos_validos2, personal_validos2, 20000) }
    it "coste total de servicio servicio_quirurgico" do
      expect(servicio_alt.coste_total).to eq(20000)
      expect(cirugia_mayor_alt.coste_total).to eq(20600)
      expect(cirugia_menor_at.coste_total).to eq(20090)
    end
  end
end