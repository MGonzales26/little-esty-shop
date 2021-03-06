require 'rails_helper'

RSpec.describe "Bulk Discount Index Page" do
  before (:each) do 
    @merchant = create(:merchant)

    @bulk_discount1 = create(:bulk_discount, merchant: @merchant)
    @bulk_discount2 = create(:bulk_discount, merchant: @merchant)
    @bulk_discount3 = create(:bulk_discount, merchant: @merchant)
    @bulk_discount4 = create(:bulk_discount, merchant: @merchant)
  end
  describe "As a merchant" do
    describe "When I visit my merchant dashboard" do
      it "has a link to view all my discounts" do
        visit merchant_dashboard_index_path(@merchant)
        
        expect(page).to have_link "My Discounts"
      end
      
      describe "When I click on this link" do
        it "takes me to the bulk discount index page, where I see all of my discounts; including quantity thereshold and % discount" do
          visit merchant_dashboard_index_path(@merchant)

          click_link("My Discounts")
          expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))

          within("#discount-#{@bulk_discount1.id}") do
            expect(page).to have_content(@bulk_discount1.quantity_threshold)
            expect(page).to have_content(@bulk_discount1.percentage_discount)
          end

          within("#discount-#{@bulk_discount2.id}") do
            expect(page).to have_content(@bulk_discount2.quantity_threshold)
            expect(page).to have_content(@bulk_discount2.percentage_discount)
          end

          within("#discount-#{@bulk_discount3.id}") do
            expect(page).to have_content(@bulk_discount3.quantity_threshold)
            expect(page).to have_content(@bulk_discount3.percentage_discount)
          end
        end

        it "links to the discount's show page for every listed discount" do
          visit merchant_bulk_discounts_path(@merchant)

          within("#discount-#{@bulk_discount1.id}") do
            expect(page).to have_link("Buy #{@bulk_discount1.quantity_threshold} of the same item to get %#{@bulk_discount1.percentage_discount} off")
            click_on("Buy #{@bulk_discount1.quantity_threshold} of the same item to get %#{@bulk_discount1.percentage_discount} off")
            expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount1))
          end
        end
      end


    end
  end

end
