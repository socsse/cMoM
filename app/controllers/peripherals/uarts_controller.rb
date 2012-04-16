class Peripherals::UartsController < ApplicationController

  before_filter do
    @user = User.find( params[ :user_id ] )
    @chip = @user.chips.find( params[ :chip_id ] )
  end

  def new
    @uart = Uart.new
    respond_to do |format|
      format.html {
        Rails.logger.info "Format HTML"
      }
      format.js {
        Rails.logger.info "Format JS"
      }
    end
  end

  def edit
    @uart = @chip.find( params[ :id ] )
  end

  def create
    @uart = @chip.peripherals.new( params[ :uart], Uart )
    save_rc = @uart.save
    respond_to do |format|
      format.html {
        Rails.logger.info "Format HTML in Create"
        if save_rc
          redirect_to [@user, @chip]
        else
          render :action => "new"
        end
      }
      format.js {
        if save_rc
          render :nothing => true, :status => 0
        else
          render :action => "new"
        end
      }
    end
  end

  def update
    Rails.logger.info "In update, #{params[ :uart ]}"
    @uart = @chip.find( params[ :id ] )
    @uart.update_attributes!( params[ :uart ] )

    redirect_to [@user, @chip]
  end

end


