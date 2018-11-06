require "test_helper"

describe MoviesController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  describe "index" do
    it "succeeds for existing users" do
      get movies_path
      must_respond_with :success
    end

    it "succeeds when there are no movies" do
      Movie.all.each do |movie|
        movie.destroy
      end

      get movies_path
      must_respond_with :success
    end
  end
end
