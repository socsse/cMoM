class <%= grid.class_name %>Controller < ApplicationController
	respond_to :html,:json
  
	# Don't forget to edit routes.  :create, :update, :destroy should only be
	# present if your jqgrid has add, edit and del actions defined for it.
	# 
	# resources :<%=grid.resource_name%>, :only => [:index, :create, :update, :destroy]

	GRID_COLUMNS = %w{<%= grid.columns.map {|x| "#{x}"}.join(' ') %>}
	
	def index
		respond_with() do |format|
			<% if grid.detail_grid %>
			format.json {render :json => filter_details(<%=grid.model_name%>, GRID_COLUMNS)}  
			<% else %>
			format.json {render :json => filter_on_params(<%=grid.model_name%>, GRID_COLUMNS)}  
			<% end %>
		end
	end

 	# PUT /<%=grid.resource_name%>/1
	def update
		grid_edit(<%=grid.model_name%>, GRID_COLUMNS)
	end
	
	# DELETE /<%=grid.resource_name%>/1
	def destroy
		grid_del(<%=grid.model_name%>, GRID_COLUMNS)
	end
 
	# POST /<%=grid.resource_name%>
	def create
		<% if grid.detail_grid %>
		grid_add(<%=grid.model_name%>, GRID_COLUMNS + ['<%=grid.foreign_key%>'])
		<% else %>
		grid_add(<%=grid.model_name%>, GRID_COLUMNS)
		<% end %>
	end
end
