module Direction
  class Timeline
    attr_reader :changes, :head

    def initialize(changes, head)
      @changes = changes
      @head = head
    end
# 
#     def change(change_type, subject, name, *args)
#       change = Change.new head,
#         change_type,
#         subject,
#         name,
#         *args
# 
#       commit change
#     end
# 
#     def commit(change)
#       id = change.id
#       @parents[id] = @head
#       @changes[id] = change
#       @head = id
#       change
#     end

    def clear
    end

    def change_set_at(index)
      change_set_array[index]
    end

    def change_set_array
    end

    class << self
      def current
        Director.timeframe_to_timeline Timeframe.current
        # if stack.empty?
        #   Timeframe.push Timeframe.new(nil)
        #   push Timeline.new
        # end
        # stack.last
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

      extend Forwardable

      def_delegators :current,
        :branch,
        :merge,
        :rebase,
        :commit,
        :head,
        :change,
        :change_set_at
    end
  end
end
