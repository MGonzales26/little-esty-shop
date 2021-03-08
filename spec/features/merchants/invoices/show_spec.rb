require 'rails_helper' 

RSpec.describe "Merchant Invoice Show Page" do 
  before(:each) do 
    @merchant1 = create(:merchant)
    @cust1 = create(:customer)
    @invoice1 = create(:invoice, customer: @cust1)
    @item1 = create(:item, merchant: @merchant1)
    @item2 = create(:item, merchant: @merchant1)
    @invoice_item1 = create(:invoice_item, invoice: @invoice1, item: @item1, quantity: 2, unit_price: 3)
    @invoice_item2 = create(:invoice_item, invoice: @invoice1, item: @item2, quantity: 3, unit_price: 3)
  end

  describe "When I visit the merchant invoice show page do" do 
    it "it displays the invoice id, invoice status, invoice created at date formatted properly" do 
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

      expect(page).to have_content("#{@merchant1.name} - Invoice # #{@invoice1.id}")

      within "#invoice-info" do 
        expect(page).to have_content("Status: #{@invoice1.status}")
        expect(page).to have_content("Created At: #{@invoice1.created_at.strftime('%A, %B %d, %Y')}")
      end
    end

    it "it displays the customer info, first and last name" do 
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"
    
      within "#customer-info" do 
        expect(page).to have_content("First name: #{@cust1.first_name}")
        expect(page).to have_content("Last name: #{@cust1.last_name}")
      end
    end

    it "displays the invoice item info such as item name, quantity ordered, price of item, invoice item status" do
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

      within "#invoice_item-info-#{@invoice_item1.id}" do 
        expect(page).to have_content("Invoice item name: #{@item1.name}")
        expect(page).to have_content("Invoice item quantity: #{@invoice_item1.quantity}")
        expect(page).to have_content("Invoice item price: #{@invoice_item1.unit_price}")
        expect(page).to have_content("Invoice item status: #{@invoice_item1.status}")
      end

      within "#invoice_item-info-#{@invoice_item2.id}" do 
        expect(page).to have_content("Invoice item name: #{@item2.name}")
        expect(page).to have_content("Invoice item quantity: #{@invoice_item2.quantity}")
        expect(page).to have_content("Invoice item price: #{@invoice_item2.unit_price}")
        expect(page).to have_content("Invoice item status: #{@invoice_item2.status}")
      end
    end

    it "can change the invoice item status to a different status" do 
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

      within "#invoice_item-info-#{@invoice_item1.id}" do 
        expect(page).to have_content("Invoice item status: #{@invoice_item1.status}")

        expect(page).to have_select(:status, selected: "packaged")

        expect(page).to have_select(:status, :options => ["packaged", "pending", "shipped"])
        
        select("shipped", from: "status")
       
        click_on("Update Item Status")

        expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}")
     
        expect(page).to have_content("Invoice item status: packaged")
        
      end
    end

    it "displays the total revenue from all items on the invoice" do 
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

      within "#total-revenue" do 
        expect(page).to have_content("Total revenue from invoice: 15")
      end
    end

    it "shows the total revenue includes bulk discounts in the calculation" do
      merchant1 = create(:merchant)
      bulk_discount = create(:bulk_discount, quantity_threshold: 5, percentage_discount: 50, merchant: merchant1)
      cust1 = create(:customer)
      invoice1 = create(:invoice, customer: cust1)
      item1 = create(:item, merchant: merchant1, unit_price: 10)
      item2 = create(:item, merchant: merchant1, unit_price: 10)
      invoice_item1 = create(:invoice_item, invoice: invoice1, item: item1, quantity: 3, unit_price: 10)
      invoice_item2 = create(:invoice_item, invoice: invoice1, item: item2, quantity: 5, unit_price: 10)
      
      visit merchant_invoice_path(merchant1, invoice1)
      
      expect(page).to have_content(invoice1.discounted_revenue)
      save_and_open_page
    end
  
  end
end

