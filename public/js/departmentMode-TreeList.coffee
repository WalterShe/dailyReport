
#树形列表----------------------------------------------------------------------------------
class TreeList

  constructor: (@containerNode, @dataSource=null)->
    @editingItem = null

    $(@containerNode).addClass("treeList")

    $(@containerNode).on("mouseenter", "li div", (event)->
      $(@).addClass('treeListItemOver') unless $(this) == @editingItem)

    $(@containerNode).on("mouseleave", "li div", (event)->
      $(@).removeClass('treeListItemOver') unless $(this) == @editingItem)

    $(@containerNode).on("click", "span.update", (event)=>
       t = $(event.target)
       t.parent().removeClass('treeListItemOver').addClass('treeListItemSelected')
       t.hide();
       if @editingItem
         @editingItem.parent().removeClass('treeListItemSelected')
         @editingItem.show()
       @editingItem = t
       updateEvent = jQuery.Event("update")
       updateEvent["itemId"] = t.parent().attr('id')
       $(@containerNode).trigger(updateEvent))

    $(@containerNode).on("click", "span.delete", (event)=>
      t = $(event.target)
      deleteEvent = jQuery.Event("delete")
      deleteEvent["itemId"] = t.parent().attr('id')
      $(@containerNode).trigger(deleteEvent))

    $(@containerNode).on("click", "li i.icon-plus", (event)->
      event.stopImmediatePropagation()
      $(@).addClass('icon-minus').removeClass('icon-plus'))

    $(@containerNode).on("click", "li i.icon-minus", (event)->
      event.stopImmediatePropagation()
      $(@).addClass('icon-plus').removeClass('icon-minus'))

  show: (@dataSource)->
    $(@containerNode).empty()
    @renderTree(@containerNode, @getDepartTreeData())

  showEditingItem: ->
    return unless  @editingItem
    console.log  @editingItem
    @editingItem.parent().removeClass('treeListItemSelected')
    @editingItem.show()
    @editingItem = null

  getEditingItemId: ->
    return null unless  @editingItem
    @editingItem.parent().attr('id')

  # render a tree
  renderTree: (node, data)->
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
  getDepartTreeData: ->
    departs = @dataSource
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

window.TreeList = TreeList

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