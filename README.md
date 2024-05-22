# CSP Resolver
The `csp-resolver` gem is a powerful tool designed to solve [Constraint Satisfaction Problems](https://en.wikipedia.org/wiki/Constraint_satisfaction_problem) (CSPs), which are mathematical questions defined by strict constraints that must be met. This tool is suitable for a wide range of applications, from scheduling and planning to configuring complex systems.

## Getting Started
### Requirements
**Ruby** >= 2.5.8

### Installing
You can install using the following command:
```bash
gem install "csp-resolver"
```

If you prefer using Bundler, add the following line to your Gemfile:
```bash
gem "csp-resolver"
```

Then install it:
```bash
$ bundle install
```

## Usage

### **Setup a problem to be solved**
To setup a problem we need to require the gem and initialize the CSP:

```ruby
require 'csp-resolver'

problem = CSP::Problem.new
```

### **Adding variables and domains**

To add variables and domains you can use the **`add_variable`** method:

```ruby
variable = 'A'
domains = %w[red green blue]

problem.add_variable(variable, domains: domains)
```

If some variables share the same domains, you can use **`add_variables`** (plural) for easier setup:
```ruby
variables = %w[B C]
domains = %w[red green blue]

problem.add_variables(variables, domains: domains)

# is the same as
problem.add_variable('B', domains: domains)
problem.add_variable('C', domains: domains)
```

### **Adding constraints**
There are three ways of adding a constraint: **built-in methods**, **custom block**, or **custom constraint class**.

#### **Using built-in methods**
Setting a list of variables to be unique between them:
```ruby
# A != B != C
problem.unique(%w[A B])
problem.unique(%w[A C])
problem.unique(%w[C B])

# same as
problem.unique(%w[A B C])
```

Setting all variable assignments to be different:
```ruby
# A != B != C
# It will consider all variables of CSP automatically
problem.all_different
```

#### **Using a custom block**
You can use the **`add_constraint`** method passing `variables` and a block to create custom validations:

```ruby
# Set B != C and B != A
problem.add_constraint(variables: %w[B C A]) { |b, c, a| b != c && b != a }
```

The block parameters should correspond to the order of the variables provided.

#### **Using a custom constraint class**
To create a custom constraint class it'll need to answer if an assignment satisfies a condition for a group of variables.

The easiest way to do this is inheriting from **`CSP::Constraint`**:

```ruby
class MyCustomConstraint < CSP::Constraint
end
```

Now the **`CustomConstraint`** can receive a list of variables which we will use to check if their assigned values conform to the constraint's rule.

```ruby
variables = %w[A B C]

constraint = MyCustomConstraint.new(variables)

# It can answer the arity for constraint
constraint.unary? # => false
constraint.binary? # => false
constraint.arity # => 3
```

##### **Implementing the constraint rule**
To determinate if the solution satisfies or not a constraint we need to implement the **`satisfies?`** method. This method receives a hash containing the current variables assignments.

```ruby
# Variables can't have the color purple

class MyCustomConstraint < CSP::Constraint
  def satisfies?(assignment = {})
    # While not all variables for this constraint are assigned,
    # consider that it doesn't violates the constraint.
    return true if variables.all? { |variable| assignment[variable] }

    variables.all? { |variable| assignment[variable] != 'purple' }
  end
end
```

##### **Adding the constraint to CSP**
To add the constraint we must instantiate it and pass the object to **`add_constraint`**:
```ruby
problem = CSP::Problem.new
problem.add_variables(%w[A B C], domains: %w[purple red green blue])

# B can't have the color purple
constraint = MyCustomConstraint.new(%w[B])

# Add the B != purple constraint
problem.add_constraint(constraint)
```

##### **The constructor**

The default constructor expects to receive an array of variables to apply the constraint.

```ruby
class CSP::Constraint
  def initialize(variables)
    @variables = variables
  end
end
```

But if you need to add other properties besides the variables, you can override the constructor:

```ruby
# Instead of only purple, now we can choose which color to exclude.
class MyCustomConstraint < CSP::Constraint
  def initialize(letters:, color:)
    # set letters as the variables
    super(letters)

    @letters = letters
    @color = color
  end

  def satisfies?(assignment = {})
    # since letters is the same as variables, we can usem them interchangeably here.
    return true if @letters.all? { |letter| assignment[letter].present? }

    # we compare with the color set
    @letters.all? { |letter| assignment[letter] != @color }
  end
end
```

And now we can use as we see fit:
```ruby
problem = CSP::Problem.new
problem.add_variables(%w[A B C], domains: %w[purple red green blue])

a_cant_be_green = MyCustomConstraint.new(letters: %w[A], color: 'green')
b_cant_be_purple = MyCustomConstraint.new(letters: %w[B], color: 'purple')
c_cant_be_blue = MyCustomConstraint.new(letters: %w[C], color: 'blue')

problem.add_constraint(a_cant_be_green)
problem.add_constraint(b_cant_be_purple)
problem.add_constraint(c_cant_be_blue)
```

##### **TL;DR**
* Inherit from `CSP::Constraint`
* Implement a `satisfies?(assignment = {})` that returns a boolean
* Override the initializer if needed, but pass to `super` the constraint's variables

### Solving the problem
After setting the problem we can search for the solution by calling `solve`:

```ruby
problem.solve
# => { 'A' => 'green', 'B' => 'red', 'C' => 'purple' }
```

### Full Example:

```ruby
# Given the letters A-C, pick a color between red, blue, green, and purple for them.
# Consider the following rules:
# * Each letters has a unique color
# * A can't have the color purple
# * A and C can't have the color red
# * B can't have the color purple nor green

# Create a constraint class
class MyCustomConstraint < CSP::Constraint
  def initialize(letters:, color:)
    super(letters)
    @letters = letters
    @color = color
  end

  def satisfies?(assignment = {})
    @letters.all? { |letter| assignment[letter] != @color }
  end
end

# Initialize the problem
problem = CSP::Problem.new

# Define the letters as variables and colors as domains
variables = %w[A B C]
domains = %w[purple red green blue]

# Create constraints using the custom class
a_cant_be_purple = MyCustomConstraint.new(letters: %w[A], color: 'purple')
a_and_c_cant_be_red = MyCustomConstraint.new(letters: %w[A C], color: 'red')

# Add variables and domains
problem.add_variables(variables, domains: domains)

# Set the unique color constraint
problem.all_different

# set A != purple constraint
problem.add_constraint(a_cant_be_purple)

# set A != purple && C != purple constraint
problem.add_constraint(a_and_c_cant_be_red)

# set B != purple && B != green constraint
problem.add_constraint(variables: %w[B]) { |b| b != 'purple' && b != 'green' }

# find the solution
problem.solve
# => { 'A' => 'green', 'B' => 'red', 'C' => 'purple' }
```

## Contributing
See our [CONTRIBUTING](./CONTRIBUTING.md) guidelines.

## Code of Conduct
We expect that everyone participating in any way with this project follows our [Code of Conduct](./CODE_OF_CONDUCT.md).

## License
This project is licensed under the [MIT License](MIT-LICENSE).
