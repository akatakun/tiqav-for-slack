module.exports = (robot) ->
  robot.hear /getr/i, (msg) ->
    request = msg.http('http://api.tiqav.com/search/random.json').get()
    request (err, res, body) ->
      json = JSON.parse body
      if json.length > 0
        msg.send "http://img.tiqav.com/#{json[0].id}.#{json[0].ext}"

  robot.hear /(.*) gets/i, (msg) ->
    keyword = encodeURIComponent msg.match[1]
    request = msg.http('http://api.tiqav.com/search.json').query(q: keyword).get()
    request (err, res, body) ->
      json = JSON.parse body
      if json.length > 0
        msg.send "http://img.tiqav.com/#{json[0].id}.#{json[0].ext}"
