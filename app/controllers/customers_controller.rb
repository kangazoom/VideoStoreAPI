class CustomersController < ApplicationController

  def index
    customer = Customer.all
    render json: jsonify(customer)
  end

  private

  def jsonify(customer_data)
    return customer_data.as_json( only: [:id, :name, :registered_at, :address, :city, :state, :postal_code, :phone, :movies_checked_out_count])
  end
end
