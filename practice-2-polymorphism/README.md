# Sanitarios

**Sanitarios** is a Ruby gem designed for the planning, management, and supervision of healthcare services, with a specialized focus on surgical care units (`ServicioQuirurgico`), operating room management (`Quirofano`), and healthcare personnel (`Personal`).

This library leverages object-oriented design patterns, polymorphism, and module inclusion (such as `Comparable`) to handle complex medical workflows, equipment requirements, and staff scheduling.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sanitarios'
```

And then execute:

```bash
$ bundle install
```

Or install it directly via gem:

```bash
$ gem install sanitarios
```

## Usage

Below is a quick overview of how to instantiate medical personnel, set up operating rooms, build surgical services, and perform service mergers.

```ruby
require 'sanitarios'

# 1. Create Medical Personnel
surgeon = Sanitarios::Cirujano.new(101, "Dr. López", "MORNING", "general surgery")
anesthesiologist = Sanitarios::Anestesiologo.new(102, "Dra. Ruiz", "MORNING", "cardiovascular")
assistant = Sanitarios::Asistente.new(103, "Nurse Gomez", "MORNING", "first surgical assistant")
other_staff = Sanitarios::Otros.new(104, "Resident Perez", "MORNING", "resident")

medical_team = [surgeon, anesthesiologist, assistant, other_staff]

# 2. Configure Operating Rooms
or_class_a = Sanitarios::Funcional.new(1, "AVAILABLE", medical_team, "Class A")
or_iso_5 = Sanitarios::Bioseguridad.new(2, "WAITING", medical_team, "ISO 5")

# 3. Define Surgical Services (Major and Minor Surgery)
major_surgery = Sanitarios::CirugiaMayor.new(
  1, 
  "Cardiovascular Unit", 
  [or_class_a], 
  medical_team, 
  1500
)

minor_surgery = Sanitarios::CirugiaMenor.new(
  2, 
  "Outpatient Care", 
  [or_iso_5], 
  medical_team, 
  400
)

# 4. Calculate Total Costs (Polymorphic behaviour based on required equipment)
puts "Major Surgery Total Cost: $#{major_surgery.coste_total}"
# Base price (1500) + 4 advanced equipment items ($150 each) = $2100

puts "Minor Surgery Total Cost: $#{minor_surgery.coste_total}"
# Base price (400) + 2 basic equipment items ($45 each) = $490

# 5. Module Utility Functions
all_services = [major_surgery, minor_surgery]

puts "Total ORs across services: #{Sanitarios.total_quirofanos(all_services)}"
puts "Total Staff across services: #{Sanitarios.total_personal(all_services)}"

# 6. Merging Services
merged_service = Sanitarios.fusion(major_surgery, minor_surgery)
puts merged_service.to_s
```

## Features & Domain Classes

* **`Sanitarios::Personal`**: Abstract base class for healthcare staff. Supports comparison (`Comparable`) by name and shift validation (`MORNING`, `AFTERNOON`, `NIGHT`).
  * **Subclasses**: `Cirujano`, `Anestesiologo`, `Asistente`, `Otros`.
* **`Sanitarios::Quirofano`**: Manages operating room status (`AVAILABLE`, `WAITING`, `OCCUPIED`) and ensures team completeness (must contain at least one Surgeon, Assistant, and Anesthesiologist).
  * **Subclasses**: 
    * `Funcional` (`Class A`, `Class B`, `Class C`)
    * `Bioseguridad` (`ISO 5`, `ISO 6`, `ISO 7`)
* **`Sanitarios::ServicioQuirurgico`**: Base unit for surgical care managing associated ORs and staff.
  * **Subclasses**:
    * `CirugiaMayor`: Automatically accounts for advanced equipment costs (general anesthesia, mechanical ventilators, etc.).
    * `CirugiaMenor`: Configured for outpatient procedures with basic equipment overheads.

## Development

After checking out the repository, run bin/setup to install dependencies. Then, run rake spec (or rspec) to run the test suite. You can also run bin/console for an interactive prompt that allows you to experiment with the domain classes.

```bash
$ bin/setup
$rake spec$ bin/console
```

To install this gem onto your local machine, run:

```bash
$ bundle exec rake install
```

To release a new version, update the version number in version.rb, and then run:

```bash
$ bundle exec rake release
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sanitarios.

## License

The gem is available as open source under the terms of the MIT License.