class UsersController < ApplicationController

  respond_to :html,:json

  def post_data
    Rails.logger.info "Post Data"
  end

  # Don't forget to edit routes.  :create, :update, :destroy should only be
  # present if your jqgrid has add, edit and del actions defined for it.
  #
  # resources :users, :only => [:index, :create, :update, :destroy]

  GRID_COLUMNS = %w{name email}

  def index
    @users = ""
    total_entries=1
    Rails.logger.info "Test"
    respond_with() do |format|

      format.html
      format.json {render :json => User.all}
#      format.json {render :json => filter_on_params(User, GRID_COLUMNS)}

    end
  end

  def show
    @user = User.find( params[:id] )
  end

  # PUT /users/1
  def update
    grid_edit(User, GRID_COLUMNS)
  end

  # DELETE /users/1
  def destroy
    grid_del(User, GRID_COLUMNS)
  end

  # POST /users
  def create

  end
end
