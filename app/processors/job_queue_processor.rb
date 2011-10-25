class JobQueueProcessor < ApplicationProcessor

  subscribes_to :job_queue

  def on_message(message)
    logger.debug "JobQueueProcessor received: " + message
  end
end