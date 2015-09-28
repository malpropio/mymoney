class Budget < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include Rails.application.routes.url_helpers

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
    header = "=== Budget Alert ===\n\n"

    if self.spendings.sum(:amount) > self.amount
      message = "#{header}The #{number_to_currency(self.amount)} budget for #{self.category.name} as been exceeded by #{number_to_currency(self.spendings.sum(:amount) - self.amount)}. The total spendings is now #{number_to_currency(self.spendings.sum(:amount))}.\n\n#{recent_spendings}"
    elsif self.spendings.sum(:amount)/self.amount > 0.75
      message = "#{header}You have reached #{number_to_percentage(self.spendings.sum(:amount)*100/self.amount, precision: 0)} of the #{number_to_currency(self.amount)} budget for #{self.category.name}. #{number_to_currency(self.amount - self.spendings.sum(:amount))} left to spend. The total spendings is now #{number_to_currency(self.spendings.sum(:amount))}.\n\n#{recent_spendings}"
    end

    message
  end

  private
  def recent_spendings
    sample = "+++ Recent spending(s) +++\n"
    
    self.spendings.order("spending_date desc").limit(3).each do |spending|
      sample += "#{spending.description}: #{number_to_currency(spending.amount)}\n"
    end

    sample += "For more #{budget_url(self)}"
    
    sample
    
  end

end
