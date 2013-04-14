redis = require("redis")


exports.index = (req, res) ->
  res.render("admin/department")

exports.usersIndex = (req, res) ->
  res.render("admin/users")

exports.createUser = (req, res) ->
  userName = req.body.userName
  password = req.body.password

  client = redis.createClient();
  client.incr("next_user_id", (err, reply)->
    client.hset("users", "#{reply}:user_name", userName)
    client.hset("users", "#{reply}:password", password)
    client.hset("users", "#{userName}:user_id", reply)
    client.quit())

  # 1表示成功，0表示失败
  res.send(1)