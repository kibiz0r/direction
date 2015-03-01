module Direction
  class Timeline
    attr_reader :head_id

    def initialize(director)
      @director = director
      @timeframes = {}
      @timeframes[nil] = Timeframe.new
      @change_sets = {}
      @timeline_changes = {}
      @timeline_change_sets = {}
    end

    def head
      find_timeline_change_set head_id
    end

    def change(subject, name, *args)
      new_change = Direction::Change.new head_id, subject, name, *args

      change_timeframe = @director.eval_change new_change, timeframe

      timeframe_effects = []
      new_change_set = Direction::ChangeSet.new new_change, timeframe_effects

      change_id = @director.id_change new_change
      @change_sets[change_id] = new_change_set
      @timeframes[change_id] = change_timeframe

      @head_id = change_id

      timeline_change = TimelineChange.new self, change_id
      @timeline_changes[change_id] = timeline_change
    end

    def find_parent_id(change_id)
      if found_change_set = @change_sets[change_id]
        found_change_set.cause.parent
      end
    end

    def find_parent(change_id)
      find_change find_parent_id(change_id)
    end

    def find_change(change_id)
      @change_sets[change_id].cause
    end

    def find_timeline_parent(change_id)
      find_timeline_change find_parent_id(change_id)
    end

    def find_timeline_change(change_id)
      @timeline_changes[change_id]
    end

    def find_change_set(change_set_id)
      @change_sets[change_set_id]
    end

    def find_timeline_change_set(change_set_id)
      @timeline_change_sets[change_set_id]
    end

    def timeframe(change_id = head_id)
      @timeframes[change_id]
    end

    def write(id, change_set)
      @change_sets[id] = change_set
    end

    def commit(change_set)
      change_timeframe = @director.eval_effects change_set.effects, timeframe

      change_id = @director.id_change change_set.cause
      @change_sets[change_id] = change_set
      @timeframes[change_id] = change_timeframe

      @head_id = change_id

      timeline_change = TimelineChange.new self, change_id
      @timeline_changes[change_id] = timeline_change

      timeline_change_set = TimelineChangeSet.new self, change_id
      @timeline_change_sets[change_id] = timeline_change_set
    end

    def amend(change_set_id, new_effects)
      change_set = find_change_set change_set_id

      change_set.effects = new_effects

      new_timeframe = @director.eval_effects new_effects, timeframe

      @timeframes[change_set_id] = new_timeframe
    end
  end
end
