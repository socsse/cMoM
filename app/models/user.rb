class User

  include Mongoid::Document

  # Include default devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :null => false
  field :encrypted_password, :type => String, :null => false

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  field :name

  embeds_many :chips

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false

  # for security, prevent mass-assignment operations
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  def chips_config_file_as_json(chip)
    # TODO: Validate chip belongs to user
    {
      :user => {
        :id => self._id,
        :name => self.name,
        :email => self.email,
        :chip => chip.json_obj_for_config_file
      }
    }.to_json
  end
end
