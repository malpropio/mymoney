class User < ActiveRecord::Base
  has_many :categories
  has_many :budgets, through: :categories
  has_many :payment_methods
  has_many :spendings, through: :payment_methods
  has_many :accounts
  has_many :income_sources, through: :accounts
  has_many :debts, through: :accounts
  has_many :account_balances, through: :accounts
  has_many :debt_balances, through: :debts
  has_many :account_balance_distributions, through: :account_balances

  has_and_belongs_to_many :contributors,
      autosave: true,
      class_name: 'User',
      join_table: :user_contributors,
      foreign_key: :user_id,
      association_foreign_key: :contributor_user_id

  attr_accessor :remember_token
  attr_accessor :activation_token
  
  before_save do 
  	self.email = email.downcase if !email.nil?
  	self.email = nil if (!email.nil? && email.empty?)
  end
  
  before_create :create_activation_digest
  
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :username, presence: true, length: { maximum: 20 }, allow_blank: false 
 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    allow_blank: false

                   
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true
  
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def real_spendings
    self.get_spendings.joins(budget: :category).where("categories.name <> 'Credit Cards'")
  end

  def cc_spendings
    self.get_spendings.joins(:payment_method).where("payment_methods.name = 'Credit'")
  end
  
  def cc_payments
    self.get_spendings.joins(budget: :category).where("categories.name = 'Credit Cards'")
  end

  def real_budgets
    self.budgets.joins(:category).where("categories.name <> 'Credit Cards'")
  end

  def authorize(user=nil)
    self.id == user.id
  end

  def get_categories
    ids = self.category_ids 
    self.contributors.map{|c| ids += c.category_ids if c.contributors.where(id: self.id).exists? }
    Category.where("categories.id IN (?)",ids)
  end

  def get_budgets
    ids = self.budget_ids
    self.contributors.map{|c| ids += c.budget_ids if c.contributors.where(id: self.id).exists? }
    Budget.where("budgets.id IN (?)",ids)
  end

  def get_payment_methods
    ids = self.payment_method_ids
    self.contributors.map{|c| ids += c.payment_method_ids if c.contributors.where(id: self.id).exists? }
    PaymentMethod.where("payment_methods.id IN (?)",ids)
  end

  def get_spendings
    ids = self.spending_ids
    self.contributors.map{|c| ids += c.spending_ids if c.contributors.where(id: self.id).exists? }
    Spending.where("spendings.id IN (?)",ids)
  end

  def get_accounts
    ids = self.account_ids
    self.contributors.map{|c| ids += c.account_ids if c.contributors.where(id: self.id).exists? }
    Account.where("accounts.id IN (?)",ids)
  end

  def get_income_sources
    ids = self.income_source_ids
    self.contributors.map{|c| ids += c.income_source_ids if c.contributors.where(id: self.id).exists? }
    IncomeSource.where("income_sources.id IN (?)",ids)
  end

  def get_debts
    ids = self.debt_ids
    self.contributors.map{|c| ids += c.debt_ids if c.contributors.where(id: self.id).exists? }
    Debt.where("debts.id IN (?)",ids)
  end

  def get_account_balances
    ids = self.account_balance_ids
    self.contributors.map{|c| ids += c.account_balance_ids if c.contributors.where(id: self.id).exists? }
    AccountBalance.where("account_balances.id IN (?)",ids)
  end

  def get_debt_balances
    ids = self.debt_balance_ids
    self.contributors.map{|c| ids += c.debt_balance_ids if c.contributors.where(id: self.id).exists? }
    DebtBalance.where("debt_balances.id IN (?)",ids)
  end

  def get_account_balance_distributions
    ids = self.account_balance_distribution_ids
    self.contributors.map{|c| ids += c.account_balance_distribution_ids if c.contributors.where(id: self.id).exists? }
    AccountBalanceDistribution.where("account_balance_distributions.id IN (?)",ids)
  end

  private
	
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase unless email.nil?
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
