require 'minitest/autorun'
require 'rb-validation'


class ClassTest < Minitest::Test
    class TestClass
        include Validation
        
        attr_validate :foo
        attr_validate :bar, Integer
        attr_validate :baz, type: String, default: "somevalue"
        attr_validate :flurb, values: ["red", "blue", "green"], default: "red"

        def initialize(args={})
            @args = validate(args)
        end

        def args
            @args
        end
    end

    def test_empty
        assert_raises(ValidationError) do 
            TestClass.new()
        end
    end

    def test_default_apply
        t = TestClass.new(foo: 1, bar: 456)
        assert_equal t.args, {foo: 1, bar: 456, baz: "somevalue", flurb: "red"}
    end

    def test_all_present
        t = TestClass.new(foo: 1, bar: 456, baz: "avalue", flurb: "green")
        assert_equal t.args, {foo: 1, bar: 456, baz: "avalue", flurb: "green"}
    end

    def test_float_for_int
        assert_raises(ValidationError) do 
            TestClass.new(foo: 1, bar: 456.1)
        end
    end
end


