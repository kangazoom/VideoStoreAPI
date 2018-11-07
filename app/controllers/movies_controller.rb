class MoviesController < ApplicationController

  def index
    movies = Movie.all
    render json: movies.as_json(only: [:id, :title, :release_date]), status: :ok
  end

  def show
    movie_id = params[:id]
    movie = Movie.find_by(id: movie_id)

    if movie
      # NOTE: might need to tweak the code a little to get it working
      movie.calculate_available_inventory

      render json: movie.as_json(except: [:created_at, :updated_at]), status: :ok
    else
      render_error(:not_found, {movie_id: ["no such movie"]})
    end
  end

  def create
    # TODO: validations for non-string entries
    # TODO: move params to private for now
    movie = Movie.new(title: params[:title], release_date: params[:release_date], overview: params[:overview], inventory: params[:inventory])

    # TODO: uncomment below once we know more about rentals
    # movie.available_inventory = movie.calculate_available_inventory

    if movie.save
      movie_id = movie.id
      render json: movie.as_json(only: :id), status: :ok
    else
      # QUESTION: is this ok as an error message?
      render_error(:bad_request, movie.errors.messages)
    end
  end

  private
  # def movie_params
  #   params.require(:movie).permit(:id, :title, :overview, :release_date, :inventory)
  # end

end
