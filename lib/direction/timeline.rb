module Direction
  class Timeline
    attr_reader :head, :changes

    def initialize
      @parents = {}
      @changes = {}
      @head = nil
    end

    def change(change_type, subject, name, *args)
      change = Change.new head,
        change_type,
        subject,
        name,
        *args

      commit change
    end

    def commit(change)
      id = change.id
      @parents[id] = @head
      @changes[id] = change
      @head = id
      change
    end

    def clear
    end

    def branch
    end

    def merge(timeline)
    end

    class << self
      def current
        if stack.empty?
          Timeframe.push Timeframe.new(nil)
          push Timeline.new
        end
        stack.last
      end

      def push(timeline)
        stack.push timeline
      end

      def pop
        stack.pop
      end

      def stack
        @stack ||= []
      end

      def branch(&block)
        current.branch &block
      end

      def merge(timeline)
        current.merge timeline
      end

      def rebase(timeline)
        current.rebase timeline
      end

      def commit(change)
        current.commit change
      end

      def head
        current.head
      end

      def change(change_type, subject, name, *args)
        current.change change_type, subject, name, *args
      end
    end
  end
end
