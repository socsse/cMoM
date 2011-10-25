require 'activemessaging/processor'

class AddJobToQueueController < ApplicationController

  include ActiveMessaging::MessageSender

  publishes_to :job_queue

  def index
#    @messages = Message.find :all
  end

  def create
    @message = params[ :message ]
    publish :job_queue, @message
    flash[ :notice ] = "'#{@message}' sent"
#    @messages = Message.find :all
    render :action => 'index'
  end

end
