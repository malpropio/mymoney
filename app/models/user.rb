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
    self.get_all("spendings").joins(budget: :category).where("categories.name <> 'Credit Cards'")
  end

  def cc_spendings
    self.get_all("spendings").joins(:payment_method).where("payment_methods.name = 'Credit'")
  end

  def cc_payments
    self.get_all("spendings").joins(budget: :category).where("categories.name = 'Credit Cards'")
  end

  def real_budgets
    self.budgets.joins(:category).where("categories.name <> 'Credit Cards'")
  end

  def authorize(user=nil)
    self.id == user.id
  end

  def get_all(attribute)
    model = attribute.strip.underscore.singularize.camelize.constantize
    singular = ActiveModel::Naming.singular(model)
    plural = ActiveModel::Naming.plural(model)
    ids = send("#{singular}_ids")
    self.contributors.map{|c| ids += c.send("#{singular}_ids") if c.contributors.where(id: self.id).exists? }
    model.where("#{plural}.id IN (?)",ids)
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
