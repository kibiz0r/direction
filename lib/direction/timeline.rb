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
      
      def delta_value(delta_id)
        self.current.delta_value delta_id
      end

      def find_change(timeline_object_id)
        self.current.find_change timeline_object_id
      end

      def find_object(timeline_object_id)
        self.current.find_object timeline_object_id
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

    def add_change(change)
      self.change_graph[change.id] = change
    end

    def find_change(change_id)
      self.change_graph[change_id]
    end

    def find_object(change_id)
      self.find_snapshot(change_id).find_object change_id
    end

    def find_snapshot(change_id)
      changes = changes_up_to change_id
      changes.inject Snapshot.new do |snapshot, change|
        object = run_change change
        snapshot.add_object change, object
      end
    end

    def run_change(change)
      puts "run_change"
      p change
      binding.pry
      case change.type
      when :directive
        change.target.send change.name, *change.args
      when :delta
      else
        raise "Invalid type: #{change.type}"
      end
    end

    def change_graph
      @change_graph ||= {}
    end

    def changes_up_to(change_id)
      change = find_change change_id
      changes = []
      while change
        changes.unshift change
        change = change.parent
      end
      changes
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

    attr_accessor :head_id

    def delta_value(delta_id)
      changes.inject changes.first.target do |value, change|
        if change.is_a? Delta
          value.delta_invoke change.name, *change.args
        else
          value
        end
      end
    end

    def branch(&block)
      Timeline.new head, &block
    end

    def head
      self.find_change self.head_id
    end

    def merge(timeline)
      ref = timeline.head
      changes_to_merge = []
      while ref
        break if self.objects.has_key? ref
        change = timeline.change_graph[ref]
        changes_to_merge.unshift change
        ref = change.parent
      end
      duped_changes = changes_to_merge.map &:dup
      duped_changes.each do |change|
        self.add_change change
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
      self.add_change change
      self.head_id = change.id
      change
    end
  end
end
