module Direction
  class Snapshot
    def initialize
      @objects = {}
    end

    def add_object(change, object)
      @objects[change.id] = object
      self
    end

    def find_object(change_id)
      @objects[change_id]
    end
  end
end
