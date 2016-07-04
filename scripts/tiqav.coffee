shuffle = (arr) ->
  arr = arr.slice()
  i = arr.length
  if i == 0
    return arr
  while --i
    j = Math.floor(Math.random() * (i + 1))
    tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp
  arr

translate_ng_words = (msg) ->
  ng_words = [
    'ざける',
    'ザケル',
  ]
  if ng_words.indexOf(msg) < 0 then msg else 'よつばと'

module.exports = (robot) ->
  # Avoid caches of Slack
  timestamp = (new Date()).toISOString().replace(/[^0-9]/g, '')

  robot.hear /getr/i, (msg) ->
    request = msg.http('http://api.tiqav.com/search/random.json').get()
    request (err, res, body) ->
      json = JSON.parse body
      if json.length > 0
        json = shuffle json
        msg.send "http://img.tiqav.com/#{json[0].id}.th.#{json[0].ext}?#{timestamp}"

  robot.hear /(.*?) gets/i, (msg) ->
    keyword = translate_ng_words msg.match[1]
    request = msg.http('http://api.tiqav.com/search.json').query(q: keyword).get()
    request (err, res, body) ->
      json = JSON.parse body
      if json.length > 0
        json = shuffle json
        msg.send "http://img.tiqav.com/#{json[0].id}.th.#{json[0].ext}?#{timestamp}"
