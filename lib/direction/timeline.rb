# Eventually, I would like Timeline to allow for tweaking the historical record
# without re-evaluating anything. But for now, it generates a new history every
# time you ask for it.
#
# I'm trying to stick to a style where Timeline mimicks the interface of
# ChangeSetHistory, and exposes its raw elements.
#
# Since a Timeline maps ids to HistoryChangeSets, and ultimately Timeframes,
# I'm going with a TimelineChangeSet type for now, meaning that you can
# directly manipulate its graph by providing a TimelineChangeSet with a
# Timeframe you have generated separately.
#
# I'm still figuring out how to handle the fact that a Timeframe can be
# modified independently of the HistoryChangeSet, yet the two should remain
# in sync as much as possible.
module Direction
  class Timeline
    attr_accessor :head

    def initialize(director)
      @director = director
      @change_sets = {}
      @head = nil
    end

    def change(subject, name, *args)
      change = HistoryChange.new head, subject, name, *args

      change_set = extrapolate change

      commit change_set
    end

    def extrapolate(history_change)
      change_timeframe = @director.eval_change history_change,
        timeframe(history_change.parent)
      TimelineChangeSet.new history_change, change_timeframe
    end

    def replay(history_change_set)
      change_timeframe = @director.eval_effects history_change_set.effects,
        timeframe(history_change_set.parent)
      TimelineChangeSet.new history_change_set, change_timeframe
    end

    def write(id, timeline_change_set)
      @change_sets[id] = timeline_change_set
    end

    def commit(timeline_change_set)
      id = @director.id_change_set timeline_change_set

      write id, timeline_change_set

      @head = id
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
