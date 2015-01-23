module Direction
  class TimelineProperty
    attr_reader :subject, :name

    def initialize(subject, name)
      @subject = Director.to_timeline_object subject
      @name = name
    end

    def key
      [:property, *subject.key, name]
    end
  end
end
