class this.cMoMGridObject

  constructor: ->
    @csrf_token    = $('meta[ name="csrf-token" ]').attr( 'content' )
    @.setup_grid()

  getColumnIndexByName: (colName) =>
    colModel = @.grid().jqGrid( "getGridParam", "colModel" )
    for i in [0..colModel.length - 1]
      if (colModel[i].name == colName)
        return i
    -1
    
  setup_grid_btns_model: ->
    [
      name: 'actions'
      index: 'actions'
      width: 55
      align: 'center'
      resizable: false
      sortable: false
      search: false
    ]

  grid_data_model: => []

  grid:           -> $('#grid')
  grid_container: -> $('#grid_container')
  grid_pager:     => $(@.grid_pager_id())
  grid_pager_id:  -> '#grid_pager'

  grid_json_url:  -> ''
  grid_json_id:   -> 'id'
  grid_json_rows: -> 'rows'

  grid_resource_url: -> ''

  grid_del_row_title:  -> "Delete Row"
  grid_del_row_caption: (rowID) -> "Delete Row"
  grid_del_path: (rowID) =>
    url: @.grid_resource_url() + '/' + rowID
    mtype: 'DELETE'
    delData: { authenticity_token: @csrf_token }

  grid_edit_row_title: -> "Edit Row"

  jgrid_autowidth: -> true
  jgrid_caption:   -> ''
  jgrid_height:    -> 150
  jgrid_rowList:   -> [10, 25, 50, 100]
  jgrid_rowNum:    -> 10
  jgrid_sortname:  -> 'name'
  jgrid_sortorder: -> 'desc'

  setup_grid: =>
    @.grid().jqGrid(
      url:        @.grid_json_url()
      datatype:   'json'
      jsonReader: { root: @.grid_json_rows(), id: @.grid_json_id(), repeatitems: false }
      colModel:    $.merge( @.setup_grid_btns_model(), @.grid_data_model() )
      autowidth:   @.jgrid_autowidth()
      caption:     @.jgrid_caption()
      height:      @.jgrid_height()
      hoverrows:   false
      pager:       @.grid_pager()
      rowList:     @.jgrid_rowList()
      rowNum:      @.jgrid_rowNum()
      sortname:    @.jgrid_sortname()
      sortorder:   @.jgrid_sortorder()
      viewrecords: true
      loadComplete: @.loadComplete
      beforeSelectRow: (rowID, e ) -> 
        false
    )
    @.grid().jqGrid( 'navGrid', @.grid_pager_id(), { add:false, edit:false, del:false })
    @.grid().jqGrid( 'gridResize' )
    true

  loadComplete: =>
    iCol = @.getColumnIndexByName( "actions" )
    @grid().children("tbody")
           .children("tr.jqgrow")
           .children("td:nth-child("+(iCol+1)+")")
           .each (index, element) =>
             $("<div />",
               class: "ui-pg-div ui-inline-custom"
               style: "margin-left:5px; float:left;"
               title: @.grid_edit_row_title()
               mouseover: -> $(this).addClass('ui-state-hover')
               mouseout:  -> $(this).removeClass('ui-state-hover')
               click: (e) =>
                 rowID = $(e.target).closest("tr.jqgrow").attr("id")
                 @.grid_edit_row( rowID )
             )
             .append('<span class="ui-icon ui-icon-pencil"></span>')
             .appendTo( element )
             $("<div>",
               class: "ui-pg-div ui-inline-del"
               style: "margin-left:5px; float:left;"
               title: @.grid_del_row_title()
               mouseover: -> $(this).addClass('ui-state-hover')
               mouseout:  -> $(this).removeClass('ui-state-hover')
               click: (e) =>
                 rowID = $(e.target).closest("tr.jqgrow").attr("id")
                 @.grid_del_row( rowID )
             )
             .append('<span class="ui-icon ui-icon-trash"></span>')
             .appendTo( element )

  jgrid_addGridRow: =>
    window.location.href = @.grid_resource_url() + '/new'

  grid_del_row: (rowID) =>
    $.jgrid.del.caption = "Delete Row"
    $.jgrid.del.msg = "Are you sure, rowid =" + rowID + "?"
    @.grid().delGridRow( rowID, $.extend( @.grid_del_path( rowID ), { reloadAfterSubmit: true } ) )

  grid_edit_row: (rowID) =>
    window.location.href = @.grid_resource_url() + "/" + rowID + "/edit" 




