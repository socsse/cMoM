require 'activemessaging/processor'
require 'aws'
require 'tempfile'

class ChipsController < ApplicationController

  include ActiveMessaging::MessageSender

  publishes_to :job_todo_queue
  publishes_to :job_status_queue

  before_filter do
    @user  = User.find(params[:user_id])
  end

  def index
    respond_to do |format|
      format.html
      format.json {

        @current_page  = params[:page] ? params[:page].to_i : 1
        chips_per_page = params[:rows] ? params[:rows].to_i : 10

        sort_field = params[:sidx] ? params[:sidx] : "name"
        sort_order = params[:sord] ? params[:sord] : "desc"

        @chips = @user.chips( sort: [[ sort_field, sort_order]]).page(@current_page).per(chips_per_page)

        @total_chips = @chips.count
        @total_pages = (@total_chips / chips_per_page) + (@total_chips % chips_per_page ? 1 : 0)

        render :layout => "chips_index"
      }
    end
    @chips = @user.chips
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
      submit_job
      redirect_to @user
    else
        render :action => "new"
    end
  end

  def update
    @chip = @user.chips.find(params[:id])
    @chip.update_attributes!(params[:chip])

    submit_job
    flash[:notice] = "Job queued for #{@chip.name}!"
    redirect_to @user, :notice => flash[:notice]
  end

  def destroy
    @chip = @user.chips.find(params[:id])
    @chip.destroy

    # jqgrid will take care of the updating
    render :nothing => true
  end

  def submit_job

    # create configuration file and copy to S3
    #
    s3 = AWS::S3.new

    begin
      bucket = s3.buckets.create("cmom.microsemi.com")
    rescue SocketError
      flash[:notice] = "Job couldn't be submitted"
      return
    end

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

    @chip.job.status = Job::STATUS[:queued]
    @chip.job.save!

    flash[:notice] = "Job queued for #{@chip.name}!"

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
