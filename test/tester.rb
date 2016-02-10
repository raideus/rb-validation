require 'rb-validation'

class Tester
    include Validation

    attr_validate :foo
    attr_validate :bar, type: Integer, default: 42
    attr_validate :baz, values: ["red", "blue", "green"], default: "red"

    # @@rules =  {
    #                     :foo => Object,
    #                     :bar => {type: Integer, default: 42},
    #                     :baz => { values: ["red", "blue", "green"], default: "red"}
    #             }

    # def self.rules
    #     puts @validation_rules
    # end

    def initialize(args={})
        @args = validate(args)
        puts @args
    end
end

t = Tester.new(foo: 1, baz: "green")
# Tester.rules

args = {foo: 54882}
rules = {foo: {type: Integer, default: 1}}

puts Validator.validate(args: {}, rules: rules)


# args = {foo: 1, bar: "Hello"}
# rules = {foo: {type: Integer, default: 1}, bar: {type: String}}

# puts Validator.validate(args: args, rules: rules, default_rescue: true)


# validator = Validator.new(:mode => :soft)
# validator.