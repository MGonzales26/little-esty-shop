class BulkDiscount < ApplicationRecord
  validates_presence_of :quantity_threshold,
                        :percentage_discount

  belongs_to :merchant


  def price_after_discounts(current_price)
    current_price - (current_price * (self.percentage_discount * 0.01))
  end
end
