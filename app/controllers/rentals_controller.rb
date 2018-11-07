require 'pry'
class RentalsController < ApplicationController

  def index
    rentals = Rental.all
    render json: rentals.as_json(only: [:id, :customer_id, :movie_id]), status: :ok
  end

  def checkout


    check_out = Date.today.to_s
    due_date = (Date.today+7).to_s

    movie_id = params[:movie_id].to_i
    movie = Movie.find_by(id: movie_id)
    customer_id = params[:customer_id].to_i
    customer = Customer.find_by(id: customer_id)
    # rental = Rental.new(rental_params)

    rental = Rental.new(movie_id: movie.id, customer_id: customer.id, check_out: check_out, due_date: due_date)


    if rental.save
      render json: rental.as_json(except: [:created_at, :updated_at]), status: :ok
      # render json: { customer_id: rental.customer_id, movie_id: rental.movie_id }
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
