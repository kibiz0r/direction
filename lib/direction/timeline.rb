module Direction
  class Timeline
    class << self
      alias :new :directionless_new
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

    def known_target?(target)
      if target.is_a? Class
        true
      else
        objects.has_key? target.object_id
      end
    end

    def directive_enact(target, name, *args)
      unless known_target? target
        raise TimelineError, "Object #{target.inspect} is unknown to this timeline (#{self.inspect})"
      end
      directive = Direction::Directive.new target, name, *args
      if name.to_s == "new"
        name = "directionful_new"
        args.unshift self
      end
      directive.value = target.send name, *args
      self.changes << directive
      directive
    end
  end
end
