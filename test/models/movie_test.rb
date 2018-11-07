require "test_helper"

describe Movie do
  let(:movie) (movies(:movie1)) #TODO: need to set up yaml

  describe "relations" do
    it "has a list of rentals" do
      movie.must_respond_to :rentals
      movie.rentals.each do |rental|
        rental.must_be_kind_of Rental
      end
    end

    it "has a list of renting customers" do
      movie.must_respond_to :customers
      movie.customers.each do |customer|
        customer.must_be_kind_of Customer
      end
    end
  end

  describe "validations" do
    it "requires a title" do
      movie.valid?.must_equal true

      movie.title = nil
      movie.valid?.must_equal false
      movie.errors.messages.must_include :title
    end

    it "requires unique titles within release dates" do
      category = 'album'
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

      movie2 = Movie.new(title: title, release_date: 1977-11-08)
      movie2.save
      movie2.valid?.must_equal true
    end
  end

  # -- custom model methods -- #

  describe 'calculate_available_inventory' do

    it 'correctly calculates available inventory when value is positive' do
      total_inventory = movie.inventory
      rented_inventory = movie.rentals.length

      available_inventory = movie.calculate_available_inventory

      expect(available_inventory).must_equal 2
    end

    it 'correctly calculates available inventory when value is zero' do
      rented_inventory = movie.rentals.length
      movie.inventory = rented_inventory

      available_inventory = movie.calculate_available_inventory

      expect(available_inventory).must_equal 0
    end

    it 'correctly calculates available inventory when total inventory is zero' do
      movie.inventory = 0

      available_inventory = movie.calculate_available_inventory

      expect(available_inventory).must_equal 0
    end

    # it 'correctly calculates available inventory when rented inventory is zero' do
    #   total_inventory = movie.inventory
    #   rented_inventory = 0
    #
    #   available_inventory = total_inventory - rented_inventory
    #
    #   expect(available_inventory).must_equal total_inventory
    # end

    # QUESION: improve error handling here?
    it 'throws an error if available_inventory falls below zero' do
      movie.inventory = -100

      available_inventory = movie.calculate_available_inventory

      expect { available_inventory }.must_raise StandardError
    end

    describe 'save_available_inventory' do
    # QUESION: improve error handling here?
    it 'can successfully save newly-assigned inventory value' do
      result = movie.save_available_inventory(0)
      expect(result).must_equal true

      result = movie.save_available_inventory(10)
      expect(result).must_equal true
    end

    it 'throws an error if save is unsuccessful' do
      result = movie.save_available_inventory('a')
      expect { result }.must_raise StandardError

      result = movie.save_available_inventory(-1)
      expect { result }.must_raise StandardError
    end


  end
end
