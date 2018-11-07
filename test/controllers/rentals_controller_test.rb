require "test_helper"
require 'pry'

describe RentalsController do
  describe "rentals checkout" do
    let(:rental_data) {
          {
            movie_id: Movie.first.id,
            customer_id: Customer.first.id,
          }
        }
    it "must successfully add a new rental when given valid data" do
      post checkout_path, params: rental_data
      expect(Rental.count).must_equal 3
      must_respond_with :success
      expect(Movie.first.available_inventory).must_equal 0
      expect(Rental.last.checkedout).must_equal true
    end


    it "returns an error for invalid rental data" do
      expect{
      post checkout_path, params: { movie_id: nil, customer_id: Customer.first.id }
    }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "errors"

      must_respond_with :bad_request
    end

    it "returns an unavailable error message if available inventory is 0" do
      movie = Movie.first
      movie.update(available_inventory: 0)
      expect{
      post checkout_path, params: { movie_id: Movie.first.id, customer_id: Customer.first.id }
    }.wont_change "Rental.count"
    body = JSON.parse(response.body)

    expect(body).must_be_kind_of Hash
    expect(body).must_include "errors"

    must_respond_with :success

    end
  end

  describe "rentals check_in" do
    let(:rental_data) {
          {
            movie_id: Movie.first.id,
            customer_id: Customer.first.id,
          }
        }
    it "successfully changes checked_out status to false" do
      post checkout_path, params: rental_data
      expect {
      post checkin_path, params: rental_data }.wont_change "Rental.count"

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "id"
      expect(Rental.last.checkedout).must_equal false
      must_respond_with :success
    end

    it "successfully adds movie back to available inventory" do
      post checkout_path, params: rental_data
      expect{post checkin_path, params: rental_data}.must_change "Movie.first.available_inventory", 1
    end

    it "returns not found if trying to check in a movie without a valid customer or movie id" do

      post checkin_path, params: { movie_id: nil, customer_id: Customer.first.id }
      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "errors"
    end
  end
end
