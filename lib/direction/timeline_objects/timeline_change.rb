module Direction
  class TimelineChange
    attr_reader :change_id

    def initialize(change_id)
      @change_id = change_id
    end

    def key
      [:change, @change_id]
    end
  end
end
