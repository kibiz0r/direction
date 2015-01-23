require "direction/object/enact"
require "direction/object/alter"

class Object
  delta :set do |value|
    value
  end

  [
    :+,
    :-,
    :*,
    :/,
    :%,
    :<<
  ].each do |operator|
    delta operator do |value|
      send operator, value
    end
  end
end