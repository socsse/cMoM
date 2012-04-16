class UsersController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json {
        @current_page  = params[ :page ] ? params[ :page ].to_i : 1
        users_per_page = params[ :rows ] ? params[ :rows ].to_i : 10

        sort_field = params[ :sidx ] ? params[ :sidx ] : "name"
        sort_order = params[ :sord ] ? params[ :sord ] : "desc"

        @users = User.all( sort: [[ sort_field, sort_order ]]).page( @current_page ).per( users_per_page )

        @total_users = User.count
        @total_pages = (@total_users / users_per_page) + (@total_users % users_per_page ? 1 : 0)

        render :layout => "users_index"
      }
    end
  end

  def show
    @user = User.find( params[ :id ] )
  end

  def destroy
    user = User.find( params[ :id ] )
    user.destroy

    # jqgrid will take care of the updating
    render :nothing => true
  end

end
