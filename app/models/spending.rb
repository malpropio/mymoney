class Spending < ActiveRecord::Base
  belongs_to :category
  belongs_to :budget
  belongs_to :payment_method

  attr_accessor :description_select
  attr_accessor :description_cc

  validates_presence_of :description, :category_id, :spending_date, :amount, :payment_method_id
  validates :amount, numericality: true
  
  DEBIT_CATEGORIES = ['Credit Cards','Loans','Rent','Utilities']

  before_save do
    set_budget
  end

  after_create do
    set_budget
  end

  ## Set description to loans if loans selected
  before_validation :clean_desc

  def self.search(search)
    if search
      where('description LIKE ?', "%#{search}%")
    else
      all
    end
  end

  private
  def set_budget
    dt = self.spending_date.change(day: 1).strftime('%Y-%m')            
    new_budget = Budget.where("DATE_FORMAT(budget_month, '%Y-%m') = ? AND category_id = ?", dt, self.category_id)
    self.budget_id = new_budget.first.id unless new_budget.first.nil?
  end

  def clean_desc
    if !self.category.nil?
      self.description = nil if (self.category.name == 'Loans' || self.category.name == 'Credit Cards')
      self.description = self.description_select if self.category.name == 'Loans'
      self.description = self.description_cc if self.category.name == 'Credit Cards'
      self.payment_method_id = PaymentMethod.find_by_name("Debit").id if (DEBIT_CATEGORIES.include? self.category.name)
      self.description = self.description.titleize unless self.description.nil?
    end
  end

end
