require 'rails_helper'

RSpec.describe 'Admin Invoices Show page' do
  describe 'When I visit the admin invoices (/admin/invoices)' do
      before (:each) do
        @invoice_1 = create(:invoice)
        @invoice_2 = create(:invoice)
        @invoice_3 = create(:invoice)
      end

    it 'When I click on the name of a invoice from the admin invoices index page' do
      visit "/admin/invoices"

      expect(page).to have_content("#{@invoice_1.id}")
      expect(page).to have_link("#{@invoice_1.id}")
      expect(page).to have_content("#{@invoice_2.id}")
      expect(page).to have_link("#{@invoice_2.id}")
      expect(page).to have_content("#{@invoice_3.id}")
      expect(page).to have_link("#{@invoice_3.id}")
    end

    it 'Then I am taken to that invoices admin show page (/admin/invoices/invoice_id)' do
      visit "/admin/invoices"

      expect(page).to have_link("#{@invoice_1.id}")
      click_link("#{@invoice_1.id}")
      expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
      expect(page).to have_content("#{@invoice_1.id}")
    end

    it 'displays customer first name and last name for that invoice' do

      customer = create(:customer, first_name: "Minnie")
      invoice = create(:invoice, customer_id: customer.id)

      visit "/admin/invoices/#{invoice.id}"

      within (".customer") do
        expect(page).to have_content(customer.first_name)
        expect(page).to have_content(customer.last_name)
      end
    end

    it 'I see all of the items on the invoice with their: name, quantity, price sold, invoice item status' do
      customer = create(:customer, first_name: "Minnie")
      invoice = create(:invoice, customer: customer)
      item_1 = create(:item, name: "Fancy Chair")
      item_2 = create(:item, name: "Mineral Water")
      invoice_item_1 = create(:invoice_item, invoice_id: invoice.id, item_id: item_1.id, quantity: 7, unit_price: 5)
      invoice_item_2 = create(:invoice_item, invoice_id: invoice.id, item_id: item_2.id, quantity: 9, unit_price: 5.49)

      visit "/admin/invoices/#{invoice.id}"

      expect(page).to have_content("Items on this Invoice:")
      within ("#item-#{item_1.id}") do
        expect(page).to have_content(item_1.name)
        expect(page).to have_content(invoice.find_invoice_item(item_1.id).quantity)
        expect(page).to have_content(invoice.find_invoice_item(item_1.id).unit_price)
        expect(page).to have_content(invoice.find_invoice_item(item_1.id).status)
      end
      within ("#item-#{item_2.id}") do
        expect(page).to have_content(item_2.name)
        expect(page).to have_content(invoice.find_invoice_item(item_2.id).quantity)
        expect(page).to have_content(invoice.find_invoice_item(item_2.id).unit_price)
        expect(page).to have_content(invoice.find_invoice_item(item_2.id).status)
      end
    end


    describe 'I see the invoice status is a select field with current status selected' do
      describe 'When I click this select field' do
        it 'I can select a new status for the Invoice' do
          invoice_1 = create(:invoice, status: 1)

          visit "/admin/invoices/#{invoice_1.id}"

          expect(page).to have_field("invoice[status]")

          within(".status-dropdown") do
            expect(page).to have_select("invoice[status]", selected: invoice_1.status)
          end

          page.select 'cancelled', from: 'invoice[status]'
        end

        it 'I see a button to Update Invoice Status, I click it, and I am taken back to the admin invoice show page' do
          invoice_1 = create(:invoice, status: 1)
          visit "/admin/invoices/#{invoice_1.id}"

          page.select 'cancelled', from: 'invoice[status]'
          click_on("Update Invoice Status")

          expect(current_path).to eq("/admin/invoices/#{invoice_1.id}")
        end

        it 'And I see that my Invoice status has now been updated' do
          invoice_1 = create(:invoice, status: 1)
          visit "/admin/invoices/#{invoice_1.id}"

          click_on("Update Invoice Status")

          expect(page).to have_content("Current Status: #{invoice_1.status}")
        end
      end
    end

    it 'I see the total revenue that will be generated from this invoice' do
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

      visit "/admin/invoices/#{invoice.id}"

      within (".total-revenue") do
        expect(page).to have_content("Total Revenue: #{invoice.total_revenue}")
      end
    end
  end

  describe "As an admin" do
    describe "When I visit an admin invoice show page" do
      it "shows the total revenue when there are no discounts" do
        merchant1 = create(:merchant)
        cust1 = create(:customer)
        invoice1 = create(:invoice)
        item1 = create(:item, merchant: merchant1, unit_price: 10)
        item2 = create(:item, merchant: merchant1, unit_price: 10)
        invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1, quantity: 3, unit_price: 10)
        invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2, quantity: 5, unit_price: 10)
        
        visit admin_invoice_path(invoice1)

        expect(page).to have_content("Total Revenue: 80")
      end
      
      it "shows the total revenue includes bulk discounts in the calculation" do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        bulk_discount = create(:bulk_discount, quantity_threshold: 5, percentage_discount: 50, merchant: merchant1)
        bulk_discount2 = create(:bulk_discount, quantity_threshold: 3, percentage_discount: 50, merchant: merchant2)
        cust1 = create(:customer)
        invoice1 = create(:invoice)
        item1 = create(:item, merchant: merchant1, unit_price: 10)
        item2 = create(:item, merchant: merchant1, unit_price: 10)
        invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1, quantity: 3, unit_price: 10)
        invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2, quantity: 5, unit_price: 10)
        
        visit admin_invoice_path(invoice1)
        
        expect(page).to have_content("Total Revenue: 55")
      end
    end
  end
end

