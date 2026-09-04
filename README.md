# LPP - Lenguajes y Paradigmas de Programación

Repository dedicated to the **Lenguajes y Paradigmas de Programación (LPP)** course. This project implements a domain-specific software system in **Ruby**, following object-oriented design patterns, functional programming principles, domain-specific languages (DSL), and test-driven development (**TDD**).

---

## Core Computer Science Concepts

This project demonstrates four major programming paradigms and software engineering concepts:

### 1. Object-Oriented Programming (OOP) & Metaprogramming
* **Class Hierarchies & Inheritance:** Structured domain entities including staff members (`Personal` with `Cirujano`, `Anestesiologo`, `Asistente`, `Otros`) and operating suites (`Quirofano` with `Funcional`, `Bioseguridad`).
* **Encapsulation & Access Control:** Strict visibility enforcement (`public`, `protected`, `private`) for internal attributes, mutators, and domain validations.
* **Polymorphism & Mixins:** Dynamic method resolution across hierarchy branches and mixin inclusion (`Comparable`).
* **Metaprogramming:** Dynamic dispatch and method trapping using `method_missing` and `respond_to_missing?` to cleanly capture DSL attributes.

### 2. Functional & Declarative Design
* **Immutability & Constants:** Immutable state collections using frozen arrays (`TURNOS.freeze`, `ESTADOS_PERMITIDOS.freeze`) to prevent state corruption.
* **Higher-Order Enumerables:** Array transformations, filtering, and metric aggregations using core Ruby enumerables (`map`, `select`, `each_with_object`, `compact`).
* **Pure Functions:** Independent calculations for unit costs, staffing availability ratios, and shift totals without unexpected side effects.

### 3. Domain-Specific Languages (DSL)
* **Internal DSL Architecture:** Custom builder class (`DSLQuirurgico`) leveraging Ruby's block evaluation context (`instance_eval`).
* **Declarative Configuration:** Readable syntax for declaring services, nested operating suites, staff assignments, and equipment quantities.
* **Contextual State Machines:** Context-aware block execution tracking transitions between global service properties, room assignments, and dynamic equipment mapping.

### 4. Test-Driven Development (TDD)
* **Behavior-Driven Testing:** Full spec coverage using **RSpec** verifying both valid executions and error edge cases.
* **Continuous Refactoring:** Safe evolution of business logic and domain constraints validated continuously against tests.
* **Assertion & Validation Logic:** Deep verification of object state, custom error types (`ArgumentError`), and mathematical metrics.

---

## Installation

Clone the repository and install the required dependencies:

```bash
$ git clone [https://github.com/](https://github.com/)[USERNAME]/LPP.git
$ cd LPP
$ bundle install
```

## DSL Usage Example

```ruby
require 'sanitarios'

surgical_unit = Sanitarios::DSLQuirurgico.new(101) do
  configuracion tipo: "cirugia mayor", precio: 2500

  equipamiento do
    anestesia_general 2
    monitores_multiparametro 4
    equipos_de_reanimacion 1
  end

  quirofano 1, estado: "DISPONIBLE", tipo: "ISO 5" do
    personal 1, nombre: "Dr. Lopez", turno: "MAÑANA", especialidad: "cirugia general"
    personal 2, nombre: "Dra. Ruiz", turno: "MAÑANA", especialidad: "cardiovascular"
    personal 3, nombre: "Enf. Perez", turno: "MAÑANA", especialidad: "primer asistente quirurgico"
  end
end

puts surgical_unit
```

## Development & Testing

Run the full test suite via RSpec:

```bash
$ bundle exec rake spec
```

Start an interactive console session to experiment with the domain classes:

```bash
$ bin/console
```

Check code style and linter rules:

```bash
$ bundle exec rubocop
```

## Course Information

* **Course:** Lenguajes y Paradigmas de Programación (LPP)
* **Degree:** Computer Engineering (*Grado en Ingeniería Informática*)
* **University:** Universidad de La Laguna (ULL)
* **Language:** Ruby

---

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).