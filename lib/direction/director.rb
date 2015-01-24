module Direction
  class Director
    def initialize
      @properties = {}
    end

    def find_property(subject, name)
      key = [subject, name.to_sym]
      if @properties.has_key? key
        puts "already has property #{subject}, #{name}"
        return @properties[key]
      end
      has = subject.class.instance_properties.include? name.to_sym
      puts "has property? #{subject}, #{name} : #{has}"
      if has
        @properties[key] ||= Property.new subject, name
      end
    end

    def find_timeline_property(subject, name)
      TimelineProperty.new subject, name
    end

    def alter_object(timeframe, subject, name, *args)
      puts "alter_object #{subject}, #{name}, #{args}"

      change = timeframe.change :delta,
        subject,
        name,
        *args

      Delta.new change
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

    def enact_directive(timeframe, subject, name, *args)
      change = timeframe.change :directive,
        subject,
        name,
        *args

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
        change.subject.send change.type, change.name, *change.args
        # subject = change.subject
        # name = change.name
        # args = change.args

        # case change.type
        # when :directive
        #   puts "directive #{change}"
        #   subject.send name, *args
        # when :delta
        #   puts "delta #{change}"
        #   subject.send_delta name, *args
        # else
        #   raise "Unknown change type #{change.type}"
        # end
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

    def directive_value(directive)
      puts "directive_value #{directive}"
      Timeframe[directive.change].return_value
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
        :delta_value
    end
  end
end
