require 'minitest/autorun'
require 'rb-validation'


class ValidatorTest < Minitest::Test

    @@rules1 = {
        foo: {type: :any},
        bar: {type: Integer},
        baz: {type: String, default: "somevalue"},
        flurb: {values: ["red", "blue", "green"], default: "red"}
    }

    def test_empty
        assert_raises(ValidationError) do 
            Validator.validate(args: {}, rules: @@rules1)
        end
    end

    def test_default_apply
        args = { foo: 1, bar: 456 }
        assert_equal({foo: 1, bar: 456, baz: "somevalue", flurb: "red"}, Validator.validate(args: args, rules: @@rules1))
    end

    def test_all_present
        args = {foo: 1, bar: 456, baz: "avalue", flurb: "green"}
        assert_equal({foo: 1, bar: 456, baz: "avalue", flurb: "green"}, Validator.validate(args: args, rules: @@rules1))
    end

    def test_float_for_int
        assert_raises(ValidationError) do 
            args = {foo: 1, bar: 456.1}
            Validator.validate(args: args, rules: @@rules1)
        end
    end

    def test_values_precedence
        rules = { flurb: {values: ["red", "blue", "green"], type: Integer } }
        args = {flurb: "red"}
        assert_equal({flurb: "red"}, Validator.validate(args: args, rules: rules))
    end
end


