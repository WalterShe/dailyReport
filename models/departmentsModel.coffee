redis = require("redis")

exports.createDepartment = (departmentName, parentId, callback) ->
  client = redis.createClient();
  console.log "departmentName:#{departmentName}, parentId:#{parentId}"

  client.incr("next_department_id", (err, reply)->
    client.hset("departments", "#{reply}:name", departmentName)
    result = {name:departmentName}
    if parentId
      client.hset("departments", "#{reply}:pid", parentId)
      result["pid"] = parentId

    client.quit()
    response = {
      state: 1
      message: 'success'
      data: reply}

    callback(response) if callback  )


exports.getAllDepartments = (callback) ->
  client = redis.createClient();
  client.hgetall("departments", (err, reply)->
    client.quit()
    response = {
    state: 1
    message: 'success'
    data: reply
    }
    callback(response) if callback  )