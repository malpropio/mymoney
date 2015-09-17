class Debt < ActiveRecord::Base
  has_many :debt_balances
  
  validates_presence_of :category, :name

  validates_uniqueness_of :category, :scope => :name, message: "already taken for this name"

  ## Titleize fields if not empty
  before_validation :clean_fields

  before_save do
    self.sub_category = self.category if self.sub_category.blank?
  end

  private
  def clean_fields
    self.category = self.category.titleize unless self.category.nil?
    self.sub_category = self.sub_category.titleize unless self.sub_category.nil?
    self.name = self.name.titleize unless self.name.nil?
  end
end
