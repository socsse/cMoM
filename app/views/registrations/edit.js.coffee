$("#edit-dialog").dialog
  autoOpen: true
  modal: true
  width:  'auto'
  height: 'auto'
  title: "Edit Account Info"
  buttons: 
    [
      {
        text: "OK"
        click: ->
          $("#user_edit").submit()
      }
      {
        text: "Cancel"
        click: ->
          $(this).dialog("close")
      }
    ]
  create: ->
    $("#edit-dialog").html("<%= escape_javascript(render('form')) %>")
  
