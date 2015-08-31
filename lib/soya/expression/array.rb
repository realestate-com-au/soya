require 'soya/error'

module Soya
  class Expression
    class Array
      def initialize(expression)
        if /^\[.*\]$/.match(expression)
          begin
            @value = JSON.parse(expression)
          rescue JSON::ParserError => e
            message = 'definition parse-error: ' + e.message
            raise Soya::Error.new(message)
          end
        else
          @value = nil
        end
      end

      def match?
        return !@value.nil?
      end

      def value
        if @value.nil?
          raise Soya::Error.new("error: invalid array value")
        else
          return @value
        end
      end

      def type
        return :array
      end
    end
  end
end
