class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  enum status: { in_progress: 0, completed: 1, cancelled: 2 }


  def self.incomplete
    where(status: 0).or(where(status: 2))
  end


  def format_day
    created_at.strftime("%A %B %d, %Y")
  end
  
  def self.merchants_invoices(merch_id)
    joins(:items).where('merchant_id = ?', merch_id).select("invoices.*").distinct
  end
  
  def total_revenue
    discounted_revenue
  end

  def discounted_revenue
    invoice_items.each do |invoice_item|
      invoice_item.discount_price
    end
    invoice_items.sum('unit_price * quantity')
  end

  def self.oldest_to_newest
    order(:created_at)
  end

  def date_created
    self.created_at.strftime("%A, %B%e, %Y")
  end

  def find_invoice_item(item_id)
    InvoiceItem.find_by(invoice_id: self.id, item_id: item_id)
  end
end
