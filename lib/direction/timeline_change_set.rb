module Direction
  class TimelineChangeSet
    attr_reader :timeline, :id

    def initialize(timeline, id)
      @timeline = timeline
      @id = id
    end

    def parent
      @timeline.find_parent id
    end

    def timeframe
      timeline.timeframe id
    end
  end
end
