treeList = new TreeList("#usersTree")

# user model层，处理数据调用和解析 ---------------------------------------------------------------
class UserModel

  @createUser: (data, callback)->
    $.post("/admin/createuser", data,
      (response)->
        user = response.data
        console.log user
        user["name"] = user["userName"]
        delete user["userName"]
        if user["superiorId"]
          user["pid"] = user["superiorId"]
          delete user["superiorId"]
        response.data = user
        UserModel.allUsers.push(user)
        callback(response)
    , "json")

  @removeUser: (data, callback)->
    $.post("/admin/removeuser", data,
      (response)->
        users = UserModel.parseUsers(response.data)
        response.data = users
        UserModel.allUsers = users
        callback(response)
    , "json")

  @getAllUsers: (callback)->
    $.post("/admin/getallusers",(response)->
      users = UserModel.parseUsers(response.data)
      response.data = users
      UserModel.allUsers = users
      callback(response)
    , "json")

  @allUsers: []

  @getLocalAllUsers: ->
    @allUsers


  # data 后台返回数据  	Object { 1:user_name="walter", 1:department_id="7", 1:superior_id:"3"}
  @parseUsers: (data)->

    resultObj = {} #Object { 1:{id:1, name:"walter",pid:"3", departmentId:"7"}}
    for key, value of data
      childOfKey = key.split(":")
      userId = childOfKey[0]
      resultObj[userId] ?= {id: userId}
      if childOfKey[1] == "user_name"
        resultObj[userId]["name"] = value
      else if childOfKey[1] == "department_id"
        resultObj[userId]["departmentId"] = value
      else if childOfKey[1] == "superior_id"
        resultObj[userId]["pid"] = value

    result = []
    for key2, value2 of resultObj
      result.push(value2)

    # h该函数输出数据 [{id:1, name:"walter",pid:"3", departmentId:"7"}]
    result

#  -----------------------------------------------------------------------------------------------
UserViewModel = ->
  self = @
  self.userName = ko.observable('')
  self.password = ko.observable('1234567')
  self.repassword = ko.observable('1234567')
  self.validUserName = ko.computed(->
    un = $.trim(self.userName())
    un.length >= 6 and un.length<=25)

  self.validPassword = ko.computed(->
    pw = $.trim(self.password())
    pw.length >= 7 and pw.length<=25)

  self.validRePassword = ko.computed(->
    $.trim(self.password()) ==  $.trim(self.repassword()))

  self.departments = ko.observableArray([])
  self.selectedDepartment = ko.observable(null)

  self.superiors = ko.observableArray([])
  self.selectedSuperior = ko.observable(null)

  self.valid = ko.computed(->
    self.selectedDepartment()? and self.validUserName() and self.validPassword() and self.validRePassword())

  self.submit = ->
    if self.valid()
      data = {userName: $.trim(self.userName()), password:$.trim(self.password()),
      departmentId:self.selectedDepartment()?["id"], superiorId:self.selectedSuperior()?["id"]}
      UserModel.createUser(data, (response)->
        newUser = response.data
        self.superiors.push(newUser)
        treeList.show(UserModel.getLocalAllUsers()))
    else
      alert("creation fail.")

  self.createNewUser = (userName, password)->

  self


# 初始化 ----------------------------------------------------------------------------
init = ->
  uservm = new UserViewModel();
  ko.applyBindings(uservm)

  DepartmemtModel.getAllDepartments((response)->
    uservm.departments(response.data))

  UserModel.getAllUsers((response)->
    users = response.data
    treeList.show(users))

  $("#usersTree").on("delete", (event)->
    UserModel.removeUser({userId:event["itemId"]}, (response)->
      treeList.show(response["data"])))

  $("#userDepartment").change( ->
    departmentId = uservm.selectedDepartment()?['id']
    if departmentId
      UserModel.getAllUsers((response)->
        users = response.data
        superiors = getUsersAndSuperiosByDepartmentId(departmentId, users, uservm.departments())
        uservm.superiors(superiors))
    else
      uservm.superiors([])
    )

  #根据部门Id获取该部门和上级部门所有成员
  getUsersAndSuperiosByDepartmentId = (departmentId, allUsers, allDepartments)->
    result = getUsersByDepartmentId(departmentId, allUsers)
    for department in allDepartments
      if departmentId == department["id"]
        pid =  department["pid"]
        pusers = getUsersByDepartmentId(pid, allUsers)
        return result.concat(pusers)

  #根据部门Id获取该部门所有成员
  getUsersByDepartmentId = (departmentId, allUsers)->
    result = []
    return result unless departmentId

    for user in allUsers
      result.push(user) if departmentId == user["departmentId"]
    result

init()