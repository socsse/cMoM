js_assets_require = (script) ->
  $.ajax
    url: "/assets/" + script,
    dataType: "script",
    async: false
    success: ->
      alert( "Test" )
    error: ->
      throw new Error( "Could not load script " + script );

js_assets_require "jquery_rest_pc.js"

dialog_html = "<%= escape_javascript render( :partial => 'form', :locals => { :user => @user, :chip => @chip, :uart => @uart, :buttons => false } ) %>"
$('#peripheral_dialog').html(dialog_html)

create_url = "<%= user_chip_uarts_path( @user, @chip ) %>"
$('#peripheral_dialog').dialog
  autoOpen: true
  modal: true,
  open: ->
    alert( $('#form.uart_form').validate())
  buttons:
    "Save": ->
      $.create(
        create_url
        $("#peripheral_dialog").serialize()
        (response) ->
          alert( "Test1" )
          window.grid_object.reload_grid()
          $(this).dialog( "close" )
        (response) ->
          alert( $('.uart_form').serialize() )
          alert( response )
      )
    "Cancel": ->
       $(this).dialog( "close" )
