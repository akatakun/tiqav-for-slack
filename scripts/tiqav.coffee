module.exports = (robot) ->
  robot.hear /random image/i, (msg) ->
    request = msg.http('http://api.tiqav.com/search/random.json').get()
    request (err, res, body) ->
      json = JSON.parse body
      msg.send json[0].source_url if json.length > 0

  robot.hear /image/i, (msg) ->
    keyword = encodeURIComponent msg.match[1]
    request = msg.http('http://api.tiqav.com/search.json').query(q: keyword).get()
    request (err, res, body) ->
      json = JSON.parse body
      msg.send json[0].source_url if json.length > 0
