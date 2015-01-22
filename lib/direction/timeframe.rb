module Direction
  class Timeframe
    attr_reader :caused_results

    def initialize(previous_results, cause = nil)
      @previous_results = previous_results
      @cause = cause
      @changes_by_id = {}
      @parent_changes_by_change = {}
      @timeframes_by_cause = {}
      @results_by_cause = {}
      @head = nil
      @caused_results = ChangeResults.new cause
      @changes_by_return_value = {}
    end

    def find_change(change_id)
      @changes_by_id[change_id]
    end

    def find_caused_results(change)
      return ChangeResults.new(nil) unless change
      puts "find_caused_results #{change && change.description}"
      if @results_by_cause.has_key? change
        @results_by_cause[change]
      else
        results = find_caused_timeframe(change).caused_results
        @results_by_cause[change] = results
      end
    end

    def find_caused_timeframe(change)
      if @timeframes_by_cause.has_key? change
        @timeframes_by_cause[change]
      else
        timeframe = run_change change
        @timeframes_by_cause[change] = timeframe
      end
    end

    def get_property(subject, property_name)
      puts "get_property #{subject}, #{property_name}"
      # changes = []
      # change = @head
      # while change
      #   changes.unshift change
      #   change = change.previous_change
      # end
      # puts "changes:"
      # p changes.map(&:description)
      # nil
      results = find_caused_results @head
      p results
      results.get_property subject, property_name
    end

    def property_of(subject, property_name)
      Property.new subject, property_name
    end

    def run_change(change)
      # Must activate change's Timeframe before running the change code
      # Which means activating change's ancestors' Timeframes, too
      # Then switch back to this Timeframe
      #
      # If we can assume that this change is always a direct cause of this
      # Timeframe, then we can just push a new Timeframe and pop it afterwards
      #
      # But I think this question does indicate that we need to be aware that
      # the Timeframe within which we add/modify changes may be different from
      # the Timeframe of the changes themselves, if they need to be re-run
      raise "Must be current timeframe to run a change" unless Timeframe.current == self
      puts "run_change #{change && change.description}"
      timeframe = Timeframe.new find_caused_results(change.previous_change), change
      puts "push timeframe #{timeframe}"
      begin
        Timeframe.push timeframe
        value = case change.type
                when :directive
                  p change.subject
                  subject = find_timeframe_object change.subject
                  subject.send change.name, *change.args
                when :delta
                  puts "change: #{change.description}"
                  subject = find_timeframe_object change.subject
                  puts "subject: #{subject}"
                  Timeframe.delta_invoke subject, change.name, *change.args
                else
                  raise "Unknown change type #{change.type}"
                end
        if change.subject.is_a? TimeframeProperty
          timeframe.caused_results.set_property_of(
            change.subject.subject,
            change.subject.property_name,
            value
          )
        end
        @changes_by_return_value[value] = change
        timeframe.caused_results.value = value
        timeframe
      ensure
        Timeframe.pop
      end
    end

    def find_introducing_change(object)
      @changes_by_return_value[object]
    end

    def to_timeframe_object(object)
      case object
      when Class
        TimeframeConstant.new object.name
      when nil
        TimeframeNil.new
      when Property
        change = find_introducing_change object.subject
        puts "change introducing object #{object}: #{change}"
        TimeframeProperty.new change, object.subject, object.name
      when String
        TimeframeString.new object
      when Object
        change = find_introducing_change object
        TimeframeObject.new object, change
      else
        raise "Can't convert to timeframe object: #{object}"
      end
    end

    def find_timeframe_object(timeframe_object)
      puts "timeframe_object: #{timeframe_object}"
      case timeframe_object
      when TimeframeConstant
        timeframe_object.name.constantize
      when TimeframeNil
        nil
      when TimeframeProperty
        change = find_change timeframe_object.id
        results = find_caused_results change
        value = results.value
        puts "#{value}.send #{timeframe_object.property_name}"
        value = value.send timeframe_object.property_name
        puts "value: #{value}"
        value
      when TimeframeObject
        change = find_change timeframe_object.id
        results = find_caused_results change
        value = results.value
        puts "value: #{value}"
        value
      else
        p timeframe_object
        raise "Unknown TimeframeObject type #{timeframe_object.class}"
      end
    end

    def alter_object(subject, delta_name, *args)
      puts "alter_object #{subject}, #{delta_name}, #{args}"

      change = Change.new self,
        @head,
        subject,
        :delta,
        delta_name,
        *args

      commit change

      Delta.new change
    end

    def enact_directive(subject, method, *args)
      puts "enact_directive #{subject}, #{method}, #{args}"

      change = Change.new self,
        @head,
        subject,
        :directive,
        method,
        *args

      commit change

      Directive.new change
    end

    def commit(change)
      @changes_by_id[change.id] = change
      @parent_changes_by_change[change] = @head
      @head = change
    end

    # def run_change(change)
    #   puts "run_change"
    #   p change
    #   value = case change.type
    #           when :directive
    #             subject = find_timeframe_object change.subject
    #             subject.send change.name, *change.args
    #           when :delta
    #             subject = find_timeframe_object change.subject
    #             Timeframe.delta_invoke subject, change.name, *change.args
    #           else
    #             raise "Unknown change type #{change.type}"
    #           end
    #   puts "#{self}.object_changes[#{value}] = #{change}"
    #   @object_changes[value] = change
    #   value
    # end

    class << self
      def current
        if self.stack.empty?
          self.push Timeline.current.root_timeframe
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
        puts "has_delta? #{subject}, #{prototype}"
        if prototype.is_a? Array
          method = prototype[0]
          subject.respond_to? method
        else
          name = prototype
          subject.class.delta_defined? name
        end
      end

      def delta_invoke(subject, delta_name, *args)
        puts "delta_invoke #{subject}.#{delta_name} #{args}"
        unless definition = subject.class.instance_delta(delta_name)
          raise "#{subject.class} has no delta definition for #{delta_name}"
        end
        subject.instance_exec *args, &definition
      end

      def has_property?(subject, property_name)
        puts "has_property? #{subject}, #{property_name}"
        subject.class.instance_properties.include? property_name.to_sym
      end

      def property_of(subject, property_name)
        self.current.property_of subject, property_name
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

      def find_caused_results(change)
        self.current.find_caused_results change
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
  end
end
