treeList = new TreeList2("#userTree")

# ViewModel---------------------------------------------------------------
ShowReportsViewModel = ->
  self = @
  self.reports = ko.observableArray([])
  self.pageNum = ko.observableArray([1])
  self.currentPage = ko.observable(1)

  self

# 初始化 ---------------------------------------------------------------

getReports = (userId)->
  data = {page:1, numOfPage:NUMOFPAGE, userId:userId}
  ReportModel.getReports(data, (response)->
    reportvm.reports(response.data))

getPageNum = (userId)->
  ReportModel.getReportNum(userId, (response)->
    pageNum = Math.ceil(response.data / NUMOFPAGE )
    reportvm.pageNum([1..pageNum]))

init = ->
  NUMOFPAGE = 4
  reportvm = new ShowReportsViewModel()
  ko.applyBindings(reportvm)

  #getPageNum()

  ReportModel.getSubordinateUserAndDepartment("28", (response)->
    treeData = response.data
    console.log treeData
    treeList.renderTree("#userTree", treeData))

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