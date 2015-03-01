# Maintains a mapping from id => HistoryChangeSets
# Provides an interface for manipulating that graph,
# as well as creating HistoryChangeSets from BasicChangeSets
module Direction
  class ChangeSetHistory
    attr_accessor :head

    def initialize(change_sets = {}, head = nil)
      @change_sets = change_sets
      @head = head
    end

    # Writes, possibly overwriting, a HistoryChangeSet to the given id
    def write(id, history_change_set)
      @change_sets[id] = history_change_set
    end

    def find(id) # => HistoryChangeSet
      @change_sets[id]
    end

    # Modifies the cause associated with a HistoryChangeSet at the given id
    def ascribe(id, cause)
    end

    # Modifies the effects associated with a HistoryChangeSet at the given id
    def revise(id, effects)
    end

    # Creates a HistoryChangeSet, parented to head,
    # then writes it to the given id, then sets head to the given id
    def commit(id, basic_change_set)
      history_change_set = HistoryChangeSet.new head,
        basic_change_set.cause,
        basic_change_set.effects

      write id, history_change_set

      self.head = id

      history_change_set
    end

    # Modifies the HistoryChangeSet at the given id, maintaining its parent
    def amend(id, basic_change_set)
    end

    def branch # => ChangeSetHistory
      ChangeSetHistory.new @change_sets.dup, head
    end

    # Merges change sets from another history into this one, placing its
    # divergent changes after self's divergent changes, and sets head to
    # other's head
    def merge(other, &resolver)
      self.head = other.head
    end

    # Merges change sets from another history into this one, placing its
    # divergent changes before self's divergent changes
    def rebase(other, &resolver)
    end
  end
end
