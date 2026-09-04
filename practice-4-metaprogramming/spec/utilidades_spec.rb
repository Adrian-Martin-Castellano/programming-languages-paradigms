require 'spec_helper'
include Sanitarios::Utilidades

RSpec.describe Sanitarios::Utilidades do
  let(:data_positive) { [1, 3, 5, 7, 9] }
  let(:data_positive2) { [1, 2, 2, 3, 4, 4, 4, 5] } 
  let(:data_positive3) { [600, 470, 170, 430, 300] } 
  let(:data_negative) { [-2, -4, -6, -8] } 
  let(:data_negative2) { [-10, -20, -20, -30, -40, -40, -50] } 
  let(:data_mixed) { [-10, 20, -20, -30, 40, 40, -50] } 
  let(:data_vacia) { [] }
  let(:data_simple) { [1] }

  let(:data_impar) { data_positive }
  let(:data_con_moda) { data_positive2 }
  let(:data_desv_estandar) { data_positive3 }
  let(:data_par) { data_negative }
  let(:data_bimodal) { data_negative2 } 

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

  let(:personal_valido) { [p_cirujano, p_asistente, p_anestesista] }
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

   let(:servicio_completo_alt) do
    Sanitarios::ServicioQuirurgico.new(1, "General", quirofanos_validos, p_cirujano, 5000)
  end

  let(:p_tarde) { Sanitarios::Cirujano.new(3, "Dr. House", "TARDE", "neurocirugia") }
  let(:p_noche_extra) { Sanitarios::Asistente.new(4, "Enf. Jane", "NOCHE", "enfermero anestesista") }
  let(:personal_variado) { [p_cirujano, p_asistente, p_tarde, p_noche_extra, p_anestesista] }

  let(:servicio_turnos_variados) do
    Sanitarios::ServicioQuirurgico.new(5, "Turnos Varios", quirofanos_validos, personal_variado, 1000)
  end

  context 'Pruebas de la Media' do
    it 'Media usando bloques sin operaciones' do
      expect(media(data_positive) { |x| x }).to eq(5.0)
      expect(media(data_negative) { |x| x }).to eq(-5.0)
    end

    it 'Media usando bloques que capturan el contexto externo' do
      factor = 2
      expect(media(data_positive) { |x| x * factor }).to eq(10.0)
      expect(media(data_negative) { |x| x + factor }).to eq(-3.0)
    end

    it "Media usando bloques que usa el contexto" do
      contador = 0
      expect(media(data_positive) { |x| contador += x }).to eq(11.0)
      expect(contador).to eq(25)
    end

    it 'Media para conjuntos positivos' do
      expect(media(data_positive) { |x| x**2 }).to eq(33.0)
      expect(media(data_positive2) { |x| x**3 }).to eq(45.125)
      expect(media(data_positive3) { |x| x**4 }).to eq(44304006000.0)
    end

    it 'Media para conjuntos negativos' do
      expect( media(data_negative) {|x| x-1}).to eq(-6.0)
      expect(media(data_negative2) {|x| x+2}).to eq(-28.0)
    end

    it 'si la colección está vacía' do
      expect(media(data_vacia) {|x| x-1}).to eq(0.0)
    end

    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { media(data_positive) }.to raise_error(LocalJumpError, /no block given/)
    end
  end

  context 'pruebas de la media usado en servicio_quirurgico' do
    it 'media para indicador_costo_por_quirofano' do
      resultado = media([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_quirofano}
      expect(resultado).to eq(6666.666666666667)
    end

    it 'media para indicador_costo_por_personal' do
      resultado = media([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_personal}
      expect(resultado).to eq(6111.11111111111)
    end

    it 'media para indicador_personal_quirofano' do
      resultado = media([servicio1, servicio2, servicio_completo]) { |servicio| servicio.disponibilidad_personal_quirofano}
      expect(resultado).to eq(1.0)
    end

    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { media([servicio1, servicio2, servicio_completo]) }.to raise_error(LocalJumpError, /no block given/)
    end
  end

  context 'Pruebas de la mediana' do
    it 'Mediana usando bloques sin operaciones' do
      expect(mediana(data_positive) { |x| x }).to eq(5)
      expect(mediana(data_negative) { |x| x }).to eq(-5)
    end

    it 'Mediana usando bloques que capturan el contexto externo' do
      offset = 3
      expect(mediana(data_positive) { |x| x + offset }).to eq(8)
      expect(mediana(data_negative) { |x| x * offset }).to eq(-15)
    end 

    it "Mediana usando bloques que usa el contexto" do
      suma = 0
      expect(mediana(data_positive) { |x| suma += x }).to eq(9.0)
      expect(suma).to eq(25)
    end

    it 'Mediana para conjuntos positivos' do
      expect(mediana(data_positive) { |x| x**2 }).to eq(25)
      expect(mediana(data_positive2) { |x| x**3 }).to eq(45.5) 
      expect(mediana(data_positive3) { |x| x/4 }).to eq(107) 
    end

    it 'Mediana para conjuntos negativos' do
      expect(mediana(data_negative) {|x| x+4}).to eq(-1.0) 
      expect(mediana(data_negative2) {|x| x-4}).to eq(-34) 
    end

    it 'si la colección está vacía' do
      expect(mediana(data_vacia) {|x| x-10}).to eq(0.0)
    end

    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { mediana(data_positive) }.to raise_error(LocalJumpError, /no block given/)
    end
  end

  context 'pruebas de la mediana usado en servicio_quirurgico' do
    it 'mediana para indicador_costo_por_quirofano' do
      resultado = mediana([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_quirofano}
      expect(resultado).to eq(2500.0)
    end

    it 'mediana para indicador_costo_por_personal' do
      resultado = mediana([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_personal}
      expect(resultado).to eq(1666.6666666666667)
    end

    it 'mediana para indicador_personal_quirofano' do
      resultado = mediana([servicio1, servicio2, servicio_completo]) { |servicio| servicio.disponibilidad_personal_quirofano}
      expect(resultado).to eq(1.0)
    end

    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { mediana([servicio1, servicio2, servicio_completo]) }.to raise_error(LocalJumpError, /no block given/)
    end
  end

  context 'Pruebas de moda' do
    it 'Moda usando bloques sin operaciones' do
      expect(moda(data_positive) { |x| x }).to eq([1, 3, 5, 7, 9])
      expect(moda(data_negative) { |x| x }).to eq([-2, -4, -6, -8])
    end

    it 'Moda usando bloques que capturan el contexto externo' do
      incremento = 1
      expect(moda(data_positive) { |x| x + incremento }).to eq([2, 4, 6, 8, 10])
      expect(moda(data_negative) { |x| x - incremento }).to eq([-3, -5, -7, -9])
    end

    it "Moda usando bloques que usa el contexto" do
      suma = 0
      expect(moda(data_positive) { |x| suma += x }).to eq([1, 4, 9, 16, 25])
      expect(suma).to eq(25)
    end

    it 'Moda para conjuntos positivos' do
      expect(moda(data_positive) { |x| x**2 }).to eq([1, 9, 25, 49, 81])
      expect(moda(data_positive2) { |x| x**3 }).to eq([64]) 
      expect(moda(data_positive3) { |x| x/4 }).to eq([150, 117, 42, 107, 75]) 
    end

    it 'Moda para conjuntos negativos' do
      expect(moda(data_negative) {|x| x+4}).to eq([2, 0, -2, -4]) 
      expect(moda(data_negative2) {|x| x-4}).to eq([-24, -44]) 
    end

    it 'si la colección está vacía' do
      expect(moda(data_vacia) {|x| x-10}).to eq(0.0)
    end

    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { moda(data_positive) }.to raise_error(LocalJumpError, /no block given/)
    end
  end

   context 'pruebas de la moda usado en servicio_quirurgico' do
    it 'moda para indicador_costo_por_quirofano' do
      resultado = moda([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_quirofano}
      expect(resultado).to eq([2500.0])
    end

    it 'moda para indicador_costo_por_personal' do
      resultado = moda([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_personal}
      expect(resultado).to eq([1666.6666666666667])
    end

    it 'moda para indicador_personal_quirofano' do
      resultado = moda([servicio1, servicio2, servicio_completo]) { |servicio| servicio.disponibilidad_personal_quirofano}
      expect(resultado).to eq([1.0])
    end

    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { moda([servicio1, servicio2, servicio_completo]) }.to raise_error(LocalJumpError, /no block given/)
    end
  end

  context 'Pruebas del Máximo y Mínimo' do
    it 'Usando bloques sin operaciones' do
      expect(maximo(data_positive) { |x| x }).to eq(9)
      expect(minimo(data_positive) { |x| x }).to eq(1)
      expect(maximo(data_negative) { |x| x }).to eq(-2)
      expect(minimo(data_negative) { |x| x }).to eq(-8)
    end

    it 'Usando bloques que capturan el contexto externo' do
      incremento = 5
      expect(maximo(data_positive) { |x| x + incremento }).to eq(9)
      expect(minimo(data_positive) { |x| x + incremento }).to eq(1)
      expect(maximo(data_negative) { |x| x - incremento }).to eq(-2)
      expect(minimo(data_negative) { |x| x - incremento }).to eq(-8)
    end 

    it "Usando bloques que usa el contexto" do
      producto = 1
      expect(maximo(data_positive) { |x| producto *= x }).to eq(9)
      expect(producto).to eq(945)
      producto_neg = 1
      expect(minimo(data_negative) { |x| producto_neg *= x }).to eq(-6)
      expect(producto_neg).to eq(384)
    end

    it 'Maximo para conjuntos positivos' do
      expect(maximo(data_positive) {|x| x**2}).to eq(9)
      expect(maximo(data_positive3) {|x| x/2}).to eq(600)
    end

    it 'Minimo para conjuntos positivos' do
      expect(minimo(data_positive) {|x| x**2}).to eq(1)
      expect(minimo(data_positive3) {|x| x**2}).to eq(170)
    end

    it 'Maximo para conjuntos negativos' do
      expect(maximo(data_negative) {|x| x**2}).to eq(-8)
      expect(maximo(data_negative2) {|x| x**2}).to eq(-50)
    end

    it 'Minimo para conjuntos negativos' do
      expect(minimo(data_negative) {|x| x**2}).to eq(-2)
      expect(minimo(data_negative2) {|x| x**2}).to eq(-10)
    end

    it 'lanza ArgumentError si .maximo se llama con una colección vacía' do
      expect { maximo(data_vacia) }.to raise_error(ArgumentError)
      expect { minimo(data_vacia) }.to raise_error(ArgumentError)
    end

    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { minimo(data_positive) }.to raise_error(LocalJumpError, /no block given/)
      expect { maximo(data_positive) }.to raise_error(LocalJumpError, /no block given/)
    end
  end

  context 'pruebas del minimo usado en servicio_quirurgico' do
    it 'minimo para indicador_costo_por_quirofano' do
      resultado = minimo([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_quirofano}
      expect(resultado).to eq(servicio1)
    end

    it 'minimo para indicador_costo_por_personal' do
      resultado = minimo([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_personal}
      expect(resultado).to eq(servicio1)
    end

    it 'minimo para indicador_personal_quirofano' do
      resultado = minimo([servicio1, servicio2, servicio_completo]) { |servicio| servicio.disponibilidad_personal_quirofano}
      expect(resultado).to eq(servicio1)
    end

    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { minimo([servicio1, servicio2, servicio_completo]) }.to raise_error(LocalJumpError, /no block given/)
    end
  end

  context 'pruebas del maximo usado en servicio_quirurgico' do
    it 'maximo para indicador_costo_por_quirofano' do
      resultado = maximo([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_quirofano}
      expect(resultado).to eq(servicio2)
    end

    it 'maximo para indicador_costo_por_personal' do
      resultado = maximo([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_personal}
      expect(resultado).to eq(servicio2)
    end

    it 'maximo para indicador_personal_quirofano' do
      resultado = maximo([servicio1, servicio_completo_alt, servicio_completo]) { |servicio| servicio.disponibilidad_personal_quirofano}
      expect(resultado).to eq(servicio1)
    end

    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { maximo([servicio1, servicio2, servicio_completo]) }.to raise_error(LocalJumpError, /no block given/)
    end
  end

  context 'Pruebas de la desviacion_estandar' do
    it 'Desviacion_estandar usando bloques sin operaciones' do
      expect(desviacion_estandar(data_positive) { |x| x }).to be_within(0.0001).of(3.1622776601683795)
      expect(desviacion_estandar(data_negative) { |x| x }).to be_within(0.0001).of(2.581988897471611)
    end

    it 'Desviacion_estandar usando bloques que capturan el contexto externo' do
      escala = 3
      expect(desviacion_estandar(data_positive) { |x| x * escala }).to be_within(0.0001).of(9.486832980505138)
      expect(desviacion_estandar(data_negative) { |x| x + escala }).to be_within(0.0001).of(2.581988897471611)
    end

    it "Desviacion_estandar usando bloques que usa el contexto" do
      suma = 0
      expect(desviacion_estandar(data_positive) { |x| suma += x }).to be_within(0.0001).of(9.669539802906858)
      expect(suma).to eq(25)
    end

    it 'Desviacion_estandar para conjuntos positivos' do
      expect(desviacion_estandar(data_positive3) { |x| x }).to be_within(0.0001).of(164.7118696390761)
    end

    it 'Desviacion_estandar para conjuntos negativos' do
      expect(desviacion_estandar(data_negative) { |x| x }).to be_within(0.0001).of(2.581988897471611)
    end

    it 'Desviacion_estandar para conjuntos mixtos' do
      expected_desv = 35.32165125838609 * 10
      expect(desviacion_estandar(data_mixed) { |x| x * 10 }).to be_within(0.0001).of(expected_desv)
    end

    it 'lanza ArgumentError si la colección tiene menos de dos elementos' do
      expect { desviacion_estandar(data_simple) { |x| x } }.to raise_error(ArgumentError, /al menos dos elementos/)
      expect { desviacion_estandar(data_vacia) { |x| x } }.to raise_error(ArgumentError, /al menos dos elementos/)
    end
    
    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { desviacion_estandar(data_positive) }.to raise_error(LocalJumpError, /no block given/)
    end
  end

  context 'pruebas de la desviación típica usado en servicio_quirurgico' do
    it 'desviación típica para indicador_costo_por_quirofano' do
      resultado = desviacion_estandar([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_quirofano}
      expect(resultado).to eq(7216.878364870321)
    end

    it 'desviación típica para indicador_costo_por_personal' do
      resultado = desviacion_estandar([servicio1, servicio2, servicio_completo]) { |servicio| servicio.indicador_costo_por_personal}
      expect(resultado).to eq(7698.00358919501)
    end

    it 'desviación típica para indicador_personal_quirofano' do
      resultado = desviacion_estandar([servicio1, servicio_completo_alt]) { |servicio| servicio.disponibilidad_personal_quirofano}
      expect(resultado).to eq(0.7071067811865476)
    end

    it 'lanza LocalJumpError si se llama sin proporcionar un bloque' do
      expect { desviacion_estandar([servicio1, servicio2, servicio_completo]) }.to raise_error(LocalJumpError, /no block given/)
    end
  end
end