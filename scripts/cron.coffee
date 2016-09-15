cron_job = require('cron').CronJob


module.exports = (robot) ->
  send = (room, msg) ->
    response = new robot.Response(robot, {user: {id: -1, name: room}, text: 'none', done: false}, [])
    response.send msg

  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cron_job('0 0 * * * *', () ->
    current_time = new Date
    send '#general', "current time is #{new Date().current_time.getHours()}:00"
  ).start()
