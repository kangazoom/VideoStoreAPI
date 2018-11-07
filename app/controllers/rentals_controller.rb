require 'pry'
class RentalsController < ApplicationController

  def index
    rentals = Rental.all
    render json: rentals.as_json(only: [:id, :customer_id, :movie_id]), status: :ok
  end

  def checkout

    # check_out = Date.today.to_s
    # due_date = (Date.today+7).to_s
    #
    # movie_id = params[:movie_id].to_i
    # movie = Movie.find_by(id: movie_id)
    movie = Movie.find_by(id: rental_params[:movie_id])
    customer = Customer.find_by(id: rental_params[:customer_id])
    # customer_id = params[:customer_id].to_i
    # customer = Customer.find_by(id: customer_id)
    if movie == nil || customer == nil
      render json: {errors: "No movie checked out, missing movie or customer"}, status: :bad_request
    else
      if movie.available_inventory > 0
        rental = Rental.new(rental_params)
        if rental.save
          movie.calculate_available_inventory
          render json: rental.as_json(except: [:created_at, :updated_at]), status: :ok
        else
          render_error(:bad_request, rental.errors.messages)
        end
      else
        render json: {errors: "No available movies in inventory"}, status: :ok
      end
    end
  end

  def checkin
    movie = Movie.find_by(id: rental_params[:movie_id])
    customer = Customer.find_by(id: rental_params[:customer_id])
    if movie == nil || customer == nil
      render json: {errors: "Not checked in. Customer or Movie id is invalid"}, status: :not_found
    else
      rental = Rental.find_by(movie_id: movie.id, customer_id: rental_params[:customer_id], checkedout: true)
      if rental.update(checkedout: false)
        movie.calculate_available_inventory
        render json: rental.as_json(except: [:created_at, :updated_at]), status: :ok
      else
        render_error(:not_found, rental.errors.messages)
      end
    end
  end


  def rental_params
      {movie_id: params[:movie_id], customer_id: params[:customer_id], check_out: Date.today.to_s, due_date: (Date.today + 7).to_s}
  end
end
