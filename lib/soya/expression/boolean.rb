require 'soya/error'

module Soya
  class Expression
    class Boolean
      def initialize(expression)
        if expression == 'true'
          @value = true
        elsif expression == 'false'
          @value = false
        else
          @value = nil
        end
      end

      def match?
        return !@value.nil?
      end

      def value
        if @value.nil?
          raise Soya::Error.new("error: invalid boolean value")
        else
          return @value
        end
      end

      def type
        return :boolean
      end
    end
  end
end
