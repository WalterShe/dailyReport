LoginViewModel = ->
  self = @
  self.userName = ko.observable('')
  self.password = ko.observable('')

  self.validUserName = ko.computed(->
    un = $.trim(self.userName())
    un.length >= 2 and un.length<=25)

  self.validPassword = ko.computed(->
    pw = $.trim(self.password())
    pw.length >= 7 and pw.length<=25)

  self.errorTip =  ko.observable('')

  self.getErrorTip = ->
    unless self.validUserName()
      return self.errorTip("用户名长度为2-25个字符")

    unless self.validPassword()
      return  self.errorTip("密码长度为7-25个字符")

    self.errorTip("")

  self.valid = ko.computed(->
    self.validUserName() and self.validPassword())

  self.submit = ->
    if self.valid()
      data = {userName: $.trim(self.userName()), password:$.trim(self.password())}
      Model.login(data, (response)->
        return if response.state == 0
        if response.data == 0
          self.errorTip(response.message)
          $.mobile.changePage("#errorPage", { role: "dialog" })
        if response.data == 1
          $.mobile.changePage("show"))
    else
      unless self.validUserName()
        return result = "用户名长度为2-25个字符"

      unless self.validPassword()
        return  result = "密码长度为7-25个字符"
      $.mobile.changePage("#errorPage", { role: "dialog" } )

  self

ko.applyBindings(new LoginViewModel())
