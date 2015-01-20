module Direction
  module New
    def self.included(klass)
      klass.class_eval do
        alias_method :directionless_new, :new
      end
    end

    def directionful_new(*args, &block)
      directionless_new *args, &block
    end
  end
end
