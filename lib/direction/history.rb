# When an object is created with a new history:
# - it can be created with a detached history
# - it can be created with the current history as its parent (default)
# - if it has a parent, it stores itself as a change in the parent, advancing
#   the parent's current history pointer to this history-creation event
# - maybe there should be a :initialized delta for hooks into this event?
module Direction
  class History
    def initialize
      @@id ||= 0
      @@id = @@id + 1
      @id = @@id
      if current = History.current
        current.add_history self
      end
    end

    # When a directive is enacted:
    # - the target's history is located
    # - an id is generated for the directive
    # - the directive is added to this history, referencing the target's
    #   history id and the directive's own id
    # - the history pointer is advanced to the new directive, thus triggering
    #   its body and applying any deltas it spawns
    # - the directive is returned as a Directive object, for convenience
    #
    # We might also have to know:
    # - the causing directive? or maybe enact only gets called on History if it
    #   *is* the causing directive?
    def enact(target, directive_name, *args)
    end
  end
end
