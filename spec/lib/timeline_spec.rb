require "spec_helper"

describe Direction::Timeline do
  describe "materializing changes" do
    class Foo
    end

    it "executes the changes in a new timeframe" do
      foo_reference = subject.change :directive,
        TimelineConstant.new(:Foo),
        :new
      foo = subject.resolve foo_reference
      expect(foo).to be_a(Foo)
    end
  end
end
