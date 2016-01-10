class Spending < ActiveRecord::Base
  belongs_to :budget, -> { includes :category }
  belongs_to :payment_method
  belongs_to :debt_balance

  validates_presence_of :description, :spending_date, :amount, :payment_method, :budget
  validates :amount, numericality: true, exclusion: { in: [0], message: "can't be %{value}." }
  validate :spending_goal

  ## Set description to loans if loans selected
  before_validation :clean_desc

  def self.search(search)
    if search
      where('description LIKE ?', "%#{search}%")
    else
      all
    end
  end

  def authorize(user = nil)
    owner = payment_method.user
    owner.id == user.id || owner.contributors.where(id: user.id).exists?
  end

  private

  def clean_desc
    self.description = description.titleize unless description.nil?
  end

  def spending_goal
    if budget && budget.category.debts.any?
      if !debt_balance
        errors.add(:goal, "can't be empty for this category")
      elsif debt_balance.debt.category_id != budget.category_id
        errors.add(:goal, "doesn't belong to this category; budget.category_id: #{budget.category_id}; debt_balance.debt.category_id #{debt_balance.debt.category_id}")
      else
        self.description = debt_balance.debt_name
      end
    end
  end
end
