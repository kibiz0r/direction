module Direction
  module PropAccessor
    def instance_properties
      @instance_properties || []
    end

    def prop_accessor(*names)
      names.each do |name|
        name = name.to_sym

        getter = name
        setter = :"#{name}="

        instance_properties << name

        define_method getter do
          Timeframe.get_property self, name
        end

        define_method setter do |value|
          Timeframe.set_property self, name, value
        end
      end
    end
  end
end
