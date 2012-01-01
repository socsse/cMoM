require 'aws'
require 'json'

class JobTodoQueueProcessor < ApplicationProcessor

  publishes_to  :job_status_queue
  subscribes_to :job_todo_queue

  def on_message(msg)
    job_params = JSON.parse(msg)

    s3 = AWS::S3.new
    bucket = s3.buckets[job_params["bucket_name"]]

    config_file = job_params["config_file"]
    config_obj  = bucket.objects[config_file]
    config_data = JSON.parse(config_obj.read)

    logger.info "---------- Config File Contents Begin ----------"
    logger.info config_data.to_s
    logger.info "---------- Config File Contents End ----------"

    config_obj.delete

    status_msg = Hash.new
    status_msg[:msg_type] = "job_status"
    status_msg[:msg_time] = Time.now

    status_msg[:user_id] = config_data["user"]["id"]
    status_msg[:chip_id] = config_data["user"]["chip"]["id"]

    status_msg[:status] = Job::STATUS[:test_running]

    publish :job_status_queue, status_msg.to_json
  end
end
