require "spec_helper"

describe "Calculator Example" do
  class Calculator
    def press_5
    end

    def enact_press_5
      enact.press_5
    end
  end

  describe "enact(Calculator).new" do
    let :calculator do
      new.value
    end

    let :new do
      enact(Calculator).new
    end

    it "creates a new Calculator and adds its creation to the current timeline,\n
    making it available on this history" do
      expect(new).to be_a(Directive)
      expect(calculator).to be_a(Calculator)

      change = object_history.changes[0]
      expect(change.name).to eq(:new)
      expect(change.target).to eq(Calculator)
    end

    describe "enact(calculator).press_5" do
      it "adds a directive for press_5" do
        press_5 = enact(calculator).press_5

        expect(press_5).to be_a(Directive)

        change = object_history.changes[1]
        expect(change.name).to eq(:press_5)
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
      it "raises an exception because calculator is unknown to this timeline" do
        expect { enact(calculator).press_5 }.to raise_error(TimelineError)
      end
    end

    describe "calculator.enact_press_5" do
      it "adds a directive for press_5" do
        press_5 = calculator.enact_press_5

        expect(press_5).to be_a(Directive)

        change = calculator.object_history.changes[0]
        expect(change.name).to eq(:press_5)
        expect(change.target).to eq(calculator)
      end
    end
  end
end
