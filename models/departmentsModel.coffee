redis = require("redis")
{Response} = require('../vo/response')

exports.createDepartment = (departmentName, parentId, callback) ->
  client = redis.createClient();
  #console.log "departmentName:#{departmentName}, parentId:#{parentId}"

  client.incr("next_department_id", (err, reply)->
    client.hset("departments", "#{reply}:name", departmentName)
    result = {name:departmentName}
    #id 以字符串形式返回
    department = {name:departmentName, id:"#{reply}"}
    if parentId
      client.hset("departments", "#{reply}:pid", parentId)
      result["pid"] = parentId
      department["pid"] = parentId

    client.quit()

    callback(new Response(1,'success',department)) if callback  )

#删除部门
exports.removeDepartment = (departmentId, callback) ->
  client = redis.createClient();
  client.hdel("departments", "#{departmentId}:name", "#{departmentId}:pid", (err, reply)->
    client.hgetall("departments", (err, reply)->
      newDepartments = {}
      for key, value of reply
        childOfKey = key.split(":")
        if childOfKey[1] == "pid" and value == departmentId
          client.hdel("departments", key)
        else
          newDepartments[key] = value

      callback(new Response(1,'success',newDepartments)))

    # 该部门用户的部门属性清除
    client.hgetall("users", (err, reply)->
      users = reply
      for key, value of users
        childOfKey = key.split(":")
        if childOfKey[1] == "department_id" and value == departmentId
          client.hdel("users", key) )
  )

#更新部门
exports.updateDepartment = (departmentId, departmentName, parentId, callback) ->
  client = redis.createClient();

  replycallback =  (err, reply)->
    client.hgetall("departments", (err, reply)->
       client.quit()
       callback(new Response(1,'success',reply)))

  if parentId
    client.hmset("departments", "#{departmentId}:name", departmentName, "#{departmentId}:pid", parentId, replycallback)
  else
    client.hset("departments", "#{departmentId}:name", departmentName, replycallback)

exports.getAllDepartments = (callback) ->
  client = redis.createClient();
  client.hgetall("departments", (err, reply)->
    client.quit()
    callback(new Response(1,'success',reply)) if callback  )