require 'rb-validation/noval'
require 'rb-validation/rule'
require 'rb-validation/validation_error'

module Validation
    def self.included(base)
        base.extend(ClassMethods)
    end  

    module ClassMethods  
        def validate(args: {}, rules: {}, default_rescue: false)
            begin
                validated_args = ValidationHelper.validate(args: args, rules: rules, default_rescue: default_rescue)
            rescue ValidationError => e
                raise ValidationError.new(e.message)
            end
            validated_args 
        end

        class ValidationHelper

            def self.validate(args: {}, rules: {}, default_rescue: false)
                args = args.select{ |k,v| rules.include?(k) }
                argrules = {}
                rules.each{|name,rule| argrules[name] = parse_rule(rule) }

                if (argrules.keys & args.keys).length < argrules.keys.length
                    # Some arguments missing, check for defaults
                    missing = (argrules.keys - args.keys)
                    missing.each do |missing_arg|
                        args[missing_arg] = apply_default(missing_arg, argrules[missing_arg])
                    end
                end

                args.each do |argname,argv|
                    if argrules[argname].has_value_constraint?
                        assert_type_constraint(argname, argv, argrules[argname])
                    elsif argrules[argname].has_type_constraint?
                        assert_type_constraint(argname, argv, argrules[argname])
                    end
                end

                args
            end

            def self.apply_default(argname, rule)
                if rule.has_default?
                    return rule.default
                end
                raise ValidationError.new("Missing required argument: " + missing_arg.to_s)
            end

            def self.assert_value_constraint(argname, argv, rule)
                if not rule.values.include?(argv)
                    raise ValidationError.new("Invalid value for argument: " + argname.to_s)
                end
            end

            def self.assert_type_constraint(argname, argv, rule)
                if not eq_type(argv, rule.type)
                    raise ValidationError.new("Invalid type for argument: '" + argname.to_s + \
                                                       "'. Expected: " + rule.type.to_s + ", " \
                                                       + "got: " + argv.class.to_s)
                end
            end

            # Convert human-supplied hash representing a validation rule 
            # into a Rule object
            def self.parse_rule(rulespec)
                if rulespec.is_a?(Hash)
                    type = rulespec[:type]
                    type ||= Object

                    if rulespec.include?(:values) and rulespec[:values].class == Array
                        values = rulespec[:values]
                    else
                        values = NoVal
                    end

                     if rulespec.include?(:default)
                        default = rulespec[:default]
                    else
                        default = NoVal
                    end

                    return Rule.new(type, values, default)
                end

                Rule.new(type=rulespec)
            end

            # Check equality of a value's type against a specified type
            def self.eq_type(val, type)
                return true if type == :any
                val.is_a?(type)
            end
        end
    end
end

require 'rb-validation/validator'