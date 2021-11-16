class BulkDiscountsController < ApplicationController
  before_action :current_merchant

  def index
  end

private
  def current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
