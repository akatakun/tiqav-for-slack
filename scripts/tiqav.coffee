shuffle = (array) ->
  # For clone
  arr = array.slice()
  i = arr.length
  while --i
    j = Math.floor(Math.random() * (i + 1))
    tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp
  arr

filter_with_blacklist = (array) ->
  blacklist = [
    'pbs.twimg.com',
  ]
  array.filter (a) ->
    !blacklist.some (b) ->
      (new RegExp(b)).test a.link

# Avoid to be cached same url image by Slack
get_timestamp = () ->
  (new Date()).toISOString().replace(/[^0-9]/g, '')


send_with_tiqav = (msg, path, query = {}) ->
  msg.http(path).query(query).get() (err, res, body) ->
    json = JSON.parse body
    if json.length > 0
      items = shuffle json
      msg.send "http://img.tiqav.com/#{items[0].id}.th.#{items[0].ext}?#{get_timestamp()}"


send_with_google = (msg, path, query = {}, index) ->
  msg.http(path).query(query).get() (err, res, body) ->
    json = JSON.parse body
    if json.items.length > 0
      items = json.items
      items = filter_with_blacklist items
      if typeof index == 'undefined'
        items = shuffle items.slice(0, 3)
        item  = items[0]
      else
        item  = json.items[index]
      msg.send "#{item.link}?#{get_timestamp()}"


module.exports = (robot) ->
  robot.hear /(.*?) tr/i, (msg) ->
    send_with_tiqav msg, 'http://api.tiqav.com/search/random.json'

  robot.hear /(.*?) ts/i, (msg) ->
    keyword = msg.match[1]
    send_with_tiqav msg, 'http://api.tiqav.com/search.json', {q: keyword}

  robot.hear /(.*?) gs ?(.*)/i, (msg) ->
    keyword = msg.match[1]
    options = msg.match[2]
    type  = 'gray'
    if options
      m = options.match /-t ?(\w+)/
      type  = 'color'      if m and m[1] == 'c'
      m = options.match /-i ?(\d+)/
      index = Number(m[1]) if m and m[1]
    send_with_google msg, 'https://www.googleapis.com/customsearch/v1', {key: process.env.GCS_KEY, cx: process.env.GCSE_ID, q: keyword, searchType: 'image', imgColorType: type, safe: 'high'}, index
