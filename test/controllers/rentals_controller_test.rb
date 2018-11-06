require "test_helper"

describe RentalsController do
  let(:rental_data) {
      {
        check_in: 2018-11-10,
        check_out: 2018-11-17,
        movie_id: 7,
        customer_id: 1
      }
    }

  describe "rentals checkout" do
    it "must successfully add a new rental when given valid data" do
      expect {
        post rentals_path, params: { rental: rental_data }
      }.must_change "Rental.count", 1

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "id"

      rental = Rental.find(body["id"].to_i)

      expect(rental.movie_id).must_equal rental_data[:movie_id]
      expect(rental.check_out).must_equal Today
      must_respond_with :success
    end

    it "returns an error for invalid rental data" do
      rental_data["movie_id"] = nil

      expect {
      post rentals_path, params: { rental: rental_data }
    }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body).must_be_kind_of Hash
      expect(body).must_include "errors"
      expect(body["errors"]).must_include "movie_id"
      must_respond_with :bad_request
    end
  end

  describe "rentals check_in" do
    it "successfully changes checked_out status to false" do
      expect {
        patch rental_path(rentals.first)
    }.wont_change "Rental.count", 1

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "id"

      rental = Rental.find(body["id"].to_i)

      expect(rental.checkout_status).must_equal false
      must_respond_with :success
    end
  end
end
