module Direction
  class TimeframeChange
    attr_accessor :return_value
    attr_reader :effects

    def initialize
      @effects = []
    end
  end
end
