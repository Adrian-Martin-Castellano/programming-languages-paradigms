# Sanitarios 🏥

[![Gem Version](https://badge.fury.io/rb/sanitarios.svg)](https://badge.fury.io/rb/sanitarios)
[![Ruby Spec Status](https://github.com/[USERNAME]/sanitarios/actions/workflows/main.yml/badge.svg)](https://github.com/[USERNAME]/sanitarios/actions)

**Sanitarios** is a Ruby library (gem) that provides an internal Domain-Specific Language (DSL) for planning, resource allocation, and supervision of healthcare services, with a primary focus on surgical care units.

The project is built following Test-Driven Development (**TDD**) methodology and Object-Oriented Programming (OOP) principles.

---

## Prerequisites

* **Ruby:** `>= 3.0.0`
* **Bundler:** `>= 2.0`

## Installation

Add the gem to your application's `Gemfile` by executing:

```bash
bundle add sanitarios
```

If you are not using Bundler to manage dependencies, install the gem directly by running:
Bash

```bash
gem install sanitarios
```

## Usage

Below is a basic example of using the internal DSL to plan a surgical procedure:

```ruby
require 'sanitarios'

schedule = Sanitarios::Planificacion.new do
  quirofano "Room 1", clase: "C", iso: 5
  cirujano "Dr. Lopez", especialidad: "Cardiology"
  anestesiologo "Dr. Ruiz"

  procedimiento "Coronary Bypass" do
    requiere quirofano: "Room 1"
    equipo "Dr. Lopez", "Dr. Ruiz"
    duracion "3 hours"
  end
end

# Example output / summary display
puts schedule.resumen
```

## Development

After cloning the repository, run the setup script to install all dependencies:

```bash
bin/setup
```

### Running Tests (TDD)

To execute the test suite developed with RSpec, run:

```bash
bundle exec rake spec
```

You can also launch an interactive console to experiment with the components in a REPL environment:

```bash
bin/console
```

### Building and Local Release

To install the gem onto your local machine, execute:

```bash
bundle exec rake install
```

To release a new version:

1. Update the version number in `lib/sanitarios/version.rb`.
2. Run `bundle exec rake release`, which will create the corresponding Git tag, push commits and tags, and upload the `.gem` file to [rubygems.org](https://rubygems.org).

---

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/[USERNAME]/sanitarios](https://github.com/[USERNAME]/sanitarios).

To contribute:

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/my-new-feature`).
3. Ensure you add unit tests for your changes following **TDD methodology**.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature/my-new-feature`).
6. Open a new Pull Request.

---

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
