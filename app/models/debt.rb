class Debt < ActiveRecord::Base
  belongs_to :category
  belongs_to :account

  has_many :debt_balances

  validates_presence_of :name, :category, :account
  validate :debt_exists

  ## Titleize fields if not empty
  before_validation :clean_fields

  before_save do
    self.sub_category = category.name if sub_category.blank?
    self.fix_amount = nil if fix_amount && fix_amount < 0
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
    name
  end

  def authorize(user = nil)
    owner = account.user
    owner.id == user.id || owner.contributors.where(id: user.id).exists?
  end

  private

  def debt_exists
    owner = category.user unless category.nil?
    if owner && owner.debts.where("debts.id != #{id || 0} AND debts.name = '#{name}' AND deleted_at IS NULL").exists?
      errors.add(:debt, 'already exists')
    end
  end

  def clean_fields
    self.sub_category = sub_category.titleize unless sub_category.nil?
    self.name = name.titleize unless name.nil?
    self.name = name.gsub(/[^0-9a-z\\s]/i, '') unless name.nil?
  end
end
