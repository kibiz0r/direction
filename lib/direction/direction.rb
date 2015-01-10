# This approach relies on users call super in initialize, which is probably a
# bad thing to rely on...
module Direction
  def initialize
    @history = History.new
  end

  def history
    @history
  end
end
