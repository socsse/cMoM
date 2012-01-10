//= require 'grid_object.js'

class ChipsGrid extends cMoMGridObject

  grid: -> $('#chips_grid')
  grid_container: -> $('#chips_grid_container')
  grid_pager: -> $('#chips_grid_pager')

  grid_json_id: -> 'chip.id'

  jgrid_caption: -> 'Chips'


jQuery ->
  window.grid_object = new UsersGrid

