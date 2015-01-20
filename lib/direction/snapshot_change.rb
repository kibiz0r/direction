module Direction
  class SnapshotChange
    attr_reader :subject, :property_name, :type, :name, :args

    def initialize(subject, property_name, type, name, *args)
      @subject = subject
      @property_name = property_name
      @type = type
      @name = name
      @args = args
    end

    def value
      Snapshot.find_change_value self
    end
  end
end
