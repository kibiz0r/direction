module Direction
  class Change
    attr_reader :previous_change, :type, :subject, :name, :args

    def initialize(previous_change, type, subject, name, *args)
      @previous_change = previous_change
      @type = type
      @subject = Director.to_timeline_object subject
      @name = name
      @args = args.map { |a| Director.to_timeline_object a }
    end

    def id
      object_id
    end

    def key
      [:change, id]
    end

    def to_s
      "Change: (#{type}) #{@subject}.#{@name} #{@args}"
    end
  end
end
