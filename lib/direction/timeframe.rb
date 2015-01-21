module Direction
  class Timeframe
    class << self
      def current
        if self.stack.empty?
          self.push Timeframe.new(nil, nil)
        end
        self.stack.last
      end

      def push(timeframe)
        self.stack.push timeframe
      end

      def pop
        self.stack.pop
      end

      def stack
        @stack ||= []
      end

      def enact_directive(subject, method, *args)
        self.current.enact_directive subject, method, *args
      end

      def alter_object(subject, delta, *args)
        self.current.alter_object subject, delta, *args
      end

      def has_delta?(subject, prototype)
        if prototype.is_a? Array
          method = prototype[0]
          subject.respond_to? method
        else
          name = prototype
          subject.class.delta_defined? name
        end
      end

      def delta_invoke(subject, delta_name, *args)
        unless definition = subject.class.instance_delta(delta_name)
          raise "#{subject.class} has no delta definition for #{delta_name}"
        end
        subject.instance_exec *args, &definition
      end

      def has_property?(subject, property_name)
        subject.class.instance_properties.include? property_name.to_sym
      end

      def get_property(subject, property_name)
        self.current.get_property subject, property_name
      end

      def set_property(subject, property_name, value)
        self.current.set_property subject, property_name, value
      end

      def alter_object(subject, delta_name, *args)
        self.current.alter_object subject, delta_name, *args
      end

      def find_results(change)
        self.current.find_results change
      end

      def to_timeframe_object(object)
        self.current.to_timeframe_object object
      end

      # def run(timeframe, &block)
      #   self.push timeframe
      #   yield if block_given?
      # ensure
      #   self.pop
      # end

      def run(parent_timeframe, change)
        timeframe = new parent_timeframe, change
        current.timeframes[change] = timeframe
        push timeframe
        value = timeframe.run_change change
        timeframe.results.value = value
        timeframe
      ensure
        pop
      end
    end

    attr_reader :parent_timeframe, :timeframes

    def initialize(change)
      puts "Timeframe.new #{parent_timeframe}, #{change}: #{self}"
      if change
        puts "change.parent: #{change.parent}"
      else
        puts "change is nil"
      end
      @parent_timeframe = parent_timeframe
      @head = change
      @change = change
      @changes = {}
      @results = {}
      @my_results = ChangeResults.new change
      @timeframes = {}
      @timeframes[nil] = self
      @object_changes = {}
    end

    def results
      @my_results
    end

    def get_property(subject, property_name)
      puts "get_property #{subject}, #{property_name}"
      puts "at change:"
      find_results(@head).get_property subject, property_name
    end

    def set_property(subject, property_name, value)
      puts "set_property #{subject}, #{property_name}, #{value}"
      property = property_of subject, property_name
      alter_object property, :set, value
    end

    def property_of(object, property_name)
      find_results(@head).property_of object, property_name
    end

    def alter_object(subject, delta_name, *args)
      puts "alter_object #{subject}, #{delta_name}, #{args}"

      change = Change.new self,
        @head,
        subject,
        :delta,
        delta_name,
        *args

      @changes[change.id] = change

      @head = change

      Delta.new change
    end

    # Probably just:
    # def enact(subject, method, *args)
    # with subject as a TimelineObject? Or TimeframeObject?
    def enact_directive(subject, property_name, method, *args)
      puts "enact_directive #{subject}, #{property_name}, #{method}, #{args}"

      change = Change.new self,
        @head,
        subject,
        :directive,
        method,
        *args

      @changes[change.id] = change

      @head = change

      Directive.new change
    end

    def run_change(change)
      puts "run_change"
      p change
      value = case change.type
              when :directive
                subject = find_timeframe_object change.subject
                subject.send change.name, *change.args
              when :delta
                subject = find_timeframe_object change.subject
                Timeframe.delta_invoke subject, change.name, *change.args
              else
                raise "Unknown change type #{change.type}"
              end
      puts "#{self}.object_changes[#{value}] = #{change}"
      @object_changes[value] = change
      value
    end

    def find_timeframe_object(timeline_object)
      case timeline_object
      when TimelineConstant
        timeline_object.name.constantize
      when TimelineNil
        nil
      else
        raise "Unknown TimelineObject type #{timeline_object.class}"
      end
    end

    def to_timeframe_object(object)
      puts "#{self}.to_timeframe_object: #{@object_changes[object]}"
      puts "parent_timeframe: #{parent_timeframe}"
      if @object_changes.has_key? object
        @object_changes[object]
      else
        parent_timeframe.to_timeframe_object object
      end
    end

    def find_results(change)
      change_id = if change.nil?
                    nil
                  else
                    change.id
                  end
      if @results.has_key? change_id
        @results[change_id]
      else
        timeframe = timeframe_for change
        results = timeframe.results
        @results[change_id] = results
      end
      # needs to include:
      # - inciting change
      # - return value
      # - all changes?
      # - property changes?
    end

    def timeframe_for(change)
      change_id = if change.nil?
                    nil
                  else
                    change.id
                  end
      if @timeframes.has_key? change_id
        @timeframes[change_id]
      else
        timeframe = Timeframe.run self, change
        @timeframes[change_id] = timeframe
      end
    end
  end
end
