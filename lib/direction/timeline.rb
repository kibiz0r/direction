module Direction
  class Timeline
    class << self
      alias :new :directionless_new

      def current
        @current ||= Timeline.new nil
      end

      def changes
        self.current.changes
      end
    end

    def initialize(owner)
      @owner = owner
      add_object @owner
    end

    def to_s
      "timeline~#{@owner}#{objects}"
    end

    def inspect
      "timeline~#{@owner.inspect}#{objects.inspect}"
    end

    def add_object(object)
      unless object.is_a? Class
        objects[object.object_id] = object
      end
    end

    def objects
      @objects ||= {}
    end

    def changes
      @changes ||= []
    end

    def enact(subject)
      Direction::EnactSubject.new self, subject
    end

    def enact!(subject)
      Direction::EnactValueSubject.new self, subject
    end

    def known_target?(target)
      return true
      if target.is_a? Class
        true
      elsif target.is_a? Property
        true
      else
        objects.has_key? target.object_id
      end
    end

    def resolve_target(target)
      # unless known_target? target
      #   raise TimelineError, "Object #{target.inspect} is unknown to this timeline (#{self.inspect})"
      # end
      if target.is_a? Property
        target.value
      else
        target
      end
    end

    def resolve_subject(target)
      # unless known_target? target
      #   raise TimelineError, "Object #{target.inspect} is unknown to this timeline (#{self.inspect})"
      # end
      if target.is_a? Property
        target.subject
      else
        target
      end
    end

    def directive_enact(target, name, *args)
      resolved_target = resolve_target target
      resolved_subject = resolve_subject target

      directive = Direction::Directive.new resolved_target, name, *args

      if name.to_s == "new"
        name = "directionful_new"
        args.unshift self
      end

      if target.is_a? Property
        directive.property_name = target.name
      end

      directive.initiator = resolved_subject

      Timeline.changes << directive

      directive.value = resolved_target.send name, *args

      directive
    end
  end
end
