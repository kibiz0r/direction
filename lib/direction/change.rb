module Direction
  class Change
    attr_reader :timeframe, :previous_change, :subject, :type, :name, :args

    def initialize(timeframe, previous_change, subject, type, name, *args)
      @timeframe = timeframe
      @previous_change = previous_change
      # @subject = subject.to_timeline_object
      @subject = @timeframe.to_timeframe_object subject
      @type = type
      @name = name
      @args = args.map { |a| @timeframe.to_timeframe_object a }
    end

    def id
      object_id
    end

    def description
      "#{@subject}.#{@name} #{@args}"
    end
  end
end
