class PaymentMethod < ActiveRecord::Base
  belongs_to :user

  has_many :spendings

  validates_presence_of :description, :name, :user_id
  validates_uniqueness_of :name, case_sensitive: false, :scope => :user_id

  def to_s
    name
  end
end
