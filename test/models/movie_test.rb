require "test_helper"

describe Movie do
  let(:movie) {movies(:movie1)}

  describe "relations" do
    it "has a list of rentals" do
      movie.must_respond_to :rentals
      movie.rentals.each do |rental|
        rental.must_be_kind_of Rental
      end
    end
  end

  describe "validations" do
    it "requires a title" do
      # movie.valid?.must_equal true

      movie.title = nil
      movie.valid?.must_equal false
      movie.errors.messages.must_include :title
    end

    it "requires unique titles within release dates" do
      movie.valid?.must_equal true

      title = movie.title
      release_date = movie.release_date

      movie2 = Movie.new(title: title, release_date: release_date)
      movie2.save

      movie2.valid?.must_equal false
      movie2.errors.messages.must_include :title
    end

    it "does not require a unique title if the release date is different" do
      title = movie.title

      movie2 = Movie.new(title: title, release_date: '1977-11-08')
      movie2.save
      movie2.valid?.must_equal true
    end

    it 'approves a non-negative inventory int value' do
      movie.inventory = 1
      movie.valid?.must_equal true

      movie.inventory = 0
      movie.valid?.must_equal true
    end

    it "requires an inventory" do
      movie.inventory = nil
      movie.valid?.must_equal false
      movie.errors.messages.must_include :inventory
    end

    it "requires an inventory" do
      movie.release_date = nil
      movie.valid?.must_equal false
      movie.errors.messages.must_include :release_date
    end

    it 'will not save a non-negative inventory int value' do

      movie.inventory = -1
      movie.valid?.must_equal false

      movie.inventory = 1.5
      movie.valid?.must_equal false

      movie.inventory = 'a'
      movie.valid?.must_equal false
    end

    it 'approves a non-negative available_inventory int value' do
      movie.available_inventory = 1
      movie.valid?.must_equal true

      movie.available_inventory = 0
      movie.valid?.must_equal true

    end


    it 'requires a non-negative available_inventory int value' do


      movie.available_inventory = -1
      movie.valid?.must_equal false

      movie.available_inventory = 1.5
      movie.valid?.must_equal false

      movie.available_inventory = 'a'
      movie.valid?.must_equal false
    end
  end

  # -- custom model methods -- #
  describe 'calculate_checked_out_rentals' do
    let(:rental_checked_out) {Rental.new({
      checkedout: true,
      movie: movie,
      customer: customers(:customer1)
    }
  )
}

it 'correctly calculates checked out rentals' do
  rented_inventory = movie.rentals.count { |rental| rental.checked_out? }

  calculation = movie.calculate_checked_out_rentals

  expect(calculation).must_equal rented_inventory
end

it 'ignores checked in rental entries' do
  rental_checked_in = Rental.new({
    checkedout: false,
    movie: movie,
    customer: customers(:customer2)
  }
)

  all_rentals = movie.rentals.length
  checked_in_rentals = movie.rentals.count { |rental| !rental.checked_out? }
  checked_out_rentals = all_rentals - checked_in_rentals

  calculation = movie.calculate_checked_out_rentals

  expect(calculation).must_equal checked_out_rentals

  end
end

describe 'calculate_available_inventory' do

  it 'correctly calculates available inventory with valid value' do
    total_inventory = movie.inventory
    rented_inventory = movie.calculate_checked_out_rentals()

    available_inventory = total_inventory - rented_inventory

    calculation = movie.calculate_available_inventory

    expect(calculation).must_equal available_inventory
  end
#
  it 'correctly calculates available inventory when value is zero' do
    rented_inventory = movie.calculate_checked_out_rentals()

    movie.inventory = rented_inventory
    total_inventory = movie.inventory

    available_inventory = total_inventory - rented_inventory

    calculation = movie.calculate_available_inventory

    expect(calculation).must_equal 0
    expect(calculation).must_equal available_inventory
  end

  # QUESION: improve error handling here?
  it 'throws an error if available_inventory falls below zero' do
    movie.inventory = 0
    calculation = movie.calculate_available_inventory

    expect(calculation).must_equal 0
  end
end

  describe 'save_available_inventory' do
  it 'can successfully save newly-assigned inventory value' do
    result = movie.save_available_inventory(0)
    expect(result).must_equal true

    result = movie.save_available_inventory(10)
    expect(result).must_equal true
  end

  it 'throws an error if save is unsuccessful' do
    expect { movie.save_available_inventory(-1) }.must_raise StandardError
  end


end
end
