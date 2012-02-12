class Chip
  include Mongoid::Document

  field :name, type: String
  field :tmp_record, type: Boolean, default: false

  embeds_one  :job

  embeds_one  :microcontroller
  embeds_one  :memory

  embeds_many :peripherals

  embedded_in :user

  validates_presence_of   :name
  validates_uniqueness_of :name

  before_create { job |= self.build_job }

  def self.init_for_new_controller
    chip = Chip.new
    chip.memory = Memory.new
    chip.microcontroller = Microcontroller.new
    chip
  end

  def json_obj_for_config_file
    {
      :id => self._id,
      :name => self.name,
      :memory => self.memory.json_obj_for_config_file,
      :microcontroller => self.microcontroller.json_obj_for_config_file
    }
  end
end
