class Object
  def property_get(name)
    properties = {}
    define_singleton_method :property_get do |name|
      name = name.to_sym
      if property = properties[name]
        property
      elsif property_defined? name
        properties[name] = ::Direction::Property.new self, name
      end
    end
    property_get name
  end

  def property_defined?(name)
    self.class.instance_properties.include? name.to_sym
  end
end
