
UserViewModel = ->
  self = @
  self.userName = ko.observable('')
  self.password = ko.observable('')
  self.repassword = ko.observable('')
  self.validUserName = ko.computed(->
    un = $.trim(self.userName())
    un.length >= 6 and un.length<=25)

  self.validPassword = ko.computed(->
    pw = $.trim(self.password())
    pw.length >= 7 and pw.length<=25)

  self.validRePassword = ko.computed(->
    $.trim(self.password()) ==  $.trim(self.repassword()))

  self.valid = ko.computed(->
    self.selectedDepartment and self.selectedSuperior and self.validUserName() and self.validPassword() and self.validRePassword())

  self.departments = ko.observableArray([])
  self.selectedDepartment = ko.observable(null)

  self.superiors = ko.observableArray([])
  self.selectedSuperior = ko.observable(null)

  self.submit = ->
    if self.valid()
      self.createNewUser(self.userName(), self.password())
    else
      alert("uname:#{self.userName()}, validun:#{self.validUserName()}")

  self.createNewUser = (userName, password)->
    $.post("/admin/createUsers", { userName: userName, password:password },
        (data)->
          alert(data.message)
        , "json")

  self


# 初始化 ----------------------------------------------------------------------------
init = ->
  uservm = new UserViewModel();
  ko.applyBindings(uservm)

init()