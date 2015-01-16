class Class
  def directionful_new(*args, &block)
    object = directionless_new *args, &block
    # Timeline.add_object object
    # timeline.alter(object).initialized *args, &block
    object
  end
end
