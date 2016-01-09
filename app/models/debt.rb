class Debt < ActiveRecord::Base
  belongs_to :category
  belongs_to :account

  has_many :debt_balances

  validates_presence_of :name, :category, :account
  validate :debt_exists

  ## Titleize fields if not empty
  before_validation :clean_fields

  before_save do
    self.sub_category = self.category.name if self.sub_category.blank?
    self.fix_amount = nil if self.fix_amount && self.fix_amount < 0
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

  def self.do_not_pay_list
    result = Debt.where(autopay: false).where(deleted_at: nil).uniq.pluck(:name)
    result += Account.uniq.pluck(:name)
    result.sort
  end

  def to_s
    self.name
  end

  def authorize(user=nil)
    owner = self.account.user
    owner.id == user.id || owner.contributors.where(id: user.id).exists?
  end

  private
  def debt_exists
    owner = self.category.user unless self.category.nil?
    if owner && owner.debts.where("debts.id != #{self.id || 0} AND debts.name = '#{self.name}' AND deleted_at IS NULL").exists?
      errors.add(:debt, "already exists")
    end
  end

  def clean_fields
    self.sub_category = self.sub_category.titleize unless self.sub_category.nil?
    self.name = self.name.titleize unless self.name.nil?
    self.name = self.name.gsub(/[^0-9a-z\\s]/i, '') unless sef.name.nil?
  end
end
