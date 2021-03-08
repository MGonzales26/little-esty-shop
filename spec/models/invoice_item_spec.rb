require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
  end

  describe "Instance Methods" do
    describe "#discount_price" do
      it "updates the price of the item if a discount is available" do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        bulk_discount = create(:bulk_discount, quantity_threshold: 5, percentage_discount: 50, merchant: merchant1)
        bulk_discount2 = create(:bulk_discount, quantity_threshold: 3, percentage_discount: 50, merchant: merchant2)
        cust1 = create(:customer)
        invoice1 = create(:invoice, customer: cust1)
        item1 = create(:item, merchant: merchant1, unit_price: 10)
        item2 = create(:item, merchant: merchant1, unit_price: 10)
        invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1, quantity: 3, unit_price: 10)
        invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2, quantity: 5, unit_price: 10)
    
        invoice_item2.discount_price

        expect(invoice_item2.unit_price).to eq(5)
      end

      it "doesn't update the price of the item if a discount is not available" do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        bulk_discount = create(:bulk_discount, quantity_threshold: 5, percentage_discount: 50, merchant: merchant1)
        bulk_discount2 = create(:bulk_discount, quantity_threshold: 3, percentage_discount: 50, merchant: merchant2)
        cust1 = create(:customer)
        invoice1 = create(:invoice, customer: cust1)
        item1 = create(:item, merchant: merchant1, unit_price: 10)
        item2 = create(:item, merchant: merchant1, unit_price: 10)
        invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1, quantity: 3, unit_price: 10)
        invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2, quantity: 5, unit_price: 10)
    
        invoice_item1.discount_price

        expect(invoice_item1.unit_price).to eq(10)
      end
    end
  end

  describe "Helper Methods" do
    describe "#find_discount" do
      it "finds a bulk discount if one is available" do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        bulk_discount = create(:bulk_discount, quantity_threshold: 5, percentage_discount: 50, merchant: merchant1)
        bulk_discount2 = create(:bulk_discount, quantity_threshold: 3, percentage_discount: 50, merchant: merchant2)
        cust1 = create(:customer)
        invoice1 = create(:invoice, customer: cust1)
        item1 = create(:item, merchant: merchant1, unit_price: 10)
        item2 = create(:item, merchant: merchant1, unit_price: 10)
        invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1, quantity: 3, unit_price: 10)
        invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2, quantity: 5, unit_price: 10)

        expect(invoice_item2.available_discounts).to eq(bulk_discount)
        expect(invoice_item1.available_discounts).to eq(nil)
      end

      it "finds the best bulk discount more than one is available" do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        bulk_discount = create(:bulk_discount, quantity_threshold: 5, percentage_discount: 50, merchant: merchant1)
        bulk_discount2 = create(:bulk_discount, quantity_threshold: 3, percentage_discount: 35, merchant: merchant1)
        cust1 = create(:customer)
        invoice1 = create(:invoice, customer: cust1)
        item1 = create(:item, merchant: merchant1, unit_price: 10)
        item2 = create(:item, merchant: merchant1, unit_price: 10)
        invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1, quantity: 3, unit_price: 10)
        invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2, quantity: 5, unit_price: 10)

        expect(invoice_item2.available_discounts).to eq(bulk_discount)
      end

      it "finds the best bulk discount by ammount of discount if more than one of the same quantity is available" do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        bulk_discount = create(:bulk_discount, quantity_threshold: 5, percentage_discount: 50, merchant: merchant1)
        bulk_discount2 = create(:bulk_discount, quantity_threshold: 5, percentage_discount: 60, merchant: merchant1)
        cust1 = create(:customer)
        invoice1 = create(:invoice, customer: cust1)
        item1 = create(:item, merchant: merchant1, unit_price: 10)
        item2 = create(:item, merchant: merchant1, unit_price: 10)
        invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1, quantity: 3, unit_price: 10)
        invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2, quantity: 5, unit_price: 10)

        expect(invoice_item2.available_discounts).to eq(bulk_discount2)
      end
    end
  end
end
