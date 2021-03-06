FactoryBot.define do
  factory :bulk_discount do
    percentage_discount { 20 }
    quantity_threshold { 10 }
    merchant 
  end
end
