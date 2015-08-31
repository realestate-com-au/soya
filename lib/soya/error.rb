module Soya
  class Error < StandardError
    attr_reader :return_code

    def initialize(message, return_code=1)
      super(message)
      @return_code = return_code
    end
  end
end
