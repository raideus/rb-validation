# rb-validation
#### A validation framework for Ruby

This library provides a lightweight validation framework for Ruby programs.  It supports type validation, value constraints (whitelisting), and default values.

#### Usage

Validation is performed on a set of **arguments** against a set of **rules**, each represented by a Ruby hash.  Calling the validate() method applies the defined set of rules and returns the validated set of arguments:

```ruby
> rules = {
    id: {type: Integer},
    name: {type: String, default: "DefaultName"},
    color: {values: ["red", "blue", "green"], default: "red"}
}
> args = {id: 22, name: "Foo", color: "green"}

> Validator.validate(args: args, rules: rules)
=> { id: 22, name: "Foo", color: "green" } 
```


#### Value constraints

In addition to validating against object type, arguments can instead be validated against a set of 
allowed or "whitelisted" values by using the "values" option:

```ruby
color: {values: ["red", "blue", "green"]} # Value must be one of: "red", "blue", "green"
```

#### Defaults

Default values can be defined for any argument name:
```ruby
color: {values: ["red", "blue", "green"], default: "red"}
```
If this argument is not present, the default value is applied:
```ruby
> Validator.validate(args: {id: 22}, rules: rules)
=> { id: 22, name: "DefaultName", color: red } 
```
#### Validation Failures

If validation fails, a **ValidationError** is raised:
```ruby
> rules = {
    id: {type: Integer},
    name: {type: String, default: "DefaultName"},
    color: {values: ["red", "blue", "green"], default: "red"}
}

# Missing "id" argument
> Validator.validate(args: {}, rules: rules)
ValidationError: Missing required argument: 'id'

# Illegal type for "name"
> Validator.validate(args: {id: 22, name: 3.14, color: "green"}, rules: rules)
ValidationError: Invalid type for argument: 'name'. Expected: String, got: Float

# Illegal value for "color"
> Validator.validate(args: {id: 22, name: "Foo", color: "orange"}, rules: rules)
ValidationError: Invalid value for argument: 'color'.
```
