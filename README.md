# CSP Resolver
The `csp-resolver` gem is a powerful tool designed to solve Constraint Satisfaction Problems (CSPs), which are mathematical questions defined by strict constraints that must be met. This tool is suitable for a wide range of applications, from scheduling and planning to configuring complex systems.

## Using
### Requirements
 - **Ruby** >= 2.5.8
### Example
Add this line to your application's Gemfile:<br>
```gem 'csp-resolver'```
<br>
then execute:<br>
```bundle install```
<br>
or install directly:<br>
```gem install csp-resolver```
#### Example.rb
***This example is present in the examples folder.***
    In this example we have three sculptures (A, B, C) are to be exhibited in rooms 1,2 of an art gallery
    The exhibition must satisfy the following conditions:
    1. Sculptures A and B cannot be in the same room
    2. Sculptures B and C must be in the same room
    3. Room 2 can only hold one sculpture
```ruby
require 'csp'

class Example
    def call
      variables = %w[A B C]

      csp = CSP::Problem.new
        .add_variables(variables, domains: [1, 2])
        .unique(%w[A B])
        .add_constraint(variables: %w[B C]) { |b, c| b == c }
        .add_constraint(RoomLimitToOneConstraint.new(room: 2, variables: variables))
      solution = csp.solve

      solution || 'No solution found'
    end

    class RoomLimitToOneConstraint < ::CSP::Constraint
      attr_reader :room

      def initialize(room:, variables:)
          super(variables)
          @room = room
      end

      def satisfies?(assignment)
          values = assignment.values_at(*variables)

          values.count(room) <= 1
      end
    end
end
```
```[{"A"=>2, "B"=>1, "C"=>1}]```
<br>
<br>
add_variables -> add especified variables to the problem with the same domain
<br>
unique -> the especified variables should be different
<br>
add_constraint -> add a constraint to especified variables, you can pass a constraint instance or a block
<br>
solve -> runs the algorithm to solve the problem

***To get more details or more methos check the docs***
## License
This project is licensed under the [MIT License](MIT-LICENSE).