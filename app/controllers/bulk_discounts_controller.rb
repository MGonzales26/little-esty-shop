class BulkDiscountsController < ApplicationController
  before_action :set_merchant, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :set_bulk_discount, only: [:show, :edit, :update]

  def index
    @merchant
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant
    @bulk_discount
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

  def edit
    @merchant
    @bulk_discount
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
      flash[:notice] = "Your discount has been successfully updated"
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      flash[:notice] = "ERROR: Missing required information"
      redirect_to edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:quantity_threshold, :percentage_discount)
  end

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def set_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end