module Direction
  class ObjectHistory
    def initialize(owner)
      @owner = owner
    end

    def changes
      Timeline.changes.select do |change|
        change.initiator == @owner or change.target == @owner
      end
    end

    def property_get(name)
      last_change = self.changes.select do |change|
        change.is_a? Delta and change.property.to_s == name.to_s
      end.last
      unless last_change.nil?
        last_change.value
      end
    end
  end
end
