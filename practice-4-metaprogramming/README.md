# Sanitarios

**Sanitarios** is a Ruby gem providing an internal Domain-Specific Language (**DSL**) designed for the configuration, planning, and management of surgical units, operating rooms, and healthcare staff.

The gem implements a full object-oriented hierarchy with strict validations, advanced cost and availability metrics, `Comparable` interface support, and follows a Test-Driven Development (**TDD**) methodology.

---

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sanitarios'
```

And then execute:

```bash
$ bundle install
```

Or install it directly via:

```bash
$ gem install sanitarios
```

## DSL Usage
You can define a complete surgical service (including operating rooms, assigned staff, and equipment) using the DSL block syntax:

```ruby
require 'sanitarios'

my_service = Sanitarios::DSLQuirurgico.new(101) do
  configuracion tipo: "cirugia mayor", precio: 2500

  equipamiento do
    anestesia_general 2
    monitores_multiparametro 4
    equipos_de_reanimacion 1
    ventiladoresmecanicos 2
  end

  quirofano 1, estado: "DISPONIBLE", tipo: "ISO 5" do
    personal 1, nombre: "Dr. Lopez", turno: "MAÑANA", especialidad: "cirugia general"
    personal 2, nombre: "Dra. Ruiz", turno: "MAÑANA", especialidad: "cardiovascular"
    personal 3, nombre: "Enf. Perez", turno: "MAÑANA", especialidad: "primer asistente quirurgico"
  end

  personal 4, nombre: "Aux. Gomez", turno: "TARDE", especialidad: "enfermero cirulante"
end

# Print the structured DSL representation
puts my_service
```

## Key Features

* **Surgical Domain Modeling:**
  * **Service Types:** Support for `CirugiaMayor` (Major Surgery) and `CirugiaMenor` (Minor Surgery) with dynamic cost calculation.
  * **Operating Rooms:** Categorized by operational tier (`Funcional`: Class A, B, C) or air purity standard (`Bioseguridad`: ISO 5, 6, 7). Validated to enforce a minimum medical team (Surgeon, Anesthesiologist, and Assistant).
  * **Healthcare Staff:** Specialized roles (`Cirujano`, `Anestesiologo`, `Asistente`, `Otros`) managed across work shifts (`MAÑANA`, `TARDE`, `NOCHE`).

* **Management Operations:**
  * **Service Fusion:** Ability to merge two surgical services using `Sanitarios.fusion(serv1, serv2)`.
  * **Metrics & Indicators:** Built-in methods for total staff/room counts, shift distribution, and cost/staffing ratios.
  * **Comparison:** Inclusion of the `Comparable` module across services, staff, and operating rooms.

## Development

After checking out the repository, run the setup script to install dependencies:

```bash
$ bin/setup
```

To run the test suite with RSpec:

```bash
$ bundle exec rake spec
```

You can also launch an interactive console to experiment with the gem:

```bash
$ bin/console
```

To install this gem onto your local machine:

```bash
$ bundle exec rake install
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sanitarios.

## License

The gem is available as open source under the terms of the MIT License.