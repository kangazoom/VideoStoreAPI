require "test_helper"

describe Rental do
  let(:rental) {Movie.first}

  it "must be valid" do
    expect(rental.valid?).must_equal true
  end
end
