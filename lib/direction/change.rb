module Direction
  class Change
    class << self
      def current_new
        self.new_stack.last
      end

      def current_new?
        !self.current_new.nil?
      end

      def push_new(change)
        self.new_stack.push change
      end

      def pop_new
        self.new_stack.pop
      end

      def new_stack
        @new_stack ||= []
      end

      def current
        self.stack.last
      end

      def current?
        !self.current.nil?
      end

      def push(change)
        self.stack.push change
      end

      def pop
        self.stack.pop
      end

      def stack
        @stack ||= []
      end

      def run(change)
        self.push change
        yield if block_given?
      ensure
        self.pop
      end
    end

    attr_reader :type, :name, :property, :changes
    attr_accessor :change_set_id

    def initialize(target, property, type, name, *args)
      @target = target.to_timeline_object
      @object = TimelineObject.new :object, self.id
      @type = type
      @name = name
      @property = property
      @args = args.map &:to_timeline_object
      @changes = []
    end

    def target
      @target.value
    end

    def object
      value = @object.value
      if Snapshot.current?
        Snapshot.current.add_object self, value
      end
      Timeline.current.object_changes[value] = self
      value
    end

    def args
      @args.map &:value
    end

    def id
      self.object_id
    end

    def to_timeline_object
      TimelineObject.new :change, self.id
    end
  end
end
