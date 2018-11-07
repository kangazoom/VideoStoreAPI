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
    end


    it "returns an error for invalid rental data" do
      expect {
      post checkout_path, params: { movie_id: nil, customer_id: Customer.first.id }
    }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "errors"

      must_respond_with :bad_request
    end
  end

  # describe "rentals check_in" do
  #   it "successfully changes checked_out status to false" do
  #     expect {
  #     post check_out_path, params: { movie_id: nil, customer_id: customers.first.id }
  #
  #     body = JSON.parse(response.body)
  #     expect(body).must_be_kind_of Hash
  #     expect(body).must_include "id"
  #
  #     rental = Rental.find(body["id"].to_i)
  #
  #     expect(rental.checkout_status).must_equal false
  #     must_respond_with :success
  #   end
  # end
end
