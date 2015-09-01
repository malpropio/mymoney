class PaymentMethod < ActiveRecord::Base
  has_many :spendings

  validates_presence_of :description, :name
end
