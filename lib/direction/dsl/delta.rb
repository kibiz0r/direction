module Direction
  module DSL
    module Delta
      # #delta means that you intend to return a new value as the result of the delta.
      # This implies that this delta must be stored on a property.
      def delta(name, &body)
        name = name.to_sym
        instance_deltas[name] = body
      end

      # #delta! means that you intend to mutate self in order to apply the delta.
      # This implies that this delta must be stored on self.
      def delta!(name, &body)
        name = name.to_sym
        instance_deltas[name] = body
      end

      def delta_defined?(name)
        !instance_delta(name).nil?
      end

      def instance_delta(prototype)
        if prototype.is_a? Array
          return nil
        else
          name = prototype
        end
        name = name.to_sym
        instance_delta = instance_deltas[name]

        if instance_delta.nil? && !superclass.nil?
          superclass.instance_delta name
        else
          instance_delta
        end
      end

      def instance_deltas
        @instance_deltas ||= {}
      end
    end
  end
end
