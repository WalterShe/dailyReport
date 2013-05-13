
getReports()
getReportNum()

$("#reportList").on("click", "p.delete", ->
  reportId = $(this).attr("reportId")
  ReportModel.deleteReport({reportId:reportId}, (response)->
    return if response.state == 0
    reports = reportvm.reports()
    for report in reports
      if report["id"] == reportId
        reportvm.reports.remove(report)
        reportvm.reportNum(reportvm.reportNum()-1)
        if (reportvm.reports().length == 0 &&  reportvm.currentPage() > 1)
          page = reportvm.currentPage() - 1
          gotoPage(page)

        return))