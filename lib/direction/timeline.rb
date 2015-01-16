module Direction
  class Timeline
    class << self
      alias :new :directionless_new

      def current
        if self.stack.empty?
          self.push Timeline.new
        end
        self.stack.last
      end

      def changes
        self.current.changes
      end

      def add_object(object)
        self.current.add_object object
      end

      def push(timeline)
        self.stack.push timeline
      end

      def pop
        self.stack.pop
      end

      def stack
        @stack ||= []
      end
    end

    def initialize
      if block_given?
        begin
          self.class.push self
          yield
        ensure
          self.class.pop
        end
      end
    end

    def to_s
      "timeline~#{@owner}#{objects}"
    end

    def inspect
      "timeline~#{@owner.inspect}#{objects.inspect}"
    end

    def add_object(object)
      unless object.is_a? Class
        objects[object.object_id] = object
      end
    end

    def objects
      @objects ||= {}
    end

    def changes
      @changes ||= []
    end
  end
end
