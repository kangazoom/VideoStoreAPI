class MoviesController < ApplicationController

  def index
    movies = Movie.all
    render json: movies.as_json(only: [:id, :title, :release_date]), status: :ok
  end

  def show
    movie_id = params[:id]
    movie = Movie.find_by(id: movie_id)

    if movie
      avail = movie.calculate_available_inventory
      result = movie.save_available_inventory(avail)

      render json: movie.as_json(except: [:created_at, :updated_at]), status: :ok
    else
      render_error(:not_found, {movie_id: ["no such movie"]})
    end
  end

  def create
    # TODO: validations for non-string entries
    # TODO: move params to private for now

    # TODO: this is a band-aid... should find a better solution...
    # if params[:inventory].blank? || params[:inventory].nil?
    #   params[:inventory] = 0
    # end

    movie = Movie.new(title: params[:title], release_date: params[:release_date], overview: params[:overview], inventory: params[:inventory])

    # new movies have inventory and available_inventory of 0
    # avail = movie.calculate_available_inventory
    # result = movie.save_available_inventory(avail)

    result = movie.save
    if result
      movie_id = movie.id
      render json: movie.as_json(only: :id), status: :ok
    else
      render_error(:bad_request, movie.errors.messages)
    end
  end

  private
  # def movie_params
  #   params.require(:movie).permit(:id, :title, :overview, :release_date, :inventory)
  # end

end
