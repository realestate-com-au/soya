module Soya
  class Expression
    class String
      def initialize(expression)
        if (match = /^\"(?<s>.*)\"$/.match(expression))
          @value = match[:s]
        elsif (match = /^\'(?<s>.*)\'$/.match(expression))
          @value = match[:s]
        else
          @value = expression
        end
      end

      def match?
        true
      end

      def value
        return @value
      end

      def type
        return :string
      end
    end
  end
end
