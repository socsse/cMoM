class PeripheralsController < ApplicationController

  before_filter do
    @user = User.find( params[ :user_id ] )
    @chip = @user.chips.find( params[ :chip_id ] )
  end

  def index
    respond_to do |format|
      format.html {
        @peripherals = @chip.peripherals
      }
      format.json {

        @current_page  = params[ :page ] ? params[ :page ].to_i : 1
        peripherals_per_page = params[ :rows ] ? params[ :rows ].to_i : 10

        sort_field = params[ :sidx ] ? params[ :sidx ] : "name"
        sort_order = params[ :sord ] ? params[ :sord ] : "desc"

        @peripherals = @chip.peripherals( sort:[[ sort_field, sort_order ]] ).page( @current_page ).per( peripherals_per_page )

        @total_peripherals = @peripherals.count
        @total_pages = ( @total_peripherals / peripherals_per_page ) + ( @total_peripherals % peripherals_per_page ? 1 : 0 )

        render :layout => "peripherals_index"
      }
    end
  end

  def new
    @peripheral = Peripheral.new
  end

end

