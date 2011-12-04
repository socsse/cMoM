require 'activemessaging/processor'
require 'aws'
require 'tempfile'

class Users::ChipsController < ApplicationController

  include ActiveMessaging::MessageSender
  publishes_to :job_queue

  before_filter do
    @user  = User.find( params[:user_id] )
  end


  def index
    @chips = Chip.all
  end

  def show
    @chip = @user.chips.find( params[:id] )
  end

  def new
    @chip = @user.chips.new
    @chip.microcontroller = Microcontroller.new
    @chip.memory = Memory.new
  end

  def edit
    @chip = @user.chips.find( params[:id] )
  end

  def create
    @chip = @user.chips.new( params[ :chip ] )
    if @chip.save
      redirect_to @user, :notice => "Chip created!"
    else
        render :action => "new"
    end
  end

  def update
    @chip = @user.chips.find( params[:id] )
    @chip.update_attributes!( params[:chip ] )

    submit_job
    redirect_to @user, :notice => "Job submitted for @chip.name"
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
    s3_object.write(@chip.config_file)

    # send message via SQS to backend workers
    #
    message = Hash.new
    message["bucket_name"] = "cmom.microsemi.com"
    message["config_file"] = dst_file_name

    publish :job_queue, message.to_json

  end

end
