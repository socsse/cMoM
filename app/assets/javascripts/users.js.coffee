
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


class UsersGrid extends cMoMGridObject

  grid_json_id: -> 'user.id'

  jgrid_caption: -> 'Users'



