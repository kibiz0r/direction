module Direction
  class Change
    attr_reader :type, :name, :property

    def initialize(parent, target, property, type, name, *args)
      @parent = parent.to_timeline_object
      @target = target.to_timeline_object
      @object = TimelineObject.new :object, self.id
      @type = type
      @name = name
      @property = property
      @args = args.map &:to_timeline_object
    end

    def parent
      @parent.value
    end

    def target
      @target.value
    end

    def object
      @object.value
    end

    def args
      @args.map &:value
    end

    def id
      self.object_id
    end

    def to_timeline_object
      TimelineObject.new :change, self.id
    end
  end
end
