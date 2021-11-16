class BulkDiscountsController < ApplicationController
  before_action :current_merchant

  def index
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

private
  def current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
