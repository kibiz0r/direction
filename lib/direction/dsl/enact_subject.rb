module Direction
  class EnactSubject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args)
      if Snapshot.has_property? @subject, method and args.empty?
        EnactProperty.new @subject, method
      else
        Snapshot.enact @subject, nil, method, *args
      end
    end
  end

  class EnactProperty
    def initialize(subject, property_name)
      @subject = subject
      @property_name = property_name
    end

    def method_missing(method, *args)
      Snapshot.enact @subject, @property_name, method, *args
    end
  end

  class EnactValueSubject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(method, *args)
      if Snapshot.has_property? @subject, method and args.empty?
        EnactValueProperty.new @subject, method
      else
        Snapshot.enact(@subject, nil, method, *args).value
      end
    end
  end

  class EnactValueProperty
    def initialize(subject, property_name)
      @subject = subject
      @property_name = property_name
    end

    def method_missing(method, *args)
      Snapshot.enact(@subject, @property_name, method, *args).value
    end
  end
end

