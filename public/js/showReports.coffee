validator = new Validator()

# ViewModel---------------------------------------------------------------
ShowReportsViewModel = ->
  self = @
  self.reports = ko.observableArray([])
  self.pageNum = ko.observableArray([1])
  self.currentPage = ko.observable(1)
  self.test = ko.observable(1)

  self

# 初始化 ---------------------------------------------------------------
init = ->
  NUMOFPAGE = 4
  reportvm = new ShowReportsViewModel()
  ko.applyBindings(reportvm)

  data = {page:1, numOfPage:NUMOFPAGE}
  ReportModel.getReports(data, (response)->
    reportvm.reports(response.data))

  getPageNum = ->
    ReportModel.getReportNum((response)->
      pageNum = Math.ceil(response.data / NUMOFPAGE )
      reportvm.pageNum([1..pageNum]))

  getPageNum()

  $("#reportList").on("click", "p.delete", ->
    reportId = $(this).attr("reportId")
    ReportModel.deleteReport({reportId:reportId}, (response)->
      reports = reportvm.reports()
      for report in reports
        if report["id"] == reportId
          reportvm.reports.remove(report)
          if (reportvm.reports().length == 0 &&  reportvm.currentPage() > 1)
            page = reportvm.currentPage() - 1
            gotoPage(page)
          getPageNum()
          return))

  $("div.pagination").on("click", "li a", ->
    page = $(this).text()
    page = parseInt(page)
    gotoPage(page)
    false)

  gotoPage = (page)->
    reportvm.currentPage(page)
    data = {page:page, numOfPage:NUMOFPAGE}
    ReportModel.getReports(data, (response)->
      reportvm.reports(response.data))

init()