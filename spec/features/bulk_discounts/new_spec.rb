require 'rails_helper'

RSpec.describe "Bulk Discount New Page" do
  before (:each) do
    @merchant = create(:merchant)

    json_response = File.read('spec/fixtures/holidays.json')
      stub_request(:get, "https://date.nager.at/Api/v2/NextPublicHolidays/us").
        to_return(status: 200, body: json_response)
  end
  describe "As a merchant" do
    describe "When I visit the my Bulk Discount index page" do
      it "has a link to create a new Bulk Discount" do
        visit merchant_bulk_discounts_path(@merchant)
        
        expect(page).to have_link("Create New Bulk Discount")
      end
    end
    
    describe "When I click the New Bulk Discount link" do
      it "takes me to a new page with a form to add a new bulk discount" do
        visit merchant_bulk_discounts_path(@merchant)

        click_on("Create New Bulk Discount")
        expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))

        expect(page).to have_field('bulk_discount[quantity_threshold]')
        expect(page).to have_field('bulk_discount[percentage_discount]')
        expect(page).to have_button("Create Bulk discount")
      end
      
      describe "When I fill in the form click the create discount button" do
        it "takes me back to the index page listing the new discount" do
          visit new_merchant_bulk_discount_path(@merchant)

          fill_in 'bulk_discount[quantity_threshold]', with: 10
          fill_in 'bulk_discount[percentage_discount]', with: 20
          click_on("Create Bulk discount")
          expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
        end

        it "Returns a message if the creation is unsuccesful and when it is successful" do
          visit new_merchant_bulk_discount_path(@merchant)

          fill_in 'bulk_discount[quantity_threshold]', with: ""
          fill_in 'bulk_discount[percentage_discount]', with: 20
          click_on("Create Bulk discount")

          expect(page).to have_content("ERROR: Missing required information")

          fill_in 'bulk_discount[quantity_threshold]', with: 10
          fill_in 'bulk_discount[percentage_discount]', with: 20
          click_on("Create Bulk discount")
          
          expect(page).to have_content("You have successfully created a new Bulk Discount")
        end
        
        it "Does not successfully create a discount if non integer used" do
          visit new_merchant_bulk_discount_path(@merchant)

          fill_in 'bulk_discount[quantity_threshold]', with: "five"
          fill_in 'bulk_discount[percentage_discount]', with: 20
          click_on("Create Bulk discount")

          expect(page).to have_content("ERROR: Missing required information")
        end
      end
    end
  end
end