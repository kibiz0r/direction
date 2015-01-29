require "spec_helper"

describe Direction::Timeline do
  class Foo
    prop_accessor :my_prop

    def set_my_prop
      self.my_prop = 5
    end
  end

  describe "#change" do
    subject do
      Direction::Timeline.new
    end

    it "commits the change and returns the result" do
      foo = subject.change :directive,
        Direction::TimelineConstant.new(:Foo),
        :new

      expect(foo).to be_a(Foo)
    end
  end

  describe "#commit" do
    it "commits the change and returns a change set" do
      change = Direction::Change.new subject.head,
        :directive,
        Direction::TimelineConstant.new(:Foo),
        :new

      change_set = subject.commit change

      expect(change_set.return_value).to be_a(Foo)
    end

    describe "a change with effects" do
      it "includes the effects in the returned change set" do
        new_change = Direction::Change.new subject.head,
          :directive,
          Direction::TimelineConstant.new(:Foo),
          :new

        subject.commit new_change

        set_change = Direction::Change.new new_change.key,
          :directive,
          Direction::TimelineObject.new(new_change),
          :set_my_prop

        change_set = subject.commit set_change

        set_delta = change_set.effects[0]

        expect(set_delta.return_value).to eq(5)
      end
    end
  end
end
