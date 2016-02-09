require 'rb-validation/noval'

#
# Defines a rule abstraction for representing a validation rule
#
class Rule
    def initialize(type = Object, values = NoVal, default = NoVal)
        @type = type
        @values = values
        @default = default
    end

    def default
        @default
    end

    def values
        @values
    end

    def type
        @type
    end

    def has_type_constraint?
        @type != Object and @type.is_a?(Object)
    end

    def has_default?
        @default != NoVal
    end

    def has_value_constraint?
        @values != NoVal
    end
end