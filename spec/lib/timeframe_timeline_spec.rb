require "spec_helper"

describe Direction::TimeframeTimeline do
  let :timeframe do
    Direction::Timeframe.new
  end

  let :director do
    double("director").tap do |d|
      id = 0
      allow(d).to receive(:generate_modification_id) { |m| id += 1 }
      allow(d).to receive(:eval_change).and_return nil
    end
  end

  let :timeline do
    Direction::Timeline.new director
  end

  subject do
    Direction::TimeframeTimeline.new timeframe, timeline
  end

  describe "#change" do
    it "returns a TimelineChange" do
      change = subject.change
      expect(change).to be_a(Direction::TimelineChange)
    end

    it "gives the change an id" do
      expect(director).to receive(:generate_modification_id).with(kind_of(Direction::TimelineChange)).and_return 5
      change = subject.change
      expect(timeframe.run { change.id }).to eq(5)
    end

    it "gives the change a timeline" do
      change = subject.change
      expect(timeframe.run { change.timeline }).to be_a(Direction::Timeline)
      expect(timeframe.run { change.timeline }).not_to eq(timeline)
    end

    it "evaluates the change in a new timeframe" do
      change_timeframe = nil
      expect(director).to receive(:eval_change).with(kind_of(Direction::TimelineChange)) do |change|
        change_timeframe = Direction::Timeframe.current
        5
      end
      change = subject.change
      expect(change_timeframe).to be_a(Direction::Timeframe)
      expect(change_timeframe).not_to eq(timeframe)
    end

    it "sets the return value of the change" do
      expect(director).to receive(:eval_change).and_return 5
      change = subject.change
      expect(timeframe.run { change.return_value }).to eq(5)
    end

    it "includes the change in a change set" do
      change = subject.change
      change_set = subject.change_sets.values.first
      expect(timeframe.run { change_set.change }).to eq(change)
    end

    context "with a previous change" do
      let! :previous_change do
        subject.change
      end

      it "parents the change to the previous change" do
        change = subject.change
        expect(timeframe.run { change.parent }).to eq(previous_change)
      end
    end

    it "runs a TimelineChange, then commits it to the Timeline" do
    end

    it "runs the new TimelineChange in a new Timeframe, with its own Timeline" do
    end
  end
end

# Timeframe
# - state:Hash<<Object, Symbol>, Object>
#
# Timeline
# - %change_sets:Hash<Id, ChangeSet>
#
# TimelineChangeSet
# - %parent:Id
# - %change:TimelineChange
# - %effects:Array<TimelineEffect>
#
# TimelineChange
# - %subject:Object
# - %name:Symbol
# - %args:Array<Object>
#
# TimelineEffect
# - %subject:Object
# - %name:Symbol
# - %args:Array<Object>
#
