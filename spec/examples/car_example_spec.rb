require "spec_helper"

describe "Car Example" do
  class Car
    property :gas, :door_open

    directive :open_door => :opened_door do
      alter.door_open = true
    end
  end

  class GasStation
    directive :fill_tank => :filled_tank do |car|
      alter(car).gas = 10
    end
  end

  describe "#open_door" do
    context "as a method call" do
      it "adds an open_door directive to car's history" do
        car.open_door
        car.history.last.is_a? Directive
        car.history.last.name == :open_door
      end
    end

    context "using #enact" do
      it "returns open_door as a directive that has already been resolved" do
        enact(car).open_door
      end
    end
  end

  describe "replacing car's history" do
    it "allows you to replay the car's state from scratch" do
      car.history = History.new
    end
  end

  describe "undoing #open_door" do
    it "removes the open_door directive from car's history" do
      car.open_door
      car.history.delete car.history.last
      expect(car.door_open).to eq(false)
    end
  end

  describe "#fill_tank" do
    context "with the default shared root history" do
      it "understands the connection between #fill_tank and gas = 10" do
        filled_tank = enact(gas_station).fill_tank car
        expect(car.gas).to eq(10)
        filled_tank.undo
        expect(car.gas).to eq(0)
      end
    end

    context "with separate histories" do
      let :car do
        within_new_history do
          Car.new
        end
      end

      let :gas_station do
        within_new_history do
          GasStation.new
        end
      end

      it "can't alter car" do
        enact(gas_station).fill_tank car # raises a HistoryError
        # GasStation#filled_tank basically looks like:
        #
        # delta! :filled_tank do |car|
        #   alter(car).gas = 10
        # end
        #
        # or:
        #
        # delta! :filled_tank do |car|
        #   history.add_delta history.find_id(car), :gas=, 10
        # end
        #
        # So, because the expectation of alter(car).gas = 10 is that the event
        # will be stored on gas_station's history, and it needs to know car's
        # history's id in order to store it, the fact that car isn't known in
        # gas_station's history nor a shared parent history, the delta can't be
        # stored.
        #
        # You can, however, store the alteration on the car's history. However,
        # this doesn't link the histories, so undoing filled_tank will not undo
        # gas = 10.
        #
        # delta! :filled_tank do |car|
        #   car.alter.gas = 10
        # end
      end
    end
  end
end
