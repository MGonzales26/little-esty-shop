require 'rails_helper'

RSpec.describe "Edit Bulk Discount Page" do
  before(:each) do
    @merchant = create(:merchant)
    @bulk_discount = create(:bulk_discount, merchant: @merchant)
  end
  describe "As a merchant" do
    describe "When I visit the bulk discount show page" do
      it "has a link to edit the bulk discount that takes me to the edit page" do
        visit merchant_bulk_discount_path(@merchant, @bulk_discount)

        expect(page).to have_link("Edit Bulk Discount")
        click_link("Edit Bulk Discount")
        expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @bulk_discount))
      end

      describe "Edit form page" do
        it "displays a form with the current information pre-populated" do
          visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount)

          expect(page).to have_field("bulk_discount[quantity_threshold]")
          expect(page).to have_field("bulk_discount[percentage_discount]")

          expect(find_field('bulk_discount[quantity_threshold]').value).to eq("#{@bulk_discount.quantity_threshold}")
          expect(find_field('bulk_discount[percentage_discount]').value).to eq("#{@bulk_discount.percentage_discount}")
        end

        it "takes me back to the show page with the updated information after filling out the form" do
          visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount)

          fill_in 'bulk_discount[quantity_threshold]', with: 5
          fill_in 'bulk_discount[percentage_discount]', with: 15

          click_on("Update Bulk discount")
          expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount))

          within("#dicount-info") do
            expect(page).to have_content("5")
            expect(page).to have_content("15")

            expect(page).to_not have_content("20")
            expect(page).to_not have_content("10")
          end
        end

        it "renders a flash message if the discount is updated or not" do
          visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount)

          fill_in 'bulk_discount[quantity_threshold]', with: ""
          fill_in 'bulk_discount[percentage_discount]', with: 15
          
          click_on("Update Bulk discount")
          expect(page).to have_content("ERROR: Missing required information")
          
          fill_in 'bulk_discount[quantity_threshold]', with: 5
          fill_in 'bulk_discount[percentage_discount]', with: 15

          click_on("Update Bulk discount")
          expect(page).to have_content("Your discount has been successfully updated")
        end
      end
    end
  end
end
