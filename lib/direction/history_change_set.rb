module Direction
  class HistoryChangeSet
    attr_reader :parent, :cause, :effects

    def initialize(parent, cause, effects)
      @parent = parent
      @cause = cause
      @effects = effects
    end
  end
end
