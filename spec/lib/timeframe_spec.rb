require "spec_helper"

describe Direction::Timeframe do
  subject do
    described_class.new
  end

  class Foo
    prop_accessor :bar
  end

  describe "#directive" do
    it "adds a directive and returns it" do
      foo_directive = subject.directive Foo, :new

      expect(foo_directive).to be_a(Direction::Directive)
      expect(subject.head).to eq(foo_directive)
    end

    it "evaluates the directive" do
      foo = subject.directive(Foo, :new).value

      expect(foo).to be_a(Foo)
    end
  end

  describe "#delta" do
    it "adds a delta and returns it" do
      foo = Foo.new
      bar_delta = subject.delta foo.property_get(:bar), :set, 5

      expect(bar_delta).to be_a(Direction::Delta)
      expect(subject.head).to eq(bar_delta)
    end
  end

  # describe ".new" do
  #   it "makes a new timeframe" do
  #     timeframe = Timeframe.new(
  #       [:state, 123] => { foo: 5 }
  #     )
  #     timeframe.run do
  #       # make global changes to Timeframe.current
  #     end
  #   end
  # end

  describe "#branch" do
    describe "with a block" do
      it "branches the timeframe and evaluates the block" do
        branched = subject.branch do
          Timeframe.current.change # ...
        end

        expect(branched).to be_a(Timeframe)
      end
    end

    describe "without a block" do
      it "branches the timeframe" do
        branched = subject.branch

        expect(branched).to be_a(Timeframe)
      end
    end

    it "remains unaffected by further changes on the base timeframe" do
      branched = subject.branch

      branched_change = branched.change # ...

      subject.change # ...

      expect(branched[ref]).to eq(original_value)
    end

    it "is affected by modifications to changes on the base timeframe" do
      change = subject.change # ...
      branched = subject.branch

      # make a change that depends on the first change
      branched_change = branched.change # ...

      # modify change on base timeframe
      change.args[0] = 5

      # see that the base modification has affected the branch
      expect(branched_change.return_value).to eq(something)
    end
  end

  describe "#merge" do
    it "adds the branched changes to the base timeframe" do
      branched = subject.branch do
        # ...
      end

      subject.merge branched

      # timeframe[change] => timeframe_state
      # timeframe.head => change
      # timeframe[some_change] =>
      #   some_change.run timeframe[some_change.parent] => new_state
      # timeframe[object] => timeframe_object_state
      expect(subject[ref]).to eq(branched_value)
    end
  end
end
