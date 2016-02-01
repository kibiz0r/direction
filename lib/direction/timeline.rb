module Direction
  class Timeline
    attr_reader :director

    def initialize(director)
      @director = director
    end

    def head
      Timeframe.current.get_property self, :head
    end

    def head=(value)
      Timeframe.current.set_property self, :head, value
    end

    def change
      change = TimelineChange.new
      change.id = director.generate_modification_id change
      change.timeline = Timeline.new director
      change.timeframe = Timeframe.current.dup
      change.return_value = change.timeframe.run do
        director.eval_change change
      end
      change_set = TimelineChangeSet.new
      change_set.id = director.generate_change_set_id change
      change_set.parent = head
      change_set.change = change
      change_set.effects = change.timeline.effects
      self.head = change_set.id
      change
    end

    def snapshot(ref = head)
      snapshots[ref]
    end

    def snapshots
      Timeframe.current.get_property self, :snapshots
    end
  end
end
