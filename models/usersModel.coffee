redis = require("redis")
{Response} = require('../vo/response')

exports.createUser = (userName, password, departmentId, superiorId, callback) ->
  client = redis.createClient();
  client.incr("next_user_id", (err, reply)->
    userId = "#{reply}"
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

exports.updateUser = (userId, userName, password, departmentId, superiorId, callback) ->
  client = redis.createClient();

  replycallback =  (err, reply)->
    client.hgetall("users", (err, reply)->
       client.quit()
       users = getUsersWithoutPassword(reply)
       callback(new Response(1, "success",users)))

  if (superiorId and password)
    client.hmset("users", "#{userId}:user_name", userName, "#{userId}:password", password, "#{userId}:department_id", departmentId, "#{userId}:superior_id", superiorId, replycallback)
  else if superiorId
    client.hmset("users", "#{userId}:user_name", userName, "#{userId}:department_id", departmentId, "#{userId}:superior_id", superiorId, replycallback)
  else if password
    client.hmset("users", "#{userId}:user_name", userName, "#{userId}:password", password, "#{userId}:department_id", departmentId, replycallback)
  else
    client.hmset("users", "#{userId}:user_name", userName, "#{userId}:department_id", departmentId, replycallback)


exports.getAllUsers = (callback) ->
  client = redis.createClient();
  client.hgetall("users", (err, reply)->
    client.quit()
    users = getUsersWithoutPassword(reply)
    callback(new Response(1, "success",users)))

exports.getAllUsersWithPassword = (callback) ->
  client = redis.createClient();
  client.hgetall("users", (err, users)->
    client.quit()
    callback(new Response(1, "success",users)))

exports.removeUser = (userId, callback) ->
  client = redis.createClient();
  client.hdel("users", "#{userId}:user_name", "#{userId}:password", "#{userId}:department_id", "#{userId}:superior_id", (err, reply)->
    client.hgetall("users", (err, reply)->
      newUsers = getUsersWithoutPassword(reply)
      for key, value of newUsers
        childOfKey = key.split(":")
        if childOfKey[1] == "superior_id" and value == userId
          client.hdel("users", key)
        else
          newUsers[key] = value
      client.quit()

      callback(new Response(1, "success",newUsers))))

# 将用户数据中的密s码信息过滤掉
getUsersWithoutPassword = (users)->
  filterUsers = {}
  for key, value of users
    childOfKey = key.split(":")
    filterUsers[key] = value unless childOfKey[1] == "password"

  filterUsers

# 查看某个用户（userId）是否有下属
exports.hasSubordinate = (userId, callback) ->
  client = redis.createClient();
  client.hgetall("users", (err, users)->
    result = false
    for key, value of users
      childOfKey = key.split(":")
      if childOfKey[1] == "superior_id" and value == userId
        result = true
        console.log result
        break
    client.quit()
    console.log result
    callback(result))