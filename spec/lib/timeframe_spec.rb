require "spec_helper"

describe Direction::Timeframe do
  describe "#change" do
    it "returns a TimeframeChange" do
      change = subject.change
      expect(change).to be_a(Direction::TimeframeChange)
    end

    context "with a block" do
      it "passes a ChangeTimeframe" do
        passed_timeframe = nil
        subject.change do |timeframe|
          passed_timeframe = timeframe
        end
        expect(passed_timeframe).to be_a(Direction::ChangeTimeframe)
      end

      it "sets Timeframe.current to the passed ChangeTimeframe" do
        current_timeframe = nil
        passed_timeframe = nil
        subject.change do |timeframe|
          passed_timeframe = timeframe
          current_timeframe = Direction::Timeframe.current
        end
        expect(current_timeframe).to eq(passed_timeframe)
      end

      it "lets you set the return value of the TimeframeChange" do
        change = subject.change do
          5
        end
        expect(change.return_value).to eq(5)
      end

      it "lets you add effects" do
        change = subject.change do |timeframe|
          timeframe.effect
        end
        expect(change.effects[0]).to be_a(Direction::TimeframeEffect)
      end

      it "lets you set the return value on a nested effect" do
        change = subject.change do |timeframe|
          timeframe.effect do
            5
          end
        end
        expect(change.effects[0].return_value).to eq(5)
      end

      it "lets you reference a property" do
        foo = Object.new
        subject.set_property foo, :bar, 5
        change = subject.change do |timeframe|
          timeframe.get_property foo, :bar
        end
        expect(change.return_value).to eq(5)
      end
    end
  end

  # What do I really need out of a timeframe, from the perspective of a timeline?
  # I need to associate it with a change/effect, so that I can answer questions about:
  # - the objects involved
  # - the return value
  # For a ChangeTimeframe, I need to know its effects.
  #
  # Okay, scratch all that. You can do everything you'd want to do to a
  # Timeline just using TimeframeChanges/Effects. The important thing about
  # Timeframes is that they know what the value of a property is at this point
  # in time. The user of a Timeframe can provide whatever snapshot they want,
  # but if they add it to a Timeline, that snapshot may be invalidated by
  # modifications to the Timeline, in which case the Timeline will generate a
  # new snapshot and re-evaluate the TimeframeChange/Effect in a new Timeframe.
  #
  # So, Timelines need to be able to generate a snapshot for any point in the
  # change graph, including effects. But Timeframes also need to be able to
  # generate snapshots, because each effect you pile on feeds into the next.
  #
  # So maybe it's actually Timeframes that generate snapshots? Arrrgh...
end
