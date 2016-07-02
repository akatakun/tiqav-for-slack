module.exports = (robot) ->
  # Avoid caches of Slack
  timestamp = (new Date()).toISOString().replace(/[^0-9]/g, '')

  robot.hear /getr/i, (msg) ->
    request = msg.http('http://api.tiqav.com/search/random.json').get()
    request (err, res, body) ->
      json = JSON.parse body
      if json.length > 0
        msg.send "http://img.tiqav.com/#{json[0].id}.#{json[0].ext}?#{timestamp}"

  robot.hear /(.*?) gets/i, (msg) ->
    keyword = msg.match[1]
    request = msg.http('http://api.tiqav.com/search.json').query(q: keyword).get()
    request (err, res, body) ->
      json = JSON.parse body
      if json.length > 0
        msg.send "#{keyword}: #{json[0].id}.#{json[0].ext}"
        msg.send "http://img.tiqav.com/#{json[0].id}.#{json[0].ext}?#{timestamp}"
