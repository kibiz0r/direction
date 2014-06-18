module Direction
  class DirectiveDefinition
    attr_reader :body

    def initialize(&body)
      @body = body
    end
  end
end
