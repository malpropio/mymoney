class Budget < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :category
  has_many :spendings

  validates_presence_of :category_id, :budget_month, :amount
  validates :amount, numericality: true

  validates_uniqueness_of :category_id, :scope => :budget_month, message: "already set for this month"

  before_validation do 
    self.budget_month = self.budget_month.change(day: 1) unless self.budget_month.blank? 
  end 

  def alert_message
    message = nil

    if self.spendings.sum(:amount) > self.amount
      message = "Alert!!! The #{number_to_currency(self.amount)} budget for #{self.category.name} as been exceeded by #{number_to_currency(self.spendings.sum(:amount) - self.amount)}. The total spendings is now #{number_to_currency(self.spendings.sum(:amount))}"
    elsif self.spendings.sum(:amount)/self.amount > 0.75
      message = "Alert!!! You have reached #{number_to_percentage(self.spendings.sum(:amount)*100/self.amount, precision: 0)} of the #{number_to_currency(self.amount)} budget for #{self.category.name}. #{number_to_currency(self.amount - self.spendings.sum(:amount))} left to spend. The total spendings is now #{number_to_currency(self.spendings.sum(:amount))}"
    end

    message
  end

end
