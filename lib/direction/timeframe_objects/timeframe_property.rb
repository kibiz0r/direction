module Direction
  class TimeframeProperty
    attr_reader :introducing_change, :subject, :property_name

    def initialize(introducing_change, subject, property_name)
      @introducing_change = introducing_change
      @subject = subject
      @property_name = property_name
    end

    def id
      @introducing_change.id
    end
  end
end
