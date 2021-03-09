class Merchant < ApplicationRecord
  validates_presence_of :name
  
  has_many :items, dependent: :destroy
  has_many :bulk_discounts, dependent: :destroy
  enum status: { enabled: 0, disabled: 1 }

  def top_five_customers
    Customer.joins(invoices: :items)
            .where('merchant_id = ?', self.id)
            .joins(invoices: :transactions)
            .where('result = ?', "success")
            .select("customers.*, count('transactions.result') as successful_transactions")
            .group('customers.id')
            .order(successful_transactions: :desc)
            .limit(5)
  end


  def top_five_items
    Item.joins(:invoice_items)
        .where('merchant_id = ?', self.id)
        .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
        .group('items.id')
        .order(total_revenue: :desc)
        .limit(5)
  end



  def items_not_shipped
    Invoice.joins(:items)
           .where('merchant_id = ?', self.id)
           .joins(:invoice_items)
           .where('invoice_items.status != ?', 2)
           .select("items.name, invoices.id, invoices.created_at")
           .order("invoices.created_at")
  end

  def enabled?
    status == 'enabled'
  end

  def disabled?
    status == 'disabled'
  end

  def self.display_enabled
    where(status: 0)
  end

  def self.display_disabled
    where(status: 1)
  end

  def self.top_five_merchants_by_revenue
    Merchant.joins(items: :invoice_items)
    .where('invoice_items.status = ?', 2)
    .select("merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue")
    .group("merchants.id")
    .order(revenue: :desc)
    .limit(5)
  end

  def best_day
    Merchant.joins(items: :invoices)
    .where('merchant_id = ?', self.id)
    .select('merchants.*, invoices.created_at, sum(invoice_items.unit_price * invoice_items.quantity) AS revenue')
    .group('invoices.created_at, merchants.id')
    .order(revenue: :desc)
    .first
  end
end
