require 'soya/error'

module Soya
  class Expression
    class Integer
      def initialize(expression)
        if /^-?\d+$/.match(expression) && !/^-?0\d/.match(expression)
          @value = expression.to_i
        else
          @value = nil
        end
      end

      def match?
        return !@value.nil?
      end

      def value
        if @value.nil?
          raise Soya::Error.new("error: invalid integer value")
        else
          return @value
        end
      end

      def type
        return :integer
      end
    end
  end
end
