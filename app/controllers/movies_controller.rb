class MoviesController < ApplicationController

  def index
    movies = Movie.all
    render json: movies.as_json(only: [:id, :title, :release_date]), status: :ok
  end

  def show
    movie_id = params[:id]
    movie = Movie.find_by(id: movie_id)

    # TODO: uncomment below once we know more about rentals
    # movie.available_inventory = movie.calculate_available_inventory

    if movie
      render json: movie.as_json(except: [:created_at, :updated_at]), status: :ok, status: :ok
    else
      render_error(:not_found, {movie_id: ["no such movie"]})
    end
  end

  def create
    movie = Movie.new(movie_params)

    if movie.save
      render json: { id: movie.id }
    else
      render_error(:bad_request, movie.errors.messages)
    end
  end

  private
  def movie_params
    params.require(:movie).permit(:id, :title, :overview, :release_date, :inventory)
  end

end
