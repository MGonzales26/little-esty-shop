require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :quantity_threshold }
    it { should validate_presence_of :percentage_discount }
  end

  describe "Instance Methods" do
    describe "#price_after_discounts" do
      it "reduces the current price of an item by the percentage discount ammout of the bulk discount" do
        bulk_discount = create(:bulk_discount, percentage_discount: 50)
        price = 100
        expect(bulk_discount.price_after_discounts(price)).to eq(50)
      end
    end
  end
end
