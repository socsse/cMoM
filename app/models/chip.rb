class Chip
  include Mongoid::Document

  field :name,       type: String

  embeds_one  :job

  embeds_one  :microcontroller
  embeds_one  :memory

  embedded_in :user

  validates_presence_of   :name
  validates_uniqueness_of :name

  def config_file
    to_xml
  end
end
