require "spec_helper"

describe Direction::Timeframe do
  # let :director do
  #   double("director").tap do |d|
  #     id = 0
  #     allow(d).to receive(:generate_modification_id) { |m| id += 1 }
  #   end
  # end

  subject do
    Direction::Timeframe.new
  end

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
  #
  # The thing is, effects need to get ids, too. And they need them immediately,
  # so you can undo them within the change. Timeframe is going to need to get
  # a Director, and store Effects in a DAG like Timeline stores ChangeSets...
  # At which point, Timeframe looks an awful lot like Timeline...
  #
  # Maybe there still is a difference that I'm not seeing yet, as I do really
  # like the idea of separating the id/director part from the object/snapshot
  # part. Maybe I'll continue down this path until it really becomes apparent
  # that Timeframes == Timelines.
  #
  # It's also entirely possible that Timeline will end up being implemented in
  # terms of Timeframe features, so that when you query a Timeline, its values
  # are dependent on the current Timeframe.
  #
  # It seems like the best path forward is to follow the example of Git, and
  # create the basic toolkit of "plumbing" commands (Timeframe) then attach the
  # "porcelein" interface on top (Timeline).
  #
  # ---
  #
  # A Timeframe merges the world of purely object-based TimeframeChanges/Effects
  # with the world of Timelines, which at least ascribes an id to said changes/effects
  # and therefore allows it them to be referenced by id or reduced to a history.
  #
  # ---
  #
  # A Timeline's content is stored in the current Timeframe.
  #
  # Modifications get their own Timeframe and Timeline, for use in execution.
  #
  # Timeframes feed into the next Modification.
  #
  # When a Modification is done evaluating, and the Timeframe is in its set state,
  # the parent Timeline merges the Timeframe modifications in.
  #
  # o Timeframe root
  # | base: nil
  # | timeline: master
  # |
  # o ChangeSet 1
  #  \
  #   o Change 1
  #    \
  #     o Timeframe c1
  #     | base: Timeframe root
  #     | timeline: c1
  #     |
  #     o Effect 1
  #      \
  #       o Timeframe e1
  #       | base: Timeframe c1
  #       | timeline: e1
  #      /
  #     o Set e1.return_value: 5
  #    /
  #   o Set c1.return_value: 8
  #  /
  # o Set cs1.cause: c1
  # | cs1.effects: [e1]
  # |
  # o Set head: cs1
  #
  # Timeframes are the basis for the current state of the app, and have a naive
  # understanding of the tree of modifications. 
end
