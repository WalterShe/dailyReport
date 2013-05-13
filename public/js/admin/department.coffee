treeList = new TreeList("#departmentTree")

#ViewModel---------------------------------------------------------------
DepartmentViewModel = ->
  self = @
  self.departmentName = ko.observable('')
  self.updateDepartmentName = ko.observable('')
  self.validDepartmentName = ko.computed(->
    dname = $.trim(self.departmentName())
    dname.length >= 1 and dname.indexOf(":") == -1)

  self.validUpdateDepartmentName = ko.computed(->
    dname = $.trim(self.updateDepartmentName())
    dname.length >= 1 and dname.indexOf(":") == -1)

  self.updateDepartment = ko.observable(null)

  #self.departments = ko.observableArray([{name:'无', id:null},{name:'PHP', id:1},{name:'Tec Center', id:2, pid:1},{name:'ios',id:3,pid:1},{name:'Product', id:4}])
  self.departments = ko.observableArray(null);

  self.selectedParentDepartment = ko.observable(null)
  self.submit = ->
    if self.validDepartmentName()
      data = {departmentName: $.trim(self.departmentName()), pid: self.selectedParentDepartment()?["id"]}
      DepartmemtModel.createNewDepartment(data, (response)->
        return if response.state == 0
        self.departments.push(response.data)
        treeList.show(self.departments()) )

  self


# 初始化 ----------------------------------------------------------------------------
init = ->
  departmentvm = new DepartmentViewModel()
  ko.applyBindings(departmentvm)

  $("#departmentTree").on("update", (event)->
    departmentId = event["itemId"]
    department = findDepartment(departmentId)
    departmentvm.updateDepartment(department)
    departmentvm.updateDepartmentName(department['name'])
    departmentvm.selectedParentDepartment(findParentDepartment(department)))

  findDepartment = (departmentId)->
    departments = departmentvm.departments()
    for department in departments
      if (department['id'] == departmentId)
        return department

  findParentDepartment = (department)->
    pid = department["pid"]
    if pid
      departments = departmentvm.departments()
      for department in departments
        if (department['id'] == pid)
          return department
    return null

  $("#cancelUpdateBtn").click( ->
    cancelUpdateDepartment())

  cancelUpdateDepartment = ->
    treeList.showEditingItem()
    departmentvm.updateDepartment(null)

  $("#updateBtn").click( ->
    departmentId = treeList.getEditingItemId()
    data = {departmentId:departmentId, departmentName:departmentvm.updateDepartmentName(), pid: departmentvm.selectedParentDepartment()?["id"]}
    DepartmemtModel.updateDepartment(data,(response)->
      return if response.state == 0
      cancelUpdateDepartment()
      departmentvm.departments(response["data"])
      treeList.show(response["data"])))


  $("#departmentTree").on("delete", (event)->
    DepartmemtModel.removeDepartment({departmentId:event["itemId"]}, (response)->
      return if response.state == 0
      departmentvm.departments(response.data)
      treeList.show(response["data"]))
    )

  DepartmemtModel.getAllDepartments((response)->
    return if response.state == 0
    departmentvm.departments(response.data)
    treeList.show(response["data"]))

init()