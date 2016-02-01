module Direction
  class TimeframeTimeline
    attr_reader :timeframe, :timeline

    def initialize(timeframe, timeline)
      @timeframe = timeframe
      @timeline = timeline
    end

    def method_missing(method, *args, &block)
      timeframe.run do
        timeline.send method, *args, &block
      end
    end
  end
end
