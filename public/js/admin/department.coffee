
departmentViewModel = ->
  self = @
  self.departmentName = ko.observable('')
  self.validDepartmentName = ko.computed(->
      $.trim(self.departmentName()).length >= 1)

  #self.departments = ko.observableArray([{name:'无', id:null},{name:'PHP', id:1},{name:'Tec Center', id:2, pid:1},{name:'ios',id:3,pid:1},{name:'Product', id:4}])
  self.departments = ko.observableArray(null);

  self.selectedParentDepartment = ko.observable(null)
  self.submit = ->
    if self.validDepartmentName()
      data = {departmentName: self.departmentName(), pid: self.selectedParentDepartment()["id"]}
      $.post("/admin/createDepartment", data,
          (data)->
            alert(data.message)
            data
          , "json")

  self

departmentvm = new departmentViewModel();
ko.applyBindings(departmentvm)


init = ->
  $.get("/admin/alldepartments",
        (data)->
          departments = departmemtModel.getAllDepartments(data.data)
          console.log departments
          departmentvm.departments(departments)
          null
        , "json")

  null

init()

class departmemtModel
  # data 后台返回数据  	Object { 1:name="PHP", 2:name="IOS", 3:name="p2", 3:pid="1"}
  # 输出数据 Object { 1:{id:1, name:"PHP"}, 2:{id:2, name:"ios"},3:{id:3, name:"p2", pid:"1"}}
  @getAllDepartments: (data)->
    resultObj = {}
    for key, value of data
      childOfKey = key.split(":")
      departmentId = childOfKey[0]
      resultObj[departmentId] = {id: departmentId}
      if childOfKey[1] == "name"
        resultObj[departmentId]["name"] = value
      else if childOfKey[1] == "pid"
        resultObj[departmentId]["pid"] = value

    result = []
    for key2, value2 of resultObj
      result.push(value2)

    # h该函数输出数据 [{id:1, name:"PHP"}, {id:2, name:"ios"},{id:3, name:"p2", pid:"1"}]
    result