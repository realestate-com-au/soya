require 'soya/expression'
require 'soya/action/insertion'

module Soya
  module Action
    class Definition
      attr_reader :result

      def initialize(definitions, hash)
        @result = definitions.reduce(hash) do |memo, definition|
          # Key names cannot have either '.' or '='. A plausible extension
          # would be to handle key names like: key_a."key.b".'key.c'.key-d
          (path, expression) = definition.split('=', 2)
          value = Soya::Expression.new(expression).value
          memo.merge(Soya::Action::Insertion.new(path, value).result, &Soya.method(:merge_strategy))
        end
      end
    end
  end
end

