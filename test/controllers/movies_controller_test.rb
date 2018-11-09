require "test_helper"

describe MoviesController do
  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header['Content-Type']).must_include 'json'

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end

  describe "index" do
    MOVIE_FIELDS_INDEX = %w(id title release_date).sort

    it "successfully returns a list of existing movies" do
      get movies_path

      body = check_response(expected_type: Array)

      expect(body.length).must_equal Movie.count

      body.each do |movie|
        expect(movie.keys.sort).must_equal MOVIE_FIELDS_INDEX
      end
    end

    it "returns an empty array when there are no movies" do
      Movie.destroy_all
      get movies_path
      body = check_response(expected_type: Array)
      expect(body).must_equal []
    end
  end

  describe 'show' do
        MOVIE_FIELDS_SHOW = %w(id title overview release_date inventory available_inventory).sort
    it 'retrieves info on one movie' do
      movie = Movie.first
      get movie_path(movie)

      body = check_response(expected_type: Hash)
      expect(body.keys.sort).must_equal MOVIE_FIELDS_SHOW
    end

    it 'returns a 404 error if requesting a movie that does not exist' do
      movie = Movie.first
      movie.destroy

      get movie_path(movie)
      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body).must_include 'errors'
    end
  end

  describe "create" do
    let(:movie_data) {
          {
            title: 'good new movie',
            inventory: 3
          }
        }

    it "creates a movie with valid data" do
      # new_movie_params = {
      #   title: 'good new movie',
      #   release_date: '1978-01-2'
      # }

      before_count = Movie.count


      post movies_path, params: movie_data
      must_respond_with :success
      expect(Movie.count).must_equal (before_count+1)

      expect(Movie.last.title).must_equal 'good new movie'


      # new_movie_params = new_movie_params.to_json

      # expect {
      #   post movies_path, params: new_movie_params
      # }.must_change 'Movie.count', 1
      #
      # new_movie = Movie.find_by(title: 'good new movie')
      #
      # # get movie_path(movie)
      # body = check_response(expected_type: Hash, expected_status: :ok)
      # expect(body).must_include 'errors'
    end
    # #
    # it "renders bad_request and does not update the DB for bogus data" do
    #   new_work_params[:work][:title] = nil
    #
    #   expect {
    #     post works_path, params: new_work_params
    #   }.wont_change 'Work.count'
    #
    #   expect(flash[:status]).must_equal :failure
    #
    #   must_respond_with :bad_request
    # end
    #
    # it "renders 400 bad_request for bogus categories" do
    #   INVALID_CATEGORIES.each do |category|
    #     new_work_params[:work][:category] = category
    #
    #     expect {
    #       post works_path, params: new_work_params
    #     }.wont_change 'Work.count'
    #
    #     expect(flash[:status]).must_equal :failure
    #
    #     must_respond_with :bad_request
    #   end
    # end

  end
end
