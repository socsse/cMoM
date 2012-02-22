class this.cMoMGridObject

  constructor: ->
    @csrf_token    = $('meta[ name="csrf-token" ]').attr( 'content' )
    @.setup_grid()
    @.setup_events()

  resize_handler: (event) =>
    # use fudge factor to prevent horizontal scrollbars
    width = @.grid_container().width() - 2

    if (width > 0 && Math.abs( width - @grid().width()) > 5)
      @grid().setGridWidth( width )
    false

  setup_events: =>
    $(window).resize @resize_handler

  setup_grid_btns_model: =>
    [
      { 
        name: 'actions'
        index: 'actions'
        width: 55
        align: 'center'
        resizable: false
        sortable: false
        search: false 
        formatter: 'actions'
      }
    ]

  grid_data_model: => []

  grid:           => $('#grid')
  grid_container: => $('#grid_container')
  grid_pager:     => $(@.grid_pager_id())
  grid_pager_id:  => '#grid_pager'

  grid_json_url:  -> ''
  grid_json_id:   -> 'id'
  grid_json_rows: -> 'rows'

  grid_resource_url: -> ''

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
      pager:       @.grid_pager()
      rowList:     @.jgrid_rowList()
      rowNum:      @.jgrid_rowNum()
      sortname:    @.jgrid_sortname()
      sortorder:   @.jgrid_sortorder()
      viewrecords: true
      addGridRow: @.jgrid_addGridRow
      beforeSelectRow: @.jgrid_beforeSelectRow
      editGridRow: @.jgrid_editGridRow
      onSelectRow: @.jgrid_onSelectRow
    )
    @.grid().jqGrid( 'navGrid', @.grid_pager_id(), { add:false, edit:false, del:false })
    @.grid().jqGrid( 'gridResize' )
    true

  jgrid_beforeSelectRow: (rowid, e) =>
    column_id = $.jgrid.getCellIndex( e.target )
    if (column_id == 0)
      $.jgrid.del.msg = 'Are you sure, rowid='+rowid+'?'
      @.grid().delGridRow( rowid, $.extend( { reloadAfterSubmit: true }, @.destroy_path( rowid ) ) )
      return false
    true

  jgrid_addGridRow: =>
    window.location.href = @.grid_resource_url() + '/new'

  jgrid_editGridRow: (id, properties) =>
    if (rowid == 'new')
      window.location.href = @.grid_resource_url()
    else
      window.location.href = @.grid_resoruce_url() + '/' + id

  jgrid_onSelectRow: (id) =>
    window.location.href = @.grid_resource_url() + '/' + id

  destroy_path: (id) =>
    url: @.grid_resource_url() + '/' + id
    mtype: 'DELETE'
    delData: { authenticity_token: @csrf_token }


