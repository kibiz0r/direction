module Direction
  class TimelineChange
    attr_reader :timeline, :id

    def initialize(timeline, id)
      @timeline = timeline
      @id = id
    end

    def parent
      @timeline.find_timeline_parent id
    end

    def timeframe
      timeline.timeframe id
    end
  end
end

