require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items ).through(:invoice_items)}
  end


  describe "Instance methods" do
    describe "#format_day" do
      it "takes an invoice and formats the day to present cleanly" do
        customer = create(:customer)
        invoice = create(:invoice, customer: customer)

        expect(invoice.format_day).to eq(invoice.created_at.strftime("%A %B %d, %Y"))
      end
    end
  end
  
  describe 'class methods' do
    describe '::incomplete' do
      it 'displays invoices with status of cancelled or in progress' do
        invoice_1 = create(:invoice, status: 0)
        invoice_2 = create(:invoice, status: 0)
        invoice_3 = create(:invoice, status: 2)
        invoice_4 = create(:invoice, status: 1)
        invoice_5 = create(:invoice, status: 1)
        invoice_6 = create(:invoice, status: 1)
        invoice_7 = create(:invoice, status: 2)

        expect((Invoice.incomplete).count).to eq(4)
      end
    end

    describe '::oldest_to_newest' do
      it 'sorts incomplete invoices from oldest to newest by create date' do
        invoice_1 = create(:invoice, status: 0, created_at: Time.parse("2015-10-31"))
        invoice_2 = create(:invoice, status: 0, created_at: Time.parse("2010-09-20"))
        invoice_3 = create(:invoice, status: 2, created_at: Time.parse("2019-03-25"))
        invoice_7 = create(:invoice, status: 2, created_at: Time.parse("2000-11-18"))

        expect(Invoice.oldest_to_newest.first).to eq(invoice_7)
        expect(Invoice.oldest_to_newest.last).to eq(invoice_3)
      end
    end
  end

  describe 'instance methods' do
    describe '#date_created' do
      it "formats created_at value to 'Monday, July 18, 2019'" do
        invoice_1 = create(:invoice, status: 0)
        invoice_2 = create(:invoice, status: 0)
        invoice_3 = create(:invoice, status: 2)
        invoice_7 = create(:invoice, status: 2)

        expect(invoice_1.date_created).to eq(invoice_1.created_at.strftime("%A, %B %e, %Y"))
      end
    end

    describe '#find_invoice_item' do
      it 'finds the invoice item given an item id' do
        customer = create(:customer, first_name: "Minnie")
        invoice = create(:invoice, customer: customer)
        item_1 = create(:item, name: "Fancy Chair")
        invoice_item_1 = create(:invoice_item, id: 100, invoice_id: invoice.id, item_id: item_1.id, quantity: 7, unit_price: 5)

        expect(invoice.find_invoice_item(item_1.id).id).to eq(invoice_item_1.id)
        expect(invoice.find_invoice_item(item_1.id).class).to eq(InvoiceItem)
        expect(invoice.find_invoice_item(item_1.id).quantity).to eq(invoice_item_1.quantity)
        expect(invoice.find_invoice_item(item_1.id).unit_price).to eq(invoice_item_1.unit_price)
        expect(invoice.find_invoice_item(item_1.id).status).to eq(invoice_item_1.status)
      end
    end

    describe '#total_revenue' do
      it 'finds the revenue for all invoice items in a single invoice' do
        customer = create(:customer, first_name: "Minnie")
        invoice = create(:invoice, customer: customer)

        item_1 = create(:item, name: "Fancy Chair")
        item_2 = create(:item, name: "Mineral Water")
        item_3 = create(:item, name: "Gold")
        item_4 = create(:item, name: "Mint Soap")
        item_5 = create(:item, name: "Mineral Water")

        invoice_item_1 = create(:invoice_item, invoice_id: invoice.id, item_id: item_1.id, quantity: 10, unit_price: 30)
        invoice_item_2 = create(:invoice_item, invoice_id: invoice.id, item_id: item_2.id, quantity: 5, unit_price: 50)
        invoice_item_3 = create(:invoice_item, invoice_id: invoice.id, item_id: item_3.id, quantity: 15, unit_price: 60)
        invoice_item_4 = create(:invoice_item, invoice_id: invoice.id, item_id: item_4.id, quantity: 8, unit_price: 70)
        invoice_item_5 = create(:invoice_item, invoice_id: invoice.id, item_id: item_5.id, quantity: 20, unit_price: 72)

        expect(invoice.total_revenue). to eq(3450)

      end
    end
  end
end
