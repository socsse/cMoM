class User

  include Mongoid::Document

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name

  embeds_many :chips

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false

  # for security, prevent mass-assignment operations
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

end
