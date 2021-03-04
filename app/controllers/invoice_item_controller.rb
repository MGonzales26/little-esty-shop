class InvoiceItemController < ApplicationController
  def update 
    inv_item = InvoiceItem.find(params[:id])
    inv_item.update!(status: params[:status])
    redirect_to "/merchants/#{params[:merchant_id]}/invoices/#{inv_item.invoice_id}"
  end
end