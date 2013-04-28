validator = new Validator()

# ViewModel---------------------------------------------------------------
ShowReportsViewModel = ->
  self = @
  self.reports = ko.observableArray([])

  self

# 初始化 ---------------------------------------------------------------
init = ->

  reportvm = new ShowReportsViewModel()
  ko.applyBindings(reportvm)

  data = {page:1, pageNum:7}
  ReportModel.getReports(data, (response)->
    reportvm.reports(response.data))

init()