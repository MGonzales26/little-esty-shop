class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum status: { packaged: 0, pending: 1, shipped: 2 }


  def available_discounts
    BulkDiscount.where(merchant_id: self.item.merchant_id)
                .where('bulk_discounts.quantity_threshold <= ?', self.quantity)
                .order(percentage_discount: :desc)
                .first
  end

  def discount_price
    discount = self.available_discounts
    if discount
      self.update(unit_price: discount.price_after_discounts(self.item.unit_price))
    else
      self
    end
  end

end
