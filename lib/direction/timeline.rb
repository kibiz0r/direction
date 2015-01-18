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

      def find_change_set(change_set_id)
        self.current.find_change_set change_set_id
      end

      def current_snapshot
        self.current.current_snapshot
      end

      def find_object(change_id)
        if Snapshot.current?
          return Snapshot.current.find_object change_id
        end
        self.current.find_object change_id
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

    def add_change_set(change_set)
      self.change_sets[change_set.id] = change_set
    end

    def find_change_set(change_set_id)
      self.change_sets[change_set_id]
    end

    def find_object(change_id)
      self.current_snapshot.find_object change_id
    end

    def current_snapshot
      self.find_snapshot self.head_id
    end

    def snapshots
      @snapshots ||= {}
    end

    def find_snapshot(change_set_id)
      puts "find_snapshot #{change_set_id}"

      snapshot = self.snapshots[change_set_id]
      return snapshot if snapshot

      create_snapshot change_set_id
    end

    def create_snapshot(change_set_id)
      snapshot = Snapshot.new
      self.snapshots[change_set_id] = snapshot
      change_set = self.find_change_set change_set_id
      Snapshot.run snapshot do
        ChangeSet.run change_set do
          snapshot.run_change change_set.initiating_change
        end
      end
      snapshot
    end

    def change_sets
      @change_sets ||= {}
    end

    def change_sets_up_to(change_set_id)
      change_set = find_change_set change_set_id
      change_sets = []
      while change_set
        change_sets.unshift change_set
        change_set = change_set.parent
      end
      # if Change.current?
      #   change_sets.pop
      # end
      change_sets
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
      self.find_change_set self.head_id
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
      puts "commit: #{change.type} on #{change.target} : #{change.name}"
      # binding.pry

      if ChangeSet.current?
        return if ChangeSet.current.changes.has_key? change.id
        ChangeSet.current.add_change change
      end

      if Change.current?
        puts "Change.current?"
        change.change_set_id = Change.current.change_set_id
        # change.object
        # Change.current.changes << change
      else
        puts "no Change.current?"
        change_set = ChangeSet.new self.head
        change.change_set_id = change_set.id
        change_set.initiating_change = change
        self.add_change_set change_set
        self.head_id = change_set.id
      end

      change
    end
  end
end
