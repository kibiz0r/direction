module Direction
  class TimeframeChange
    attr_reader :timeframe, :type, :subject, :name, :args

    def initialize(timeframe, type, subject, name, *args)
      @timeframe = timeframe
      @type = type
      @subject = timeframe.to_timeframe_object subject
      @name = name
      @args = args.map { |a| timeframe.to_timeframe_object a }
    end

    def to_s
      "TimeframeChange: (#{type}) #{subject}.#{name} #{args}"
    end
  end
end
