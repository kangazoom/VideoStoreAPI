require "test_helper"

describe Rental do
  let(:rental) {rentals(:rental1)}

  it "must be valid" do
    expect(rental.valid?).must_equal true
  end
end

# -- custom model methods -- #
describe 'checked_out?' do
  it 'correctly  returns whether rental is currently checked out' do
    rental.checkout = true
    rental.verify?.must_equal true

    rental.checkout = false
    rental.verify?.must_equal false
  end

end
