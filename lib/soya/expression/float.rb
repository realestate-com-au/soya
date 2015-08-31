require 'soya/error'

module Soya
  class Expression
    class Float
      #MATCHER = /^[-+]?(?:\d+)?\.\d+(?:[eE][-+]\d+)?$/.freeze

      def initialize(expression)
        if /^-?\d+(\.\d+)?([eE][-+]?\d+)?$/.match(expression) && !/^-?0\d/.match(expression) && !/[eE][-+]?0\d+/.match(expression)
          @value = expression.to_f
        else
          @value = nil
        end
      end

      def match?
        return !@value.nil?
      end

      def value
        if @value.nil?
          raise Soya::Error.new("error: invalid float value")
        else
          return @value
        end
      end

      def type
        return :float
      end
    end
  end
end
