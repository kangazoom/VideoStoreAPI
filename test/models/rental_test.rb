require "test_helper"

describe Rental do
  let(:rental) {rentals(:rental1)}

  it "must be valid" do
    expect(rental.valid?).must_equal true
  end


  # -- custom model methods -- #
  describe 'checked_out?' do
    it 'correctly  returns whether rental is currently checked out' do
      rental.checkedout = true
      result = rental.checked_out?
      expect(result).must_equal true

      rental.checkedout = false
      result = rental.checked_out?
      expect(result).must_equal false
    end

  end
end
