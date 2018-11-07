require 'pry'
class RentalsController < ApplicationController

  def index
    rentals = Rental.all
    render json: rentals.as_json(only: [:id, :customer_id, :movie_id]), status: :ok
  end

  def checkout
    rental = Rental.new(rental_params)
    if rental.save
      render json: { customer_id: rental.customer_id, movie_id: rental.movie_id }
      # decrement movie available inventory here
    else
      render_error(:bad_request, rental.errors.messages)
    end
  end

  def checkin

  end


  def rental_params
      {movie_id: params[:movie_id], customer_id: params[:customer_id], check_out: Date.today, due_date: Date.today + 7}
  end
end
