module Direction
  class Snapshot
    class << self
      attr_accessor :current

      def current?
        !self.current.nil?
      end
    end

    def initialize
      @objects = {}
    end

    def add_object(change, object)
      @objects[change.id] = object
    end

    def find_object(change_id)
      @objects[change_id]
    end
  end
end
