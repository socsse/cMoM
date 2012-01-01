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
