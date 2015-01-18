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

      def find_change(change_id)
        self.current.find_change change_id
      end

      def find_change_set(change_set_id)
        self.current.find_change_set change_set_id
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

    def add_change_set(change_set)
      self.change_sets[change_set.id] = change_set
    end

    def find_change_set(change_set_id)
      self.change_sets[change_set_id]
    end

    def find_object(change_id)
      if Snapshot.current?
        puts "looking in current snapshot: #{change_id}"
        object = self.object_graph[change_id]
        p self.object_graph
        if object
          puts "exists: #{object.inspect}"
          return object
        end
        puts "running change"
        change = self.find_change change_id
        object = self.run_change change
        puts "ran change, got #{object.inspect}"
        self.add_object change, object
        return object
      end

      puts "find_object #{change_id}"
      change_set_id = self.find_change(change_id).change_set_id
      snapshot = self.find_snapshot(change_set_id)
      puts "snapshot:"
      p snapshot
      snapshot.find_object change_id
    end

    def find_change(change_id)
      self.change_graph[change_id]
      # self.change_sets.each do |change_set_id, change_set|
      #   change = change_set.changes.find do |change|
      #     change.id == change_id
      #   end
      #   return change if change
      # end
      # nil
    end

    def snapshots
      @snapshots ||= {}
    end

    def find_snapshot(change_set_id)
      puts "find_snapshot #{change_set_id}"
      # binding.pry
      # change = self.find_change change_id
      snapshot = self.snapshots[change_set_id]
      return snapshot if snapshot

      snapshot = Snapshot.new
      self.snapshots[change_set_id] = snapshot

      change_sets = change_sets_up_to change_set_id
      puts "change_sets:"
      p change_sets
      change_sets.each do |change_set|
        puts "apply_change_set #{change_set.initiating_change.name}"
        apply_change_set snapshot, change_set
      end

      p snapshot

      snapshot
      # change_sets.inject Snapshot.new do |snapshot, change_set|
      #   change_set.changes.each do |change|
      #     object = run_change change
      #     snapshot.add_object change, object
      #   end
      #   snapshot
      # end
    end

    def apply_change_set(snapshot, change_set)
      ChangeSet.run snapshot, change_set do
        object = run_change change_set.initiating_change
        self.add_object change_set.initiating_change, object
        puts "ran change"
        p change_set.objects
        change_set.objects.each do |change_id, object|
          change = self.find_change change_id
          self.add_object change, object
          # snapshot.add_object change_id, object
        end
        # change_set.initiating_change.each do |change_id, change|
        #   object = run_change change
        #   snapshot.add_object change, object
        # end
      end
    end

    def add_object(change, object)
      puts "add_object"
      self.object_changes[object] = change
      self.object_graph[change.id] = object
    end

    def object_graph
      @object_graph ||= {}
    end

    def object_changes
      @object_changes ||= {}
    end

    def run_change(change)
      puts "run_change"
      p change
      if change.name == "directionful_new"
        Change.push_new change
      end
      Change.run change do
        case change.type
        when :directive
          puts ":directive send"
          change.target.send change.name, *change.args
        when :delta
        else
          raise "Invalid type: #{change.type}"
        end
      end
    ensure
      if change.name == "directionful_new"
        Change.pop_new
      end
    end

    def change_sets
      @change_sets ||= {}
    end

    def change_graph
      @change_graph ||= {}
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
      puts "commit: #{change.target} #{change.name}"
      # binding.pry

      if ChangeSet.current?
        return if ChangeSet.current.changes.has_key? change.id
        ChangeSet.current.add_change change
      end

      self.change_graph[change.id] = change

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
