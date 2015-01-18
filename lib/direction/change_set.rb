module Direction
  class ChangeSet
    class << self
      def current
        self.stack.last
      end

      def current?
        !self.current.nil?
      end

      def push(change_set)
        self.stack.push change_set
      end

      def pop
        self.stack.pop
      end

      def stack
        @stack ||= []
      end

      def run(snapshot, change_set)
        Snapshot.current = snapshot
        self.push change_set
        yield if block_given?
      ensure
        Snapshot.current = nil
        self.pop
      end
    end

    attr_reader :changes, :objects
    attr_accessor :initiating_change

    def initialize(parent)
      @parent = parent.to_timeline_object
      @changes = {}
      @objects = {}
    end

    def add_change(change)
      @changes[change.id] = change
    end

    def add_object(change, object)
      @objects[change.id] = object
    end

    def parent
      @parent.value
    end

    def id
      self.object_id
    end

    def to_timeline_object
      TimelineObject.new :change_set, self.id
    end
  end
end
