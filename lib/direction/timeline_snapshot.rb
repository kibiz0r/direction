module Direction
  class TimelineSnapshot
    class << self
      def current
        self.stack.last
      end

      def push(snapshot)
        self.stack.push snapshot
      end

      def pop
        self.stack.pop
      end

      def stack
        @stack ||= []
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
  end
end
