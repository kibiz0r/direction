require "spec_helper"

describe Direction::Timeline do
  let :director do
    double("director").tap do |d|
      allow(d).to receive(:eval_change)
      id = 0
      allow(d).to receive(:id_change) { |c| id += 1 }
    end
  end

  subject do
    Direction::Timeline.new director
  end

  describe "#change" do
    it "creates a change and evaluates it" do
      expect(director).to receive(:eval_change).with(kind_of(Direction::Change), kind_of(Direction::Timeframe)).and_return :a_timeframe
      subject.change nil, :nothing
    end

    it "returns a timeline change" do
      change = subject.change nil, :nothing
      expect(change).to be_a(Direction::TimelineChange)
    end

    it "ties the result of change evaluation to the returned change" do
      allow(director).to receive(:eval_change).with(kind_of(Direction::Change), kind_of(Direction::Timeframe)).and_return :a_timeframe
      change = subject.change nil, :nothing
      expect(change.timeframe).to eq(:a_timeframe)
    end

    it "associates an id to the change" do
      change = subject.change nil, :nothing
      expect(change.id).to eq(1)
    end

    context "when a change already exists" do
      let! :one_change do
        subject.change nil, :one_change
      end

      it "returns a change parented to the existing change" do
        change = subject.change nil, :two_change
        expect(change.parent).to eq(one_change)
      end

      it "associates a different id to the new change" do
        change = subject.change nil, :two_change
        expect(change.id).to eq(2)
      end
    end
  end

  describe "#write" do
    let :my_change do
      Direction::Change.new nil, nil, :whatever
    end

    let :my_effects do
      [
        Direction::Effect.new
      ]
    end

    let :my_change_set do
      Direction::ChangeSet.new my_change, my_effects
    end

    it "adds a change with a specified id" do
      subject.write 2, my_change_set
      expect(subject.find_change(2)).to eq(my_change)
    end

    it "returns the added change" do
      returned_change_set = subject.write 2, my_change_set
      expect(returned_change_set).to eq(my_change_set)
    end

    it "doesn't evaluate the added change" do
      expect(director).to_not receive(:eval_change)
      subject.write 2, my_change_set
    end
  end

  describe "#commit" do
    let :my_change do
      Direction::Change.new nil, nil, :whatever
    end

    let :my_effects do
      [
        Direction::Effect.new
      ]
    end

    let :my_change_set do
      Direction::ChangeSet.new my_change, my_effects
    end

    before do
      allow(director).to receive(:eval_effects).with(my_effects, kind_of(Direction::Timeframe)).and_return :a_timeframe
    end

    it "writes a change" do
      subject.commit my_change_set
    end

    it "associates an id to the change" do
      allow(director).to receive(:id_change).with(my_change).and_return :an_id
      subject.commit my_change_set
      expect(subject.find_change(:an_id)).to eq(my_change)
    end

    it "updates head to point to the committed change" do
      timeline_change_set = subject.commit my_change_set
      expect(subject.head).to eq(timeline_change_set)
    end

    it "evaluates the change" do
      expect(director).to receive(:eval_effects).with(my_effects, kind_of(Direction::Timeframe)).and_return :a_timeframe
      subject.commit my_change_set
    end
  end

  describe "#amend" do
    let :new_effects do
      [
        Direction::Effect.new,
        Direction::Effect.new
      ]
    end

    before do
      subject.change nil, :one_change
      subject.change nil, :two_change
    end

    it "re-evaluates the effects" do
      timeframe_one = subject.timeframe 1
      expect(director).to receive(:eval_effects).with(new_effects, timeframe_one).and_return :new_timeframe
      subject.amend 2, new_effects
    end

    context "on a parent change" do
      it "re-evaluates descendant changes" do
      end
    end
  end

  describe "#replace" do
    it "re-evaluates the change" do
    end

    it "keeps the same id" do
    end

    context "on a parent change" do
      it "re-evaluates descendant changes" do
      end
    end
  end
end
