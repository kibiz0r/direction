class Object
  include Direction::DSL::Enact
  include Direction::DSL::Alter

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
      self.send operator, value
    end
  end
end
