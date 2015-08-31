require 'soya/error'

module Soya
  class Expression
    class Null
      def initialize(expression)
        if expression == 'null'
          @match = true
        else
          @match = false
        end
      end

      def match?
        return @match
      end

      def value
        if @match
          return nil
        else
          raise Soya::Error.new("error: invalid nil value")
        end
      end

      def type
        return :null
      end
    end
  end
end
