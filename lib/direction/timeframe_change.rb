module Direction
  class TimeframeChange
    attr_reader :timeframe, :change

    def initialize(timeframe, change)
      @timeframe = timeframe
      @change = change
    end

    def return_value
      timeframe.return_value
    end
  end
end
