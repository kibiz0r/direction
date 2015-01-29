module Direction
  # A timeframe is a tool for executing a change,
  # and turning it into a state.
  class Timeframe
    attr_reader :timeline, :state
    attr_accessor :return_value, :head

    extend Forwardable

    def_delegators :state,
      :[],
      :[]=

    def initialize(timeline, state = TimeframeState.new, &block)
      raise "hell" unless timeline.is_a? Timeline
      @timeline = timeline
      @state = state
      @changes = {}
      @parents = {}
      @return_values = {}
      if block_given?
        Timeframe.push self
        begin
          self.return_value = yield self
        ensure
          Timeframe.pop
        end
      end
    end

    def changes(upto = head)
      puts "changes upto #{head}"
      changes = []
      ref = upto
      while ref
        changes.unshift ref
        ref = @parents[ref]
      end
      changes
    end

    def merge!(timeframe)
      # state.merge! timeframe.state
    end

    def run(&block)
      Timeframe.run @timeline, &block
    end

    def run_change(change)
      Director.timeframe_change self, change
    end

    def reference_at(key)
      puts "reference_at #{key}"
      @timeline.change_at key
    end

    def resolve(reference)
      puts "resolve #{reference}"
      if reference.is_a? Array
        resolve reference_at(reference)
      else
        Director.timeframe_resolve self, reference
      end
    end
    
    def commit(change)
      key = change
      timeframe = Director.change_timeframe self, change
      @changes[key] = timeframe
      @parents[key] = head
      @return_values[timeframe.return_value] = key
      self.head = key
      timeframe
    end

    def change(change_type, subject, name, *args)
      change = TimeframeChange.new change_type,
        subject,
        name,
        *args

      new_state = commit change
      new_state.return_value
    end

    def find_introducing_change(object)
      @return_values[object]
    end

    def property_value(property)
      Director.property_value self, property
    end

    def to_timeframe_object(object)
      if @timeframe_objects.has_key? object
        @timeframe_objects[object]
      elsif parent
        @timeframe_objects[object] = parent.to_timeframe_object object
      else
        @timeframe_objects[object] = Director.to_timeframe_object self, object
      end
    end

    def from_timeframe_object(timeframe_object)
      Director.from_timeframe_object self, timeframe_object
    end

    # def [](timeline_object)
    #   key = timeline_object.key
    #   if @changes.has_key? key
    #     @changes[key]
    #   else
    #     @changes[key] = Director.to_timeframe_object self, timeline_object
    #   end
    # end

    class << self
      def current
        stack.last
      end

      def push(timeframe)
        stack.push timeframe
      end

      def pop
        stack.pop
      end

      def stack
        @stack ||= []
      end

      def run(timeline, &block)
        timeframe = new timeline
        push timeframe
        begin
          timeframe.return_value = yield timeframe
        ensure
          pop
        end
        timeframe
      end

      extend Forwardable

      def_delegators :current,
        :change,
        :[],
        :to_timeframe_object,
        :from_timeframe_object,
        :property_value
    end
  end
end
