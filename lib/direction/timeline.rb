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
        self.stack.inject [] do |changes, timeline|
          changes + timeline.changes
        end
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

      def branch(&block)
        self.current.branch &block
      end

      def merge(timeline)
        self.current.merge timeline
      end

      def rebase(timeline)
        self.current.rebase timeline
      end

      def commit(change)
        self.current.commit change
      end

      def head
        self.current.head
      end
    end

    def initialize(ref = nil)
      @ref = ref

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
      ref = self.head
      changes = []
      while ref
        change = self.objects[ref]
        changes.unshift change
        ref = change.parent
      end
      changes
    end

    attr_accessor :head

    def branch(&block)
      Timeline.new head, &block
    end

    def head_change
      self.objects[self.head]
    end

    def merge(timeline)
      ref = timeline.head
      changes_to_merge = []
      while ref
        break if self.objects.has_key? ref
        change = timeline.objects[ref]
        changes_to_merge.unshift change
        ref = change.parent
      end
      duped_changes = changes_to_merge.map &:dup
      duped_changes.each do |change|
        self.add_object change
      end
      duped_changes.first.parent = self.head
      self.head = duped_changes.last.id
      # find common ancestor
      # aggregate changes on timeline below common ancestor
      # copy those changes onto self
      # set first of changes' parent to head
      # set head to last of changes' id
    end

    def rebase(timeline)
    end

    def commit(change)
      self.add_object change
      self.head = change.id
      change
    end
  end
end
