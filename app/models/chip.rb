class Chip
  include Mongoid::Document

  field :name, type: String

  # used to hold temporary record when cancelling an edit operation
  recursively_embeds_one

  embeds_one  :job

  embeds_one  :microcontroller
  embeds_one  :memory

  embeds_many :peripherals

  embedded_in :user

  validates_presence_of   :name
  validates_uniqueness_of :name

  def self.chip_for_new( user )
    chip = user.chips.new

    unique_name = "chip_" + Time.new.strftime( "%m%d%y_%H%I%S" )
    while (user.chips.where( name: unique_name ).count() != 0)
      sleep( 1 )
      unique_name = "chip_" + Time.new.strftime( "%m%d%y_%H%I%S" )
    end

    chip.name = unique_name

    chip.job = Job.new
    chip.microcontroller = Microcontroller.new
    chip.memory = Memory.new

    # make persistent into database, will need to call cancel_create if user cancels operation
    chip.save( :validate => true )

    Rails.logger.info( "Chip is persisted = #{chip.persisted?}" )

    chip
  end

  def cancel_edit
    if (parent_chip)
      # cancel was done when editing an exising chip, so we need to restore previous chip
    else
      # cancel was done when creating a new chip, so just destroy this new chip
      destroy()
    end
  end

  def name=(name)
    stored_name = name
    if (parent_chip && name == parent_chip.name)
      stored_name << "_tmp"
    end
    super(stored_name)
  end

  def name
    real_name = super()
    if (parent_chip && real_name.end_with?( "_tmp" ))
      real_name = real_name[0, real_name.length() - 5]
    end
    Rails.logger.info "Returning name = #{real_name} from #{super()}"
    real_name
  end

  def add_peripheral_list
    list = [["UART", "uart"], ["USB", "usb"]]
    Rails.logger.info "#{list}"
    list
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
