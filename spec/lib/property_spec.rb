require "spec_helper"

class MyClass
  prop_accessor :foo
end

describe "Property" do
  subject do
    MyClass.new
  end

  it "lets you set a value" do
    subject.foo = 5
    expect(subject.foo).to eq(5)
    expect(subject.property(:foo).deltas.size).to eq(1)
  end

  it "lets you use alter to set a value" do
    alter(subject).foo = 5
    expect(subject.foo).to eq(5)
    expect(subject.property(:foo).deltas.size).to eq(1)
  end

  it "lets you add to a value" do
    alter subject do |s|
      s.foo = 3
      s.foo + 5
    end
    expect(subject.foo).to eq(8)
    expect(subject.property(:foo).deltas.size).to eq(2)
  end

  it "recalculates its value" do
    alter subject do |s|
      s.foo = 3
      s.foo + 5
    end
    subject.property(:foo).deltas.first.args[0] = 1
    expect(subject.foo).to eq(6)
  end
end
