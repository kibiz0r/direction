module Direction
  class AlterProperty
    def initialize(subject, property_name)
      @subject = subject
      @property_name = property_name
    end

    def method_missing(delta_name, *args)
      @subject.property_alter @property_name, delta_name, *args
    end
  end
end
