redis = require("redis")
{Response} = require('../vo/response')

exports.createUser = (userName, password, departmentId, superiorId, callback) ->
  client = redis.createClient();
  client.incr("next_user_id", (err, reply)->
    userId = reply
    replycallback =  (err, reply)->
      client.quit()
      if superiorId
        data = {id: userId, userName:userName, departmentId:departmentId, superiorId:superiorId}
      else
        data = {id: userId, userName:userName, departmentId:departmentId}

      callback(new Response(1,'success',data))

    if superiorId
      client.hmset("users", "#{reply}:user_name", userName, "#{reply}:password", password, "#{reply}:department_id", departmentId, "#{reply}:superior_id", superiorId, replycallback)
    else
      client.hmset("users", "#{reply}:user_name", userName, "#{reply}:password", password, "#{reply}:department_id", departmentId, replycallback)
  )

exports.getAllUsers = (callback) ->
  client = redis.createClient();
  client.hgetall("users", (err, reply)->
    client.quit()
    callback(new Response(1, "success",reply)))
