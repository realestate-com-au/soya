require 'json'
require 'soya/error'

module Soya
  class Expression
    class Object
      def initialize(expression)
        if /^\{.*\}$/.match(expression)
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
          raise Soya::Error.new("error: invalid object value")
        else
          return @value
        end
      end

      def type
        return :object
      end
    end
  end
end
