require "rails_helper"

RSpec.describe "Bulk Discount Show Page" do
  before (:each) do
    @merchant = create(:merchant)
    @bulk_discount = create(:bulk_discount, merchant: @merchant)
  end
  describe "As a merchant" do
    it "shows the bulk discount's quantity threshold and percentage discount" do
      visit merchant_bulk_discount_path(@merchant, @bulk_discount)

      expect(page).to have_content(@bulk_discount.quantity_threshold)
      expect(page).to have_content(@bulk_discount.percentage_discount)
    end
  end
end
