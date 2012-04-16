class UartsController < ApplicationController

  before_filter do
    @user = User.find( params[ :user_id ] )
    @chip = @user.chips.find( params[ :chip_id ] )
  end

  def new
    @uart = Uart.new
  end



