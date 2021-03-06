class BulkDiscount < ApplicationRecord
  validates_presence_of :quantity_threshold,
                        :percentage_discount

  belongs_to :merchant
end
