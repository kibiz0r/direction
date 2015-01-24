module Direction
  class Timeframe
    attr_reader :parent, :changes, :properties, :timeframe_objects
    attr_accessor :return_value

    def initialize(parent)
      @parent = parent
      if parent
        @changes = parent.changes.dup
        @properties = parent.properties.dup
      else
        @changes = {}
        @properties = {}
      end
      @timeframe_objects = {}
    end

    def merge!(timeframe)
      @changes.merge! timeframe.changes
      @properties.merge! timeframe.properties
      @timeframe_objects.merge! timeframe.timeframe_objects
    end

    def run(&block)
      timeframe = Timeframe.new self
      Timeframe.push timeframe
      begin
        timeframe.return_value = yield timeframe
      ensure
        Timeframe.pop
      end
      timeframe
    end
    
    def commit(change)
      key = change
      timeframe = Director.change_timeframe self, change
      @changes[key] = timeframe
    end

    def change(change_type, subject, name, *args)
      change = TimeframeChange.new self,
        change_type,
        subject,
        name,
        *args

      commit change

      change
    end

    def [](key)
      case key
      when TimeframeChange
        @changes[key]
      else
        raise "Unknown key #{key}"
      end
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

      extend Forwardable

      def_delegators :current,
        :run,
        :change,
        :[],
        :to_timeframe_object,
        :from_timeframe_object,
        :property_value
    end
  end
end
