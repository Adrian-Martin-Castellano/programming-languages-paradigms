# Sanitarios

**Sanitarios** is a Ruby gem designed for the management, planning, and monitoring of healthcare surgical services. It provides a structured Object-Oriented Domain-Specific Model (DSL) to manage operating rooms, medical staff, surgical procedures, and cost analysis.

This project follows **Test-Driven Development (TDD)** principles using **RSpec**.

---

## Installation

Install the gem and add it to your application's Gemfile by running:

```bash
$ bundle add sanitarios
```

If Bundler is not being used to manage dependencies, install the gem directly:

```bash
$ gem install sanitarios
```

## Architecture & Structure

The codebase is organized into modular components under the `Sanitarios` namespace:

* **`Sanitarios::Personal`**: Base class for healthcare staff (includes `Comparable`).
  * `Cirujano`: Surgeon personnel with specific specialties.
  * `Anestesiologo`: Anesthesiologist personnel.
  * `Asistente`: Surgical assistant personnel.
  * `Otros`: Supporting medical personnel.
* **`Sanitarios::Quirofano`**: Base class for operating rooms (includes `Comparable`).
  * `Funcional`: Functional class-rated operating rooms (`Class A`, `Class B`, `Class C`).
  * `Bioseguridad`: Cleanroom isolation/ISO-rated operating rooms (`ISO 5`, `ISO 6`, `ISO 7`).
* **`Sanitarios::ServicioQuirurgico`**: Base class for surgical services.
  * `CirugiaMayor`: Major surgery services requiring advanced equipment setups.
  * `CirugiaMenor`: Minor surgery services requiring basic equipment setups.
* **`Sanitarios::Utilidades`**: Statistical and analytical utilities (`media`, `mediana`, `moda`, `maximo`, `minimo`, `desviacion_estandar`).
* **`Sanitarios::GruposServicios`**: Care classification constants.

## Usage

### 1. Creating Medical Staff

```ruby
require 'sanitarios'

surgeon = Sanitarios::Cirujano.new(101, "Dr. Alex Smith", "MORNING", "general surgery")
anesthesiologist = Sanitarios::Anestesiologo.new(102, "Dra. Maria Garcia", "MORNING", "cardiovascular")
assistant = Sanitarios::Asistente.new(103, "John Doe", "MORNING", "first surgical assistant")
```

### 2. Setting Up an Operating Room

```ruby
team = [surgeon, anesthesiologist, assistant]

# Functional operating room
or_functional = Sanitarios::Funcional.new(1, "AVAILABLE", team, "Class A")

# Biosecurity ISO operating room
or_biosecurity = Sanitarios::Bioseguridad.new(2, "WAITING", team, "ISO 5")
```

### 3. Managing Surgical Services

```ruby
# Major Surgery Service
major_surgery = Sanitarios::CirugiaMayor.new(
  1,
  "Cardiovascular Unit",
  [or_functional, or_biosecurity],
  team,
  2500
)

# Minor Surgery Service
minor_surgery = Sanitarios::CirugiaMenor.new(
  2,
  "Outpatient Surgery",
  [or_functional],
  team,
  800
)

# Total cost including equipment additions
puts major_surgery.coste_total # Base price + advanced equipment additions
```

### 4. Merging Services & Utilities

```ruby
# Merge two surgical services
merged_service = Sanitarios.fusion(major_surgery, minor_surgery)

# Calculate totals
total_or = Sanitarios.total_quirofanos([major_surgery, minor_surgery])
total_staff = Sanitarios.total_personal([major_surgery, minor_surgery])
```

## Development

After cloning the repository, run bin/setup to install all dependencies:

```bash
$ bin/setup
```

To run the test suite:

```bash
$ bundle exec rake spec
```

To open an interactive prompt for experimentation:

```bash
$ bin/console
```

To install this gem on your local machine:

```bash
$ bundle exec rake install
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sanitarios.

## License

The gem is available as open source under the terms of the MIT License.