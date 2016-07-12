url = require 'url'

blacklist_host = [
  'pbs.twimg.com',
]

filter_host = (array) ->
  # For clone
  array.filter (ele) ->
    u = url.parse ele
    !blacklist_host.includes(u.host)

shuffle = (array) ->
  arr = array.slice()
  i = arr.length
  while --i
    j = Math.floor(Math.random() * (i + 1))
    tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp
  arr

# Avoid to be cached same url image by Slack
get_timestamp = () ->
  (new Date()).toISOString().replace(/[^0-9]/g, '')


send_with_tiqav = (msg, path, query = {}) ->
  msg.http(path).query(query).get() (err, res, body) ->
    json = JSON.parse body
    if json.length > 0
      items = shuffle json
      msg.send "http://img.tiqav.com/#{items[0].id}.th.#{items[0].ext}?#{get_timestamp()}"


send_with_google = (msg, path, query = {}) ->
  msg.http(path).query(query).get() (err, res, body) ->
    json = JSON.parse body
    if json.items.length > 0
      links = json.items.map (ele) ->
        ele.link
      links = filter_host links
      links = links.slice 0, 3
      links = shuffle links
      msg.send "#{links[0]}?#{get_timestamp()}"


module.exports = (robot) ->
  robot.hear /(.*?) tr/i, (msg) ->
    send_with_tiqav msg, 'http://api.tiqav.com/search/random.json'

  robot.hear /(.*?) ts/i, (msg) ->
    keyword = msg.match[1]
    send_with_tiqav msg, 'http://api.tiqav.com/search.json', {q: keyword}

  robot.hear /(.*?) gs/i, (msg) ->
    keyword = msg.match[1]
    send_with_google msg, 'https://www.googleapis.com/customsearch/v1', {key: process.env.GCS_KEY, cx: process.env.GCSE_ID, q: keyword, searchType: 'image', imgColorType: 'gray', safe: 'high'}
