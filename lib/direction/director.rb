module Direction
  class Director
    def find_property(subject, name)
      has = subject.class.instance_properties.include? name.to_sym
      puts "has property? #{subject}, #{name} : #{has}"
      if has
        Property.new subject, name
      end
    end

    def find_timeline_property(subject, name)
      TimelineProperty.new subject, name
    end

    def alter_object(subject, name, *args)
      puts "alter_object #{subject}, #{name}, #{args}"

      change = Timeframe.change :delta,
        subject,
        name,
        *args

      Delta.new Timeframe.current, change
    end

    def get_property(timeframe, subject, name)
      puts "get_property #{timeframe}, #{subject}, #{name}"
      key = [subject, name.to_s]
      timeframe.properties[key]
    end

    def enact_directive(subject, name, *args)
      change = Timeframe.change :directive,
        subject,
        name,
        *args

      # adds a change to the current timeline
      # - then turns it into a timeframe change?
      # - and doing so causes:
      # runs the change's code in a new timeframe
      # but doesn't collapse it to a result for the timeline yet
      Directive.new Timeframe.current, change
      # accessing the directive value is fine, and only requires having the
      # timeframe result
      #
      # but setting a property to the directive value (or returning it from
      # this directive, or enacting/altering on it) requires making it (and
      # the change that created it) available on this timeline
    end

    def timeframe_change(timeframe, change)
      puts "timeframe_change #{timeframe}, #{change}"
      # turns a timeline change into a timeframe change
      change_timeframe = timeframe.run do |t|
        subject = to_timeframe_object t, change.subject
        args = change.args.map do |arg|
          to_timeframe_object t, arg
        end

        # subject.send change.type, args

        case change.type
        when :directive
          puts "directive #{change}"
          subject.send change.name, *args
        when :delta
          puts "delta #{change}"
          subject = to_timeframe_object t, change.subject
          puts "on #{subject}"
          unless definition = subject.class.instance_delta(change.name)
            raise "#{subject.class} has no delta definition for #{change.name}"
          end
          return_value = subject.instance_exec *args, &definition
          if change.subject.is_a? TimelineProperty
            owner = to_timeframe_object t, change.subject.subject
            key = [owner, change.subject.name]
            t.properties[key] = return_value
          end
          return_value
        else
          raise "Unknown change type #{change.type}"
        end
        # run change
      end
      timeframe.merge! change_timeframe
      TimeframeChange.new change_timeframe, change
    end

    def to_timeframe_object(timeframe, timeline_object)
      case timeline_object
      when Change
        timeframe.commit timeline_object
      when TimelineConstant
        timeline_object.name.constantize
      when TimelineProperty
        subject = to_timeframe_object timeframe, timeline_object.subject
        key = [subject, timeline_object.name]
        timeframe.properties[key]
      when TimelineString
        timeline_object.value
      when TimelineObject
        change = timeline_object.introducing_change
        timeframe[change].return_value
      else
        raise "Unknown timeline object type #{timeline_object.class}"
      end
    end

    def to_timeline_object(object)
      case object
      when Class
        TimelineConstant.new object.name
      when Property
        TimelineProperty.new object.subject, object.name
      when String
        TimelineString.new object
      when Object
        introducing_change = Timeframe.current.changes.to_a.find do |key, change|
          change.return_value == object
        end[1].change
        puts "introducing_change"
        p introducing_change
        TimelineObject.new introducing_change
      else
        raise "Unknown conversion to timeline object for type #{object.class}"
      end
    end

    def directive_value(directive)
      # timeframe_change = directive.timeframe[directive.change]
      timeframe_change = directive.change
      puts "#{timeframe_change}.return_value: #{timeframe_change.return_value}"
      timeframe_change.return_value
      # get return value of change in this timeframe
      # does not require return value being known as a timeline object yet
    end

    def delta_value(delta)
    end

    class << self
      def current
        @current ||= new
      end

      def find_property(subject, name)
        current.find_property subject, name
      end

      def get_property(timeframe, subject, name)
        current.get_property timeframe, subject, name
      end

      def alter_object(subject, name, *args)
        current.alter_object subject, name, *args
      end

      def enact_directive(subject, name, *args)
        current.enact_directive subject, name, *args
      end

      def timeframe_change(timeframe, change)
        current.timeframe_change timeframe, change
      end

      def to_timeframe_object(timeframe, timeline_object)
        current.to_timeframe_object timeframe, timeline_object
      end

      def to_timeline_object(object)
        current.to_timeline_object object
      end

      def directive_value(directive)
        current.directive_value directive
      end

      def delta_value(delta)
        current.delta_value delta
      end
    end
  end
end
