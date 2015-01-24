class Class
  def instance_properties
    properties = []
    define_singleton_method :instance_properties do
      properties
    end
    instance_properties
  end

  def prop_accessor(*names)
    names.each do |name|
      name = name.to_sym

      getter = name
      setter = :"#{name}="

      instance_properties << name

      define_method getter do
        property = property_get name
        define_singleton_method getter do
          property.value
        end
        define_singleton_method setter do |value|
          property.set value
        end
        property.value
      end

      define_method setter do |v|
        property = property_get name
        define_singleton_method getter do
          property.value
        end
        define_singleton_method setter do |value|
          property.set value
        end
        property.set v
      end
    end
  end
end
