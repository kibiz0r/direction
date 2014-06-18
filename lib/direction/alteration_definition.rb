module Direction
  class AlterationDefinition
    attr_reader :body

    def initialize(&body)
      @body = body
    end
  end
end
