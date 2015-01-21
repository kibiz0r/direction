module Direction
  class ChangeResults
    attr_accessor :value

    def initialize(change)
      @change = change
    end

    def properties_of(subject)
      @object_properties ||= {}
      @object_properties[subject] ||= {}
    end

    def property_of(object, property_name)
      properties = properties_of object
      if properties.has_key? property_name
        properties[property_name]
      else
        properties[property_name] = Property.new object, property_name
      end
    end

    def get_property(subject, property_name)
      properties = properties_of subject
      if properties.has_key? property_name
        properties[property_name]
      elsif parent = @change && @change.parent
        parent_results = Timeframe.find_results parent
        parent_results.get_property subject, property_name
      end
    end
  end
end
