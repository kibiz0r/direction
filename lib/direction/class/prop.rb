class Class
  def instance_properties
    @instance_properties ||= []
  end

  def prop_accessor(*names)
    names.each do |name|
      name = name.to_sym

      getter = name
      setter = :"#{name}="

      instance_properties << name

      define_method getter do
        ::Direction::Director.get_property ::Direction::Timeframe.current, self, name
      end

      define_method setter do |value|
        ::Direction::Director.set_property ::Direction::Timeframe.current, self, name
      end
    end
  end
end
