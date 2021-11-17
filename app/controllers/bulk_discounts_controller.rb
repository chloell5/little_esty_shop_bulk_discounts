class BulkDiscountsController < ApplicationController
  before_action :current_merchant

  def index
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])

    if discount.update(discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, discount)
    else
      redirect_to edit_merchant_bulk_discount_path(@merchant, discount)
      flash[:alert] = "Error: Fill in all forms with numbers"
    end
  end

  def new
    @discount = BulkDiscount.new
  end

  def create
    discount = @merchant.bulk_discounts.create(discount_params)

    if discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      redirect_to new_merchant_bulk_discount_path(@merchant)
      flash[:alert] = "Error: Fill in all forms with numbers"
    end
  end

private
  def current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end
end
