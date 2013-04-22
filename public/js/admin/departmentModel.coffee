
# department model层，处理数据调用和解析 ---------------------------------------------------------------
class DepartmemtModel

  @getAllDepartments: (callback)->
    $.get("/admin/alldepartments",
         (response)->
           departments = DepartmemtModel.parseDepartments(response.data)
           response['data'] = departments
           callback(response)
         , "json")
  # data 后台返回数据  	Object { 1:name="PHP", 2:name="IOS", 3:name="p2", 3:pid="1"}
  # 输出数据 Object { 1:{id:1, name:"PHP"}, 2:{id:2, name:"ios"},3:{id:3, name:"p2", pid:"1"}}
  @parseDepartments: (data)->
    resultObj = {}
    for key, value of data
      childOfKey = key.split(":")
      departmentId = childOfKey[0]
      resultObj[departmentId] ?= {id: departmentId}
      if childOfKey[1] == "name"
        resultObj[departmentId]["name"] = value
      else if childOfKey[1] == "pid"
        resultObj[departmentId]["pid"] = value

    result = []
    for key2, value2 of resultObj
      result.push(value2)

    # h该函数输出数据 [{id:1, name:"PHP"}, {id:2, name:"ios"},{id:3, name:"p2", pid:"1"}]
    result

  @createNewDepartment: (data, callback)->
    $.post("/admin/createDepartment", data,
        (response)->
          callback(response)
        , "json")

  @updateDepartment: (data, callback)->
    $.post("/admin/updatedepartment", data,
          (response)->
            departments = DepartmemtModel.parseDepartments(response.data)
            response['data'] = departments
            callback(response)
          , "json")

  @removeDepartment: (data, callback)->
    $.post("/admin/removedepartment", data,
         (response)->
           departments = DepartmemtModel.parseDepartments(response.data)
           response.data = departments
           callback(response)
         , "json")

window.DepartmemtModel = DepartmemtModel