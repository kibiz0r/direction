module Direction
  class RootSnapshot < Snapshot
    def initialize(timeline)
      @timeline = timeline
    end
  end
end
