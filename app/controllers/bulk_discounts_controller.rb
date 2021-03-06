class BulkDiscountsController < ApplicationController
  before_action :set_merchant, only: [:index, :show, :new, :create]
  def index
    @merchant
    @bulk_discounts = BulkDiscount.where(merchant_id: @merchant.id)
  end

  def show
    @merchant
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant
  end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      flash[:notice] = "You have successfully created a new Bulk Discount"
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:notice] = "ERROR: Missing required information"
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:quantity_threshold, :percentage_discount)
  end

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end