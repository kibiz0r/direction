module Direction
  class Timeline
    def initialize
    end

    def root_timeframe
      @root_timeframe ||= Timeframe.new nil
    end

    def clear
      @root_timeframe = nil
    end

    def branch
    end

    def merge(timeline)
    end

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

      def to_timeline_object(object)
        case object
        when Class
          TimelineConstant.new object.name
        when nil
          TimelineNil.new
        when Object
          puts "to_timeframe_object: #{object}"
          timeframe_object = Timeframe.to_timeframe_object object
          TimelineObject.new timeframe_object.id
        else
          raise "Can't convert to timeline object: #{object}"
        end
      end
    end
  end
end
