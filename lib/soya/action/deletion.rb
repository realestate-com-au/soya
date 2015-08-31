require 'soya/error'
require 'soya/path'

module Soya
  module Action
    class Deletion
      attr_reader :result

      def initialize(paths, hash)
        @result = last = Soya::deep_clone(hash)
        paths.each do |path|
          components = Soya::Path.new(path).components
          last_index = components.length-1
          components.each_index do |i|
            key = components[i]
            last_element = (i >= last_index)
            if Hash === last && last.has_key?(key)
              if last_element
                last.delete(key)
              else
                last = last[key]
              end
            elsif Array === last && match = /^\[(?<index>\d+)\]$/.match(key) ## && match[:index].to_i < last.length
              if last_element
                last.delete_at(match[:index].to_i)
              else
                last = last[match[:index].to_i]
              end
            else
              raise Soya::Error.new("error: invalid deletion key: #{key}")
            end
          end
        end
      end
    end
  end
end
