module Direction
  class Change
    attr_reader :subject, :type, :name, :args

    def initialize(subject, type, name, *args)
      # @subject = subject.to_timeline_object
      @subject = Timeline.to_timeline_object subject
      @type = type
      @name = name
      @args = args.map { |a| Timeline.to_timeline_object a }
    end

    def id
      object_id
    end
  end
end
