class AdminController < ApplicationController
  layout 'admin'
  
  def index
    @invoices = Invoice.all
    @customers = Customer.all 
  end
end
