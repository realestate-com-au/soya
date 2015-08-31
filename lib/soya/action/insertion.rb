require 'soya/error'
require 'soya/path'

module Soya
  module Action
    class Insertion
      attr_reader :result

      def initialize(path, hash)
        value = Soya::deep_clone(hash)
        @result = Soya::Path.new(path).components.reverse_each.reduce(value) do |memo, key|
          { key => memo }
        end
      end
    end
  end
end
