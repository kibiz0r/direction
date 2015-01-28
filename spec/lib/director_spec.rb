require "spec_helper"

describe Direction::Director do
  subject do
    described_class.new
  end

  describe "#timeframe_to_timeline" do
    class Foo
      def do_stuff
        "did stuff"
      end
    end

    let :timeframe do
      Direction::Timeframe.new nil do |t|
        foo = t.change :directive,
          Foo,
          :new
        t.change :directive,
          foo,
          :do_stuff
      end
    end

    it "converts object-based timeframe changes into canonical id-based timeline changes" do
      timeline = subject.timeframe_to_timeline timeframe

      new_change = Direction::Change.new(
        nil,
        :directive,
        Direction::TimelineConstant.new(:Foo),
        :new
      )
      do_stuff_change = Direction::Change.new(
        new_change.key,
        :directive,
        Direction::TimelineObject.new(new_change),
        :do_stuff
      )
      changes = [
        new_change,
        do_stuff_change
      ]
      expect(timeline.changes).to eq(changes)
    end
  end
end
