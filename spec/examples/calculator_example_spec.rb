require "spec_helper"

# For everything, ask "How does this depend on the current timeline?"
describe "Calculator Example" do
  class Calculator
    prop_accessor :display

    def initialize
      puts "Calculator.new"
    end

    def press_5
      "pressed 5"
    end

    def enact_press_5
      enact.press_5
    end

    def alter_display_123
      alter.display = 123
    end
  end

  class CalculatorController
    attr_reader :calculator

    def initialize
      @calculator = enact!(Calculator).new
    end

    def do_press_5
      enact!(@calculator).press_5
    end

    def enact_do_press_5
      enact!.do_press_5
    end
  end

  class CalculatorPropertyController
    prop_accessor :calculator

    def initialize
      # FIXME
      # This will cause infinite recursion, because this enact! happens
      # within the enact!.new of this class
      c = enact!(Calculator).new
      puts "c:"
      p c
      self.calculator = c
      # @calculator = Property(Calculator).new
    end

    def do_press_5
      # will be tracked by property name,
      # not as the return value of the enact!(Calculator).new directive
      enact!.calculator.press_5
    end

    def enact_do_press_5
      enact!.do_press
    end
  end

  describe "CalculatorPropertyController.new" do
    subject do
      enact!(CalculatorPropertyController).new
      # Should be:
      # CalculatorPropertyController.new
      # ...but right now, everything must be hung off of constants
    end

    let :calculator do
      subject.calculator
    end

    describe "#do_press_5" do
      it "presses 5 within this timeline" do
        expect(subject).to be_a(CalculatorPropertyController)

        subject.do_press_5

        change_set_0 = Direction::Timeline.current.change_set_at 0
        change_0 = change_set_0.change
        expect(change_0.name).to eq(:new)
        expect(change_0.subject).to eq(Direction::TimelineConstant.new(:CalculatorPropertyController))
        expect(change_0.return_value).to be_a(Direction::TimelineObject)
        expect(change_0.return_value.source).to eq(change_0)

        controller_reference = change_0.return_value
        controller_calculator_reference = Direction::TimelineProperty.new controller_reference, :calculator

        change_set_1 = Direction::Timeline.current.change_set_at 1
        change_1 = change_set_1.change
        expect(change_1.name).to eq(:press_5)
        expect(change_1.subject).to eq(controller_calculator_reference)
        expect(change_1.return_value).to be_a(Direction::TimelineObject)

        p Direction::Timeline.current.change_sets
        p Direction::Timeframe.current.timeframe_objects

        change = calculator.object_history.changes[0]
        expect(change.name).to eq(:new)
        expect(change.target).to eq(Calculator)

        change = calculator.object_history.changes[1]
        expect(change.name).to eq(:press_5)
        expect(change.target).to eq(calculator)

        change = subject.object_history.changes[0]
        expect(change.name).to eq(:set)
        expect(change.property).to eq(:calculator)
        expect(change.args).to eq([calculator])

        Timeline.changes.each do |change|
          p change
          p change.target
        end

        change = subject.object_history.changes[1]
        expect(change.name).to eq(:press_5)
        expect(change.property_name).to eq(:calculator)
        expect(change.target).to eq(calculator)
      end
    end
  end

  describe "CalculatorController.new" do
    subject do
      CalculatorController.new
    end

    let :calculator do
      subject.calculator
    end

    describe "#do_press_5" do
      it "presses 5 within this timeline" do
        subject.do_press_5

        change = calculator.object_history.changes[0]
        expect(change.name).to eq(:press_5)
        expect(change.target).to eq(calculator)
      end
    end

    describe "enact(subject).do_press_5" do
      it "presses 5 within this timeline" do
        enact(subject).do_press_5

        change = subject.object_history.changes[0]
        expect(change.name).to eq(:do_press_5)
        expect(change.target).to eq(subject)

        change = calculator.object_history.changes[0]
        expect(change.name).to eq(:press_5)
        expect(change.target).to eq(calculator)
      end
    end

    describe "subject.enact_do_press_5" do
      it "presses 5 within this timeline" do
        subject.enact_do_press_5

        change = subject.object_history.changes[0]
        expect(change.name).to eq(:do_press_5)
        expect(change.target).to eq(subject)

        change = subject.object_history.changes[1]
        expect(change).to be_nil

        change = calculator.object_history.changes[0]
        expect(change.name).to eq(:press_5)
        expect(change.target).to eq(calculator)
      end
    end
  end

  describe "enact(Calculator).new" do
    let :calculator do
      new.value
    end

    let :new do
      enact(Calculator).new
    end

    it "creates a new Calculator and adds its creation to the current\n
    timeline, making it available on this history" do
      expect(new).to be_a(Directive)
      expect(calculator).to be_a(Calculator)

      change = Timeline.changes[0]
      expect(change.name).to eq(:new)
      expect(change.target).to eq(Calculator)
    end

    describe "enact(calculator).press_5" do
      it "adds a directive for press_5" do
        press_5 = enact(calculator).press_5

        expect(press_5).to be_a(Directive)

        change = Timeline.changes[1]
        expect(change.name).to eq(:press_5)

        change = calculator.object_history.changes[0]
        expect(change.name).to eq(:press_5)
      end
    end

    describe "alter(calculator).display = 123" do
      it "adds a delta for display = 123" do
        alter(calculator).display = 123

        expect(calculator.display).to eq(123)

        change = Timeline.changes[1]
        expect(change.property).to eq(:display)
        expect(change.name).to eq(:set)
        expect(change.args).to eq([123])

        change = calculator.object_history.changes[0]
        expect(change.property).to eq(:display)
        expect(change.name).to eq(:set)
        expect(change.args).to eq([123])
      end

      describe "in another timeline" do
        it "doesn't apply to the main timeline" do
          Timeline.new do
            alter(calculator).display = 123
          end
          expect(calculator.display).to eq(nil)
        end
      end
    end
  end

  describe "Calculator.new" do
    let :calculator do
      Calculator.new
    end

    it "creates a new Calculator with its own timeline?" do
      calculator = Calculator.new

      expect(calculator).to be_a(Calculator)
    end

    describe "enact(calculator).press_5" do
      it "works?" do
        enact(calculator).press_5
      end
    end

    describe "calculator.enact_press_5" do
      it "adds a directive for press_5" do
        press_5 = calculator.enact_press_5

        expect(press_5).to be_a(Directive)

        change = calculator.object_history.changes[0]
        expect(change.name).to eq(:press_5)
        expect(change.target).to eq(calculator)

        # change = Timeline.changes[0]
        # expect(change).to be_nil
      end
    end

    describe "calculator.alter_display_123" do
      it "adds a delta for display = 123" do
        calculator.alter_display_123

        expect(calculator.display).to eq(123)

        change = calculator.object_history.changes[0]
        expect(change.property).to eq(:display)
        expect(change.name).to eq(:set)
        expect(change.args).to eq([123])

        # change = Timeline.changes[0]
        # expect(change).to be_nil
      end

      describe "in another timeline" do
        it "adds a delta for display = 123" do
          calculator.alter_display_123

          expect(calculator.display).to eq(123)

          change = calculator.object_history.changes[0]
          expect(change.property).to eq(:display)
          expect(change.name).to eq(:set)
          expect(change.args).to eq([123])
        end
      end
    end
  end

  describe "timeline branching" do
    subject do
      Calculator.new
    end

    it "builds upon parent timeline" do
      alter(subject).display = ""
      alter(subject).display + "1"

      Timeline.branch do
        alter(subject).display + "2"

        expect(subject.display).to eq("12")
      end
    end
  end

  describe "timeline merging" do
    subject do
      enact(Calculator).new
    end

    it "combines changes" do
      puts "get subject"
      s = subject
      puts "subject:"
      p s
      alter(subject).display = ""
      alter(subject).display + "1"
      to_merge = Direction::Timeline.branch do
        alter(subject).display + "3"
      end
      alter(subject).display + "2"

      Direction::Timeline.merge to_merge

      p Direction::Timeline.current.changes

      expect(subject.display).to eq("123")
    end
  end

  describe "timeline rebasing" do
    subject do
      Calculator.new
    end

    it "combines changes" do
      alter(subject).display = ""
      alter(subject).display + "1"
      to_merge = Timeline.branch do
        alter(subject).display + "2"
      end
      alter(subject).display + "3"

      Timeline.rebase to_merge

      # p Timeline.changes.map(&:value)

      expect(subject.display).to eq("123")
    end
  end
end
