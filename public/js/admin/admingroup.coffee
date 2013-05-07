
#  -----------------------------------------------------------------------------------------------
AdminGroupViewModel = ->
  self = @

  self.departments = ko.observableArray([])
  self.selectedDepartment = ko.observable(null)

  self.users = ko.observableArray([])
  self.selectedUser = ko.observable(null)

  self.valid = ko.computed(->
    self.selectedDepartment()? and self.selectedUser())

  self.submit = ->
    console.log self.selectedUser()

  self


# 初始化 ----------------------------------------------------------------------------
init = ->
  adminvm = new AdminGroupViewModel()
  ko.applyBindings(adminvm)

  DepartmemtModel.getAllDepartments((response)->
    adminvm.departments(response.data))

  UserModel.getAllUsers((response)->
    users = response.data )

    #treeList.show(users))
  $("#depar").change( ->
    departmentId = adminvm.selectedDepartment()?['id']
    users = UserModel.getLocalAllUsers()
    departmentUsers = getUsersByDepartmentId(departmentId, users)
    adminvm.users(departmentUsers))

  #根据部门Id获取该部门所有成员
  getUsersByDepartmentId = (departmentId, allUsers)->
    result = []
    return result unless departmentId

    for user in allUsers
      result.push(user) if departmentId == user["departmentId"]
    result

init()