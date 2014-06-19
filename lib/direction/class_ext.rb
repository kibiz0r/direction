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
    name = name.to_sym
    instance_directives[name] = body
  end

  def instance_directive(name)
    name = name.to_sym
    instance_directive = instance_directives[name]

    if instance_directive.nil? && !superclass.nil?
      superclass.instance_directive name
    else
      instance_directive
    end
  end

  def instance_directives
    @instance_directives ||= {}
  end

  def instance_properties
    @instance_properties || []
  end

  def delta(name, &body)
    name = name.to_sym
    instance_deltas[name] = body
  end

  def instance_delta(name)
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
