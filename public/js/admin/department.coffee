
# model层，处理数据调用和解析 ---------------------------------------------------------------
class DepartmemtModel

  @getAllDepartments: (callback)->
    $.get("/admin/alldepartments",
         (response)->
           departments = DepartmemtModel.parseDepartments(response.data)
           callback(departments)
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

#ViewModel---------------------------------------------------------------
DepartmentViewModel = ->
  self = @
  self.departmentName = ko.observable('')
  self.validDepartmentName = ko.computed(->
    dname = $.trim(self.departmentName())
    dname.length >= 1 and dname.indexOf(":") == -1)

  #self.departments = ko.observableArray([{name:'无', id:null},{name:'PHP', id:1},{name:'Tec Center', id:2, pid:1},{name:'ios',id:3,pid:1},{name:'Product', id:4}])
  self.departments = ko.observableArray(null);

  self.selectedParentDepartment = ko.observable(null)
  self.submit = ->
    if self.validDepartmentName()
      data = {departmentName: self.departmentName(), pid: self.selectedParentDepartment()?["id"]}
      $.post("/admin/createDepartment", data,
            (data)->
              console.log data
              self.departments.push(data.data)
              TreeList.showTree("#departmentTree", self.departments())
            , "json")

  self



# 初始化 ----------------------------------------------------------------------------
init = ->
  departmentvm = new DepartmentViewModel();
  ko.applyBindings(departmentvm)

  DepartmemtModel.getAllDepartments((departments)->
    departmentvm.departments(departments)
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
      linode = "<li id='#{value.id}node'><div id='#{value.id}'><span class='nodename'>#{value.label}</span><i class='delete icon-remove' /></div></li>"
      if value.children
        linode = "<li id='#{value.id}node'><div id='#{value.id}'><i class='icon-minus' /><span class='nodename'>#{value.label}</span><i class='delete icon-remove' /></div></li>"

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
      ""

    for node in treeData
      findChidren(node, departs)
    console.log treeData
    treeData