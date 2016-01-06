class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  has_many :events
  validates :username, presence: true,
                       length: { maximum: 20 },
                       uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true                     
                       
  # Only allow letter, number, underscore and punctuation.
  
  validate :validate_username
  
  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end                                            

  def set_default_role
    self.role ||= :user
  end

  devise :invitable, 
         :database_authenticatable, 
         :registerable, 
         :confirmable,
         :recoverable, 
         :rememberable, 
         :trackable, 
         :validatable
         # :confirmable, 
         #:lockable, 
         #:timeoutable,
         #:omniauthable

  def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions.to_hash).first
      end
  end       
end
#where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first