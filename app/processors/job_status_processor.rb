require 'chip'

require 'json'

class JobStatusQueueProcessor < ApplicationProcessor

  subscribes_to :job_status_queue

  def on_message(msg)
    job_status = JSON.parse(msg)

    user_id = job_status["user_id"]
    chip_id = job_status["chip_id"]

    chip = User.find(user_id).chips.find(chip_id)

    chip.job.status = job_status["status"]
    chip.job.output_file = job_status["output_file"]
    chip.job.save!

    Rails.logger.info chip.job.inspect
  end
end
