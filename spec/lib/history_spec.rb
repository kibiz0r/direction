require "spec_helper"

# History is the fundamental interface to the state of an object.
#
# History:
# - id
# - type (theoretically a language-agnostic identifier, but really :foo => Foo)
# - hash of ids to histories, directives, and deltas
# - changes (a list of directives and deltas, as ids, hung off of history just
#   like it was a directive)
#
# When a History is created, it creates an entry in the active History, or a
# manually-specified parent History.
#
# Directive:
# - cause (another directive, as an id)
# - history (the target of the directive, as an id)
# - name
# - args
# - state (proposed, enacted, or failed)
# - effects (other directives and deltas, as ids)
# - return_value
# - error_thrown
#
# Delta:
# - cause (a directive or delta, as an id)
# - history (the target of the delta, as an id)
# - name
# - args
# - state?
# - effects (other deltas, as ids)
# - return_value
# - error_thrown
#
#
# ----
#
# This may or may not be true:
#
# This may sound weird, but Histories are actually always present, and you are
# always operating within an active History. You can think of them as similar
# to a call stack frame.
#
# Histories can be freely assigned to the #history property of an object.
# Histories are really value objects, that consist of a list of changes, and a
# specific index within that list where the changes have actually been applied.
#
# Because of this, almost every method takes an object as its argument, 
describe History do
  context "Car History Example" do
    let :gas_station_history do
      History.new
    end

    let :car_history do
      History.new
    end

    before do
      car_history.add_directive :open_door
      gas_station_history.add_directive :
    end

    it "returns an array of changes" do
    end
  end
end
