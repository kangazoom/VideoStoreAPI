require "test_helper"

describe CustomersController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  describe "index" do
    it "succeeds for existing users" do
      get customers_path
      must_respond_with :success
    end

    it "succeeds when there are no customers" do
      Customer.all.each do |customer|
        customer.destroy
      end
      get customers_path
      must_respond_with :success
    end
  end
end
