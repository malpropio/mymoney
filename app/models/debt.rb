class Debt < ActiveRecord::Base
  has_many :debt_balances
  
  validates_presence_of :category, :name

  validate :debt_exists
  #validates_uniqueness_of :category, :scope => :name, message: "already taken for this name"

  ## Titleize fields if not empty
  before_validation :clean_fields

  before_save do
    self.sub_category = self.category if self.sub_category.blank?
  end

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end
  
  def self.active
    where(deleted_at: nil)
  end
  
  def soft_delete
    update_attribute(:deleted_at, Time.now)
  end

  private
  def debt_exists
    if Debt.where("id != #{self.id || 0} AND category = '#{self.category}' AND name = '#{self.name}' AND deleted_at IS NULL").exists?
      errors.add(:debt, "already exists")
    end
  end
  
  def clean_fields
    self.category = self.category.titleize unless self.category.nil?
    self.sub_category = self.sub_category.titleize unless self.sub_category.nil?
    self.name = self.name.titleize unless self.name.nil?
  end
end
