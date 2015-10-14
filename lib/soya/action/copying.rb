require 'soya/action/extraction'
require 'soya/action/insertion'

module Soya
  module Action
    class Copying
      attr_reader :result

      def initialize(paths, hash)
        paths.each do |e|
          (destination, source) = e.split('=', 2)
          ## Without deep_cloning (see inside Soya::Action::Insertion) -- Ruby will create anchors/references for YAML output.
          subtree = Soya::Action::Insertion.new(destination,
                      Soya::Action::Extraction.new(source, hash).result
                    ).result
          hash = hash.merge(subtree, &Soya.method(:merge_strategy))
        end
        @result = hash
      end
    end
  end
end
