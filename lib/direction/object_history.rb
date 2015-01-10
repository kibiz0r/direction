module Direction
  class ObjectHistory
    def initialize(timeline)
      @timeline = timeline
    end

    def changes
      @timeline.changes
    end
  end
end
