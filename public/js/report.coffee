validator = new Validator()
editor = UE.getEditor('content')

# ViewModel---------------------------------------------------------------
ReportViewModel = ->
  self = @
  self.dateTxt = ko.observable(null)
  self.validDateTxt = ko.computed(->
    dateStr = $.trim(self.dateTxt())
    try
      validator.check(dateStr).notEmpty()
      [year, months, date] = dateStr.split("-")
      #console.log "#{year}-#{months}-#{date}"
      validator.check(year).notNull().isNumeric().len(4,4)
      validator.check(months).notNull().isNumeric().len(1,2)
      validator.check(date).notNull().isNumeric().len(1,2)
      return true
    catch  error
      return false)

  self.submit = ->
    if self.validDateTxt()
      console.log editor.getContent()

  self

# 初始化 ---------------------------------------------------------------
init = ->
  $("#dateTxt").datepicker();
  $("#dateTxt").datepicker("option", "dateFormat", "yy-mm-dd")

  reportvm = new ReportViewModel()
  ko.applyBindings(reportvm)

  today = new Date()
  year = today.getFullYear()
  month = today.getMonth() + 1
  date = today.getDate()
  dateStr =  "#{year}-#{month}-#{date}"
  reportvm.dateTxt(dateStr)
  #console.log $("#dateTxt").datepicker("getDate")

init()