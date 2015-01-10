class Class
  def directionful_new(timeline, *args, &block)
    object = directionless_new *args, &block
    timeline.add_object object
    # timeline.alter(object).initialized *args, &block
    object
  end
end
