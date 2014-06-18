module Direction
  class DeltaDefinition
    attr_reader :body

    def initialize(&body)
      @body = body
    end
  end
end
