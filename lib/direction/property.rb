module Direction
  class Property
    attr_reader :subject, :name

    def initialize(subject, name)
      @subject = subject
      @name = name
    end

    def to_s
      "Property(#{subject}, #{name})"
    end
  end
end
