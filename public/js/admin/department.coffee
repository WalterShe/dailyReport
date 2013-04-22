
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
      data = {departmentName: self.departmentName(), pid: self.selectedParentDepartment()?["id"]}
      DepartmemtModel.createNewDepartment(data, (response)->
        self.departments.push(response.data)
        TreeList.showTree("#departmentTree", self.departments()))

  self


# 初始化 ----------------------------------------------------------------------------
init = ->
  departmentvm = new DepartmentViewModel();
  ko.applyBindings(departmentvm)

  editingDepartment = null

  $("#departmentTree").on("mouseenter", "li div", (event)->
    $(@).addClass('on') unless $(this)==editingDepartment)

  $("#departmentTree").on("mouseleave", "li div", (event)->
    $(@).removeClass('on') unless $(this)==editingDepartment)

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

  $("#departmentTree").on("click", "span.update", ->
    t = $(@)
    t.parent().removeClass('on').addClass('selected')
    t.hide();
    if editingDepartment
      editingDepartment.parent().removeClass('selected')
      editingDepartment.show()
    editingDepartment = t
    departmentId = t.parent().attr('id')
    department =  findDepartment(departmentId)
    departmentvm.updateDepartment(department)
    departmentvm.updateDepartmentName(department['name'])
    departmentvm.selectedParentDepartment(findParentDepartment(department))
    )

  $("#cancelUpdateBtn").click( ->
    cancelUpdateDepartment())

  cancelUpdateDepartment = ->
    editingDepartment.parent().removeClass('selected')
    editingDepartment.show()
    editingDepartment = null
    departmentvm.updateDepartment(null)

  $("#updateBtn").click( ->
    departmentId = editingDepartment.parent().attr('id')
    data = {departmentId:departmentId, departmentName:departmentvm.updateDepartmentName(), pid: departmentvm.selectedParentDepartment()?["id"]}
    DepartmemtModel.updateDepartment(data,(response)->
      cancelUpdateDepartment()
      departmentvm.departments(response["data"])
      TreeList.showTree("#departmentTree", response["data"])))


  $("#departmentTree").on("click", "span.delete", (event)->
    t = $(event.target)
    departmentId = t.parent().attr('id')
    DepartmemtModel.removeDepartment({departmentId:departmentId}, (response)->
      departmentvm.departments(response.data)
      TreeList.showTree("#departmentTree", response.data))
    )

  $("#departmentTree").on("click", "li i.icon-plus", (event)->
    t = $(event.target)
    event.stopImmediatePropagation()
    t.addClass('icon-minus').removeClass('icon-plus'))

  $("#departmentTree").on("click", "li i.icon-minus", (event)->
    t = $(event.target)
    event.stopImmediatePropagation()
    t.addClass('icon-plus').removeClass('icon-minus'))

  DepartmemtModel.getAllDepartments((response)->
    departmentvm.departments(response.data)
    TreeList.showTree("#departmentTree", departmentvm.departments()))

init()


#树形列表----------------------------------------------------------------------------------
class TreeList
  @showTree: (nodeName, data)->
    @data = data
    $(nodeName).empty()
    @renderTree(nodeName, @getDepartTreeData())

  # render a tree
  @renderTree: (node, data)->
    $(node).append("<ul></ul>")
    newnode = "#{node} ul:first"
    for value in data
      linode = "<li id='#{value.id}node'><div id='#{value.id}'><span class='nodename'>#{value.label}</span><span class='delete btn btn-danger'>删除</span><span class='update btn btn-warning'>编辑</span></div></li>"
      if value.children
        linode = "<li id='#{value.id}node'><div id='#{value.id}'><i class='icon-minus' /><span class='nodename'>#{value.label}</span><span class='delete btn btn-danger'>删除</span><span class='update btn btn-warning'>编辑</span></div></li>"

      $(newnode).append(linode)
      newnode2 = "#{newnode} ##{value.id}node"
      if value.children
        @renderTree(newnode2, value.children)
    null

  # render a department tree
  @getDepartTreeData: ->
    departs = @data
    treeData = []
    for value in departs
      rootnode = {label:value.name, id:value.id};
      treeData.push(rootnode) unless value.pid

    findChidren = (node, departs)->
      for value in departs
        if value.pid == node.id
          node.children = [] unless node.children
          childNode = {label:value.name, id:value.id}
          node.children.push(childNode)
          findChidren(childNode, departs)

    for node in treeData
      findChidren(node, departs)

    treeData