redis = require("redis")


exports.createDepartment = (departmentName, parentId, callback) ->
  client = redis.createClient();
  ###
  client.incr("next_user_id", (err, reply)->
    client.hset("users", "#{reply}:user_name", userName)
    client.hset("users", "#{reply}:password", password)
    client.hset("users", "#{userName}:user_id", reply)
    client.quit()
    response = {
      state: 1
      message: 'success'
    }
    callback(response) if callback )###