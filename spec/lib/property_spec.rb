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
    expect(subject.deltas).to eq([Delta.new(:prop_altered, :foo, :set, 5)])
  end

  it "lets you use alter to set a value" do
    alter(subject).foo = 5
    expect(subject.foo).to eq(5)
    expect(subject.deltas).to eq([Delta.new(:prop_altered, :foo, :set, 5)])
  end

  it "lets you add to a value" do
    alter subject do |s|
      s.foo = 3
      s.foo + 5
    end
    expect(subject.foo).to eq(8)
    expect(subject.deltas).to eq [
      Delta.new(:prop_altered, :foo, :set, 3),
      Delta.new(:prop_altered, :foo, :+, 5)
    ]
  end

  it "recalculates its value" do
    alter subject do |s|
      s.foo = 3
      s.foo + 5
    end
    subject.deltas.first.args[2] = 1
    expect(subject.foo).to eq(6)
  end
end
