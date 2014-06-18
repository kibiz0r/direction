require "spec_helper"

class Product
  prop_accessor :stock, :name
end

class Store
  directive :buy do |product, quantity|
    enact(product).stock.subtract quantity
    # NOTE: This is different from:
    #   product.stock = product.stock - quantity
    #
    # By using .subtract, if the initial snapshot changes, we won't just
    # overwrite the stock, we'll actually reduce it by quantity.
  end

  directive :rename do |product, name|
    product.name = name
  end
end

describe "directive" do
  subject do
    Store.new
  end

  let :product do
    Product.new.tap do |product|
      product.stock = 5
      product.name = "Flip-Flops"
    end
  end

  it "does stuff" do
    expect(product.snapshot).to eq(Snapshot.new(stock: 5, name: "Flip-Flops"))

    materialize = enact(subject)
    expect(materialize).to be_an_instance_of(Directive)
    expect(materialize.name).to eq(:materialize)

    buy = enact(subject).buy product, 1
    expect(product.stock).to eq(4)
    expect(product.deltas).to eq([Delta.new(:stock, :subtract, 1)])

    buy.undo
    expect(product.stock).to eq(5)
    
    enact(subject).rename product, "Cool Flip-Flops"
    expect(product.deltas).to eq([Delta.new(:name, :set, "Cool Flip-Flops")])
  end
end
