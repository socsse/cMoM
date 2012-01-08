GetSampleJSON = ->
  json = {
    "page": 1,
    "total": 2,
    "records": 2,
    "rows": [
      { "user" : { "id" : "1", "name" : "Ken",  "email" : "Ken@KJoyner.com"} }
      { "user" : { "id" : "2", "name" : "Test", "email" : "Test@Example.com"} }
    ]
  }
  json

class GridObject

  constructor: ->
    @grid_container = $('#users_grid_container')
    @grid = $('#users_grid')
    @.setup_events()

  resize_handler: (event) =>
    # use fudge factor to prevent horizontal scrollbars
    width = @grid_container.width() - 2

    if (width > 0 && Math.abs( width - @grid.width()) > 5)
      @grid.setGridWidth( width )
    false

  setup_events: ->
    $(window).resize @resize_handler

jQuery ->
  window.grid_object = new GridObject()
  csrf_token = $('meta[name="csrf-token"]').attr( 'content' )
  grid = $('#users_grid')
  grid_pager = $('#users_grid_pager')
  beforeSelectRow = ( rowid, e ) ->
    column_id = $.jgrid.getCellIndex( e.target )
    if (column_id == 0)
      $.jgrid.del.msg = 'Are you sure?'
      grid.delGridRow(
        rowid
        {
          url: 'users/'+rowid
          mtype: 'DELETE',
          delData: { authenticity_token: csrf_token }
          reloadAfterSubmit: true
        }
      )
      return false
    true
  grid.jqGrid(
    url: 'users.json'
    mtype: 'GET'
    datatype: 'json'
    jsonReader: { root: 'rows', id: 'user.id', repeatitems: false }
    colName: ['Name', 'E-Mail']
    colModel: [
      { 
        name: ''
        width: 24
        align: 'center'
        resizable: false
        sortable: false
        search: false 
        formatter: -> '<span class="ui-icon ui-icon-trash"></span>'
      }
      { name:'user.name', label:'Name', index:'name', width: 200, align: 'right' }
      { name:'user.email', label:'E-Mail', index:'email', width: 300 }
    ]
    autowidth: true
    caption: 'Users'
    height: 150
    pager: grid_pager
    restful: true
    rowList: [10, 20, 30]
    rowNum: 10
    sortname: 'name'
    sortorder: 'desc'
    viewrecords: true
    beforeSelectRow: beforeSelectRow
    onSelectRow: (id) ->
      window.location.href = '/users/' + id
  )
  grid.jqGrid( 'navGrid', '#users_grid_pager', {add:true, edit:false, del:false} )
  grid.jqGrid( 'gridResize' )

