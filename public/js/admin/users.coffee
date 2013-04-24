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
    $.get("/admin/getallusers",(response)->
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

  self.updateUser = ko.observable(null)

  self.userName1 = ko.observable('')
  self.password1 = ko.observable('')
  self.repassword1 = ko.observable('')
  self.validUserName1 = ko.computed(->
    un = $.trim(self.userName1())
    un.length >= 6 and un.length<=25)

  self.validPassword1 = ko.computed(->
    pw = $.trim(self.password1())
    pw.length >= 7 and pw.length<=25)

  self.validRePassword1 = ko.computed(->
    $.trim(self.password1()) ==  $.trim(self.repassword1()))

  self.selectedDepartment1 = ko.observable(null)

  self.superiors1 = ko.observableArray([])
  self.selectedSuperior1 = ko.observable(null)

  self.valid1 = ko.computed(->
    self.selectedDepartment1()? and self.validUserName1() and self.validPassword1() and self.validRePassword1())
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
    setSuperiorsByDepartmentId(departmentId))

  setSuperiorsByDepartmentId = (departmentId)->
    if departmentId
      UserModel.getAllUsers((response)->
        users = response.data
        superiors = getUsersAndSuperiosByDepartmentId(departmentId, users, uservm.departments())
        setSuperiors(superiors) )
    else
      setSuperiors([])

  setSuperiors = (superiors)->
     if isEditing
       uservm.superiors1(superiors)
     else
       uservm.superiors(superiors)

  isEditing = ->
    uservm.updateUser() ? true : false


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

  $("#usersTree").on("update", (event)->
    userId = event["itemId"]
    user =  finduser(userId)
    uservm.updateUser(user)
    uservm.userName1(user["name"])
    selectedDepartment = getDepartmentByUserId(userId, UserModel.getLocalAllUsers(), uservm.departments())
    uservm.selectedDepartment1(selectedDepartment)
    setSuperiorsByDepartmentId(selectedDepartment["id"]))

  finduser = (userId)->
    users = UserModel.getLocalAllUsers()
    for user in users
      if (user['id'] == userId)
        return user

  #根据用户Id获取该用户所在部门
  getDepartmentByUserId = (userId, allUsers, departments)->
    allUsers = UserModel.getLocalAllUsers()
    departmentId = null
    for user in allUsers
      if userId == user["id"]
        departmentId = user["departmentId"]
        break
    for department in departments
      return department if department["id"] == departmentId
    null

init()