module Direction
  class Timeline
    class << self
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

      def head_snapshot
        self.current.current_snapshot
      end

      def enact(subject, method, *args)
        Timeline.current.enact subject, method, *args
      end

      def find_snapshot(change_set_id)
      end

      def root_snapshot
        self.current.root_snapshot
      end
    end

    attr_reader :root_snapshot

    def initialize(ref = nil)
      @root_snapshot = RootSnapshot.new self
      @snapshots = {}
      @change_sets = {}
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

    def clear
      @change_sets.clear
      @ref = nil
    end

    # def enact(subject, name, *args)
      # Either we're at the root enact level, in which case
      # there is a current timeline
      # but no current snapshot
      #
      # In this case, the subject is resolved by...
      # If a change set return value, then make sure that it's a
      # change within this timeline, and 
      # If a property, then 
      # 
      # Or we're within an enact, in which case
      # there is a current timeline
      # and a current snapshot
    # end

    def find_change_set(change_set_id)
      @change_sets[change_set_id]
    end

    def find_snapshot(change_set_id)
      snapshot = @snapshots[change_set_id]
      if snapshot
        return snapshot
      end
      create_snapshot change_set_id
    end

    def create_snapshot(change_set_id)
      change_set = find_change_set change_set_id
      snapshot = Snapshot.new change_set do
      end
      @snapshots[change_set_id] = snapshot
      snapshot
    end

    def branch(&block)
      Timeline.new @ref, &block
    end

    def merge(timeline)
      # ref = timeline.head
      # changes_to_merge = []
      # while ref
      #   break if self.objects.has_key? ref
      #   change = timeline.change_graph[ref]
      #   changes_to_merge.unshift change
      #   ref = change.parent
      # end
      # duped_changes = changes_to_merge.map &:dup
      # duped_changes.each do |change|
      #   self.add_change change
      # end
      # duped_changes.first.parent = self.head
      # self.head = duped_changes.last.id
      # find common ancestor
      # aggregate changes on timeline below common ancestor
      # copy those changes onto self
      # set first of changes' parent to head
      # set head to last of changes' id
    end
  end
end
