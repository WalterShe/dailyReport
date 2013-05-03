treeList = new TreeList2("#userTree")

ReportModel.getSubordinateUserAndDepartment("28", (response)->
  treeData = response.data
  treeList.renderTree("#userTree", treeData))

#设置用户编辑界面状态
$("#userTree").on("review", (event)->
  userId = event["itemId"]
  getReports(userId)
  getReportNum(userId))
