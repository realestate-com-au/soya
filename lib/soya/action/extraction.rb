require 'soya'
require 'soya/error'
require 'soya/path'

module Soya
  module Action
    class Extraction
      attr_reader :result

      def initialize(path, hash)
        last = Soya::deep_clone(hash)
        Soya::Path.new(path).components.each do |key|
          if Hash === last && last.has_key?(key)
            last = last[key]
          elsif Array === last && match = /^\[(?<index>\d+)\]$/.match(key)
            last = last[match[:index].to_i]
          else
            raise Soya::Error.new("error: invalid extraction key: #{key}")
          end
        end
        @result = last
      end
    end
  end
end
