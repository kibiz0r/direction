module Direction
  class TimeframeConstant
    attr_reader :timeframe, :name

    def initialize(timeframe, name)
      @timeframe = timeframe
      @name = name
    end

    def directive(name, *args)
      subject = @timeframe.from_timeframe_object self
      subject.send name, *args
    end
  end
end
