class BulkDiscount < ApplicationRecord
  validates :quantity_threshold, numericality: { only_integer: true }, presence: true
  validates :percentage_discount, numericality: { only_integer: true }, presence: true


  belongs_to :merchant


  def price_after_discounts(current_price)
    current_price - (current_price * (self.percentage_discount * 0.01))
  end
end
