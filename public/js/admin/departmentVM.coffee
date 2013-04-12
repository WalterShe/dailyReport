
window.DepartmentViewModel = ->
  self = @
  self.hello = ko.observable('hello')
  self.departments = ko.observableArray([{name:'PHP', id:1},{name:'Tec Center', id:2, pid:1},{name:'ios',id:3,pid:1},{name:'Product', id:4}])
  self.selectedParentDepartment = ko.observable(null)


  self
