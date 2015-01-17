class NilClass
  def to_timeline_object
    Direction::TimelineObject.new :nil
  end
end
