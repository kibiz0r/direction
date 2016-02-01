class Class
  def timeframe_prop_accessor(name)
    name = name.to_sym

    define_method name do
      Direction::Timeframe.current.get_property self, name
    end

    define_method :"#{name}=" do |value|
      Direction::Timeframe.current.set_property self, name, value
    end
  end
end
