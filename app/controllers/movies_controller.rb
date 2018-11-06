class MoviesController < ApplicationController

  def index
    movies = Movie.all
    render json: jsonify(movies), status: :ok
  end

  def show
    movie_id = params[:id]
    movie = Movie.find_by(id: movie_id)

    if movie
      render json: jsonify(movie), status: :ok
    else

      #render json: { errors: { movie_id: ["No such movie"]}}, status: :not_found
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

  def jsonify(movie_data)
    return movie_data.as_json(except: [:created_at, :updated_at])
  end
end
