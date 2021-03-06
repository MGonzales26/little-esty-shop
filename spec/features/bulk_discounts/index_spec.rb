require 'rails_helper'

RSpec.describe "Bulk Discount Index Page" do
  before (:each) do 
    @merchant = create(:merchant)
  end
  describe "As a merchant" do
    describe "When I visit my merchant dashboard" do
      it "has a link to view all my discounts" do
        
      end

    end
  end

end

# When I click this link
# Then I am taken to my bulk discounts index page
# Where I see all of my bulk discounts including their
# percentage discount and quantity thresholds
# And each bulk discount listed includes a link to its show page