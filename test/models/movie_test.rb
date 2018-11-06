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
end
