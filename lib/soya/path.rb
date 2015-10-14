require 'soya/error'

module Soya
  class Path
    attr_reader :components

    def initialize(path)
      @components = path.split('.', -1)
      if @components.any? { |component| component.length == 0 }
        raise Soya::Error.new("error: path with empty key: #{path}")
      end
    end

  end
end
