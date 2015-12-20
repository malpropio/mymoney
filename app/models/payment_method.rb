class PaymentMethod < ActiveRecord::Base
  belongs_to :user

  has_many :spendings

  validates_presence_of :description, :name
  validates_uniqueness_of :name, case_sensitive: false
end
