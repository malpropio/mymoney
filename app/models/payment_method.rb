class PaymentMethod < ActiveRecord::Base
  has_many :spendings

  validates_presence_of :description, :name
  validates_uniqueness_of :name, case_sensitive: false
end
