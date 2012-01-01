require 'activemessaging/processor'
require 'aws'
require 'tempfile'

class Users::ChipsController < ApplicationController

  include ActiveMessaging::MessageSender

  publishes_to :job_todo_queue
  publishes_to :job_status_queue

  before_filter do
    @user  = User.find(params[:user_id])
  end

  def index
    @chips = Chip.all
  end

  def show
    @chip = @user.chips.find(params[:id])
  end

  def new
    @chip = Chip.init_for_new_controller
  end

  def edit
    @chip = @user.chips.find(params[:id])
  end

  def create
    @chip = @user.chips.new(params[:chip])
    if @chip.save
      redirect_to @user, :notice => "Chip created!"
    else
        render :action => "new"
    end
  end

  def update
    @chip = @user.chips.find(params[:id])
    @chip.update_attributes!(params[:chip])

    submit_job
    @chip.job.status = Job::STATUS[:queued]
    @chip.job.save!

    redirect_to @user, :notice => "Job queued for #{@chip.name}"
  end

  def submit_job
    # create configuration file and copy to S3
    #
    s3 = AWS::S3.new
    bucket = s3.buckets.create("cmom.microsemi.com")

    unique_user_dir = @chip.user._id
    chip_name = @chip.name

    dst_file_name = "#{unique_user_dir}/chip_#{chip_name}/config.xml"
    s3_object = bucket.objects[dst_file_name]
    s3_object.write(@user.chips_config_file_as_json(@chip))

    # send message via SQS to backend workers
    #
    message = Hash.new
    message[:bucket_name] = "cmom.microsemi.com"
    message[:config_file] = dst_file_name

    publish :job_todo_queue, message.to_json
  end

  def test_job_msg
    @chip = @user.chips.find(params[:id])

    s3 = AWS::S3.new
    bucket = s3.buckets.create("cmom.microsemi.com")

    unique_user_dir = @chip.user._id
    chip_name = @chip.name

    output_file_name = "#{unique_user_dir}/chip_#{chip_name}/output.html"

    s3_object = bucket.objects[output_file_name]
    s3_object.write("<p>This should contain information about the job.</p>")

    status_msg = Hash.new
    status_msg[:msg_type] = "job_status"
    status_msg[:msg_time] = Time.now

    status_msg[:user_id] = @user.id
    status_msg[:chip_id] = @chip.id

    status_msg[:status]      = params[:msg]
    status_msg[:output_file] = s3_object.url_for(:read).to_s

    publish :job_status_queue, status_msg.to_json
    redirect_to @user
  end

end
