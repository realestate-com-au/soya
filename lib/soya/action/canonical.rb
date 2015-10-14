module Soya
  module Action
    class Canonical
      attr_reader :result

      def initialize(conditional, hash)
        @result = conditional ? sort_hash(hash) : hash
      end

      private

      def sort_hash(h)
        {}.tap do |h2|
          h.sort.each do |k,v|
            h2[k] = v.is_a?(Hash) ? sort_hash(v) : v
          end
        end
      end
    end
  end
end
