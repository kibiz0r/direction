module Direction
  class TimelineObject
    attr_reader :type, :id

    def initialize(type, id = nil)
      @type = type # :nil, :constant, :change, :object (return value of change)
      @id = id
    end

    def value
      case self.type
      when :nil
        nil
      when :constant
        self.id.constantize
      when :change
        Timeline.find_change self.id
      when :object
        Timeline.find_object self.id
      else
        raise "Invalid type: #{self.type}"
      end
    end

    def to_timeline_object
      self
    end
  end
end
