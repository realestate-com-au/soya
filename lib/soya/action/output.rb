require 'soya/error'

module Soya
  module Action
    class Output
      attr_reader :result

      def initialize(format, hash)
        if format == :json
          if Hash === hash || Array === hash
            @result = JSON.pretty_generate(hash)
          else
            @result = hash
          end
        elsif format == :yaml || format == :yml
          @result = hash.to_yaml
        else
          ## The CLI parser should stop this from occurring.
          raise Soya::Error.new("impossible output format: #{format.to_s}")
        end
      end
    end
  end
end
