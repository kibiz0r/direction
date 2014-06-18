class Class
  def prop_accessor(*names)
    names.each do |name|
      name = name.to_sym
      ivar = :"@#{name}"
      getter = name
      setter = :"#{name}="

      instance_properties << name

      define_method getter do
        property_get name
      end

      define_method setter do |value|
        property_set name, value
      end
    end
  end

  def directive(name, &body)
    instance_directives[name] = Direction::DirectiveDefinition.new &body
  end

  def instance_directive(name)
    instance_directives[name]
  end

  def instance_directives
    @instance_directives ||= {}
  end

  def instance_properties
    @instance_properties || []
  end
end
