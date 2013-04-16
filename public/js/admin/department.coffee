
departmentViewModel = ->
  self = @
  self.departmentName = ko.observable('')
  self.validDepartmentName = ko.computed(->
      $.trim(self.departmentName()).length >= 1)

  self.departments = ko.observableArray([{name:'PHP', id:1},{name:'Tec Center', id:2, pid:1},{name:'ios',id:3,pid:1},{name:'Product', id:4}])
  self.selectedParentDepartment = ko.observable(null)
  self.submit = ->
    if self.validDepartmentName()
      data = {departmentName: self.departmentName(), pid: self.selectedParentDepartment()["id"]}
      $.post("/admin/createDepartment", data,
          (data)->
            alert(data.message)
          , "json")

  self

ko.applyBindings(new departmentViewModel())

#$("#parentDepartment").change(->alert(vm.selectedParentDepartment()["id"]))