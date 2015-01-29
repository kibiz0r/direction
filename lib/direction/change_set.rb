module Direction
  class ChangeSet
    def initialize(timeline, change)
      @timeline = timeline
      @change = change
    end

    def return_value
      @timeline.value_at @change
    end

    def effects
      @timeline.effects_at @change
    end
  end
end
