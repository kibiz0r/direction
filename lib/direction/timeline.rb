module Direction
  class Timeline
    attr_reader :changes, :head

    def initialize(changes = {}, head = nil)
      @changes = changes
      @head = head
      @objects = {}
      @values = {}
      @timeframes = {}
      @timeframes[nil] = Timeframe.new self
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

    def commit(change)
      key = change.key
      @changes[key] = change
      @head = key
      ChangeSet.new self, key
    end

    def resolve(reference)
      @objects[reference.key] ||= Director.timeline_resolve reference
    end

    def change(type, subject, name, *args)
      change = Change.new head,
        type,
        subject,
        name,
        *args

      change_set = commit change

      change_set.return_value
    end

    def change_at(key)
      puts "change_at #{key}"
      p @changes
      @changes[key]
    end

    def value_at(key)
      timeframe_at(key).return_value
    end

    def effects_at(key)
      timeframe_at(key).effects
    end

    def timeframe_at(key)
      puts "timeframe at #{key}"
      @timeframes[key] ||= Director.timeline_timeframe self, key
    end

    class << self
      def current
        if stack.empty?
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
