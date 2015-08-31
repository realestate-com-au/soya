require 'soya/expression/array'
require 'soya/expression/boolean'
require 'soya/expression/float'
require 'soya/expression/integer'
require 'soya/expression/null'
require 'soya/expression/object'
require 'soya/expression/string'

module Soya
  class Expression
    def initialize(expression_string)
      @expression = parse_expression(expression_string)
      Soya::verbose("  #{@expression.type.to_s.capitalize}: #{expression_string}")
    end

    def value
      @expression.value
    end

    def type
      @expression.type
    end

    private

    def parse_expression(string)
      [
        Soya::Expression::Null,
        Soya::Expression::Boolean,
        Soya::Expression::Integer,
        Soya::Expression::Float,
        Soya::Expression::Array,
        Soya::Expression::Object,
        ## Soya::Expression::String should always be last as it always matches.
        Soya::Expression::String
      ].each do |classz|
        expression = classz.new(string)
        if expression.match?
          return expression
        end
      end
    end
  end
end
