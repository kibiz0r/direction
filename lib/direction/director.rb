module Direction
  class Director
    def alter_object(timeframe, subject, name, *args)
      puts "alter_object #{subject}, #{name}, #{args}"

      change = timeframe.change :delta,
        subject,
        name,
        *args

      Delta.new change
    end

    def property_value(timeframe, property)
      puts "property_value"
      timeframe_property = timeframe.to_timeframe_object property
      v = timeframe_property.value.object
      puts "#{timeframe_property}.value: #{v.inspect}"
      v
    end

    def get_property(timeframe, subject, name)
      puts "get_property #{timeframe}, #{subject}, #{name}"
      key = [subject, name.to_s]
      timeframe.properties[key]
    end

    def set_property(timeframe, subject, name, value)
      property = find_property subject, name
      alter_object timeframe, property, :set, value
    end

    def timeframe_commit(timeframe, change)
      puts "timeframe_commit #{timeframe}, #{change}"
      parent_key = [:parent, change]
      timeframe[parent_key] = timeframe.head

      change_key = [:change, change]
      timeframe[change_key] = change

      state_key = [:state, change]
      timeframe[state_key] = timeframe.run do |t|
        case change.type
        when :directive
          change.subject.send change.name, *change.args
        when :delta
        end
      end.state

      timeframe.head = key
    end

    def enact_directive(timeframe, subject, name, *args)
      change = TimeframeChange.new :directive,
        subject,
        name,
        *args

      timeframe_commit timeframe, change

      # adds a change to the current timeline
      # - then turns it into a timeframe change?
      # - and doing so causes:
      # runs the change's code in a new timeframe
      # but doesn't collapse it to a result for the timeline yet
      Directive.new change
      # accessing the directive value is fine, and only requires having the
      # timeframe result
      #
      # but setting a property to the directive value (or returning it from
      # this directive, or enacting/altering on it) requires making it (and
      # the change that created it) available on this timeline
    end

    def change_timeframe(timeframe, change)
      puts "change_timeframe #{timeframe}, #{change}"

      change_timeframe = timeframe.run do |t|
        case change.type
        when :directive
          change.subject.send change.name, *change.args
        when :delta
          change.subject.send_delta change.name, *change.args
        else
          raise "Unknown change type #{change.type}"
        end
      end

      timeframe.merge! change_timeframe

      change_timeframe
    end

    def to_timeframe_object(timeframe, object)
      puts "to_timeframe_object #{timeframe}, #{object}"
      case object
      when Class
        TimeframeConstant.new timeframe, object.name
      when Property
        puts "TimeframeProperty.new"
        TimeframeProperty.new timeframe, object
      when Object
        TimeframeObject.new timeframe, object
      else
        raise "Unknown conversion to timeframe object for #{object}"
      end
    end

    def from_timeframe_object(timeframe, timeframe_object)
      case timeframe_object
      when TimeframeConstant
        timeframe_object.name.constantize
      when TimeframeProperty
        timeframe_object.property
      when TimeframeObject
        timeframe_object.object
      else
        raise "Unknown timeframe object type #{timeframe_object}"
      end
    end

    def to_timeline_reference(timeframe, object)
      case object
      when Class
        TimelineConstant.new object.name
      else
        TimelineObject.new to_timeline_change(timeframe, nil, timeframe.find_introducing_change(object))
      end
    end

    def to_timeline_change(timeframe, previous_change, timeframe_change)
      type = timeframe_change.type
      subject = to_timeline_reference timeframe, timeframe_change.subject
      name = timeframe_change.name
      args = timeframe_change.args.map { |a| to_timeline_reference timeframe, a }

      Change.new previous_change,
        type,
        subject,
        name,
        *args
    end

    def timeframe_to_timeline(timeframe)
      # turn object-based timeframe changes into
      # id-based timeline changes
      changes, head = timeframe.changes.inject [[], nil] do |(changes, previous_change), timeframe_change|
        change = to_timeline_change timeframe, previous_change, timeframe_change

        changes << change
        [changes, change]
      end
      Timeline.new changes, head
    end

    def directive_value(directive)
      puts "directive_value #{directive}"
      r = Timeframe[directive.change].return_value
      p r
      r
    end

    def delta_value(delta)
      puts "delta_value #{delta}"
    end

    class << self
      def current
        @current ||= new
      end

      extend Forwardable

      def_delegators :current,
        :find_property,
        :get_property,
        :set_property,
        :alter_object,
        :enact_directive,
        :change_timeframe,
        :to_timeframe_object,
        :from_timeframe_object,
        :to_timeline_object,
        :directive_value,
        :delta_value,
        :property_value,
        :timeframe_to_timeline
    end
  end
end
