loginPageShowed = false
writePageShowed = false
showPageShowed = false
subordinatePageShowed = false

init = ->
  if window.mobileInitFinished
    return
  window.mobileInitFinished = true
  console.log "mobile init."
  $("body").on("pageshow","#loginPage", (e)->
    #console.log "login page show"

    #防止事件多次注册，导致事件函数执行多遍
    return if loginPageShowed
    loginPageShowed = true
    $("#loginSubmitBtn").on("click", ->
      if isValidLoginUser()
         data = {userName: $.trim($("#userName").val()), password: $.trim($("#password").val())}
         Model.login(data, (response)->
           return if response.state == 0
           if response.data == 0
             $.mobile.changePage("#loginErrorPage", { role: "dialog" })
           if response.data == 1
             $.mobile.changePage("write"))
      else
        $.mobile.changePage("#loginErrorPage", { role: "dialog" } )
    )
  )

  $("body").on("pageshow","#writePage",(e)->
    #console.log "write page show"
    #dateStr =  getDateStr(new Date())
    #$("#dateTxt").val(dateStr)
    #$("#content ").attr("value", dateStr)
    #alert $("#dateTxt").attr("value")
    #alert dateStr
    return if writePageShowed
    writePageShowed = true
    $("#reportSubmitBtn").on("click", ->
      if isValidDate()
        dateStr = $.trim($("#dateTxt").val())
        contentStr = $.trim($("#content").val())
        data = {date:dateStr, content:contentStr}
        Model.createReport(data, (response)->
          return if response.state == 0
          window.location.href = "/m/show")
      else
        $.mobile.changePage("#writeErrorPage", { role: "dialog" }))
  )

  $("body").on("pageshow","#showPage",(e)->
    #console.log "show page show"
    initPageInfo()
    getReports()
    getReportNum()
    return if showPageShowed
    showPageShowed = true
    $("#reportList").on("taphold","li",(e)->
      reportId = $(this).attr('reportId')
      $("#deleteReportBtn").attr("reportId", reportId)
      $("#deleteReportMenu").popup()
      $("#deleteReportMenu").popup('open')
    )

    $("#deleteReportMenu").on("click","#deleteReportBtn",(e)->
      reportId = $(this).attr('reportId')
      deleteReport(reportId)
      $("#deleteReportMenu").popup('close'))

    $("#deleteReportMenu").on("click","#cancelDeleteReportBtn",(e)->
      $("#deleteReportMenu").popup('close'))

    $("div.pagePre").on("click","button",(e)->
      currentPage -= 1
      setPageState()
      getReports()
      console.log "pre button clicked.#{currentPage}")

    $("div.pageNext").on("click","button",(e)->
      currentPage += 1
      setPageState()
      getReports()
      console.log "next button clicked.#{currentPage}")
  )

  $("body").on("pageshow","#subordinatePage",(e)->
    #console.log "subordinate page show"
    treeData = []
    $("#subordinatePage a.headerBack").css("display", "none")
    $("#subordinatePage h1").empty()
    $("#subordinatePage h1").append("下属日报")
    getSubordinateUserAndDepartment()

    return if subordinatePageShowed
    subordinatePageShowed = true
    $("#subordinatePage a.headerBack").click(->
      treeData.pop()
      renderSubordinate(treeData[treeData.length-1], "#subordinatePage div.subordinate")
      if treeData.length == 1
        $("#subordinatePage a.headerBack").css("display", "none")
        $("#subordinatePage h1").empty()
        $("#subordinatePage h1").append("下属日报")
      )
    )


# Login ----------------------------------------------------------------
isValidLoginUser = ->
  un = $.trim($("#userName").val())
  pw = $.trim($("#password").val())
  un.length >= 2 and un.length<=25 and pw.length >= 7 and pw.length<=25

# write -----------------------------------------------------------------
getDateStr = (date)->
  today = new Date()
  year = date.getFullYear()
  month = date.getMonth() + 1
  date = date.getDate()
  return "#{year}-#{month}-#{date}"

validator = new Validator()

isValidDate = ->
  dateStr = $.trim($("#dateTxt").val())
  contentStr = $.trim($("#content").val())
  try
    validator.check(contentStr).notEmpty()
    validator.check(dateStr).notEmpty()
    [year, months, date] = dateStr.split("-")
    #console.log "#{year}-#{months}-#{date}"
    validator.check(year).notNull().isNumeric().len(4,4)
    validator.check(months).notNull().isNumeric().len(1,2)
    validator.check(date).notNull().isNumeric().len(1,2)
    return true
  catch  error
    return false

# show -----------------------------------------------------------------
# 每页显示的日报条数
NUMOFPAGE = 2
reports = []
reportTotalNum = 0
pageNum = 0
currentPage = 1
reportUserId = null

initPageInfo = ->
  reports = []
  reportTotalNum = 0
  pageNum = 0
  currentPage = 1
  reportUserId = null

getReports = ()->
  data = {page:currentPage, numOfPage:NUMOFPAGE, userId:reportUserId}
  Model.getReports(data, (response)->
    return if response.state == 0
    reports = []
    $("#reportList ul").empty()
    for report in response.data
      reports.push(report)
      reportHTML = "<li class='report' reportId='#{report.id}'><p class='date'><i class='icon-calendar'></i><span>#{report.date}</span></p>
                  <div class='content'>#{report.content}</div></li>"
      $("#reportList ul").append(reportHTML))

deleteReport = (reportId)->
  Model.deleteReport({reportId:reportId}, (response)->
    return if response.state == 0
    reportTotalNum -= 1
    #reportvm.reportNum(reportvm.reportNum()-1)
    #page = reportvm.currentPage()
    if (reports.length == 1 &&  currentPage > 1)  #非第一页并且只有一条日报(这条日报被删了，嘿嘿)
      currentPage -= 1
    setPageState()
    getReports())

getReportNum = ()->
  Model.getReportNum(reportUserId, (response)->
    if response.state == 1
      reportTotalNum = response.data
    setPageState())

setPageState = ->
  pageNum = Math.ceil(reportTotalNum / NUMOFPAGE)
  pageNum = 1 if pageNum == 0
  $("div.pagetip").empty()
  $("div.pagetip").append("#{currentPage}/#{pageNum}")

  if pageNum == 1
    $("div.pageination").hide()
  else if currentPage == 1
    $("div.pageination").show()
    $("div.pagePre").hide()
    $("div.pageNext").show()
  else if currentPage == pageNum
    $("div.pageination").show()
    $("div.pagePre").show()
    $("div.pageNext").hide()
  else
    $("div.pageination").show()
    $("div.pagePre").show()
    $("div.pageNext").show()

# subordinate -----------------------------------------------------------------
subordinateUserAndDepartments = null
getSubordinateUserAndDepartment = ->
  Model.getSubordinateUserAndDepartment((response)->
    return if response.state == 0
    subordinateUserAndDepartments = response.data
    renderSubordinate(subordinateUserAndDepartments, "#subordinatePage div.subordinate", true)
    console.log subordinateUserAndDepartments)


treeData = []

renderSubordinate = (data, nodeContainer, pushStack=false)->
  $(nodeContainer).empty()
  $(nodeContainer).append("<ul class='root' data-role='listview' data-inset='true' data-filter='true'></ul>")
  treeNodeData = []
  node = "#{nodeContainer} ul.root"
  for nodeData in data
    treeNodeData.push(nodeData)
    if nodeData.children
      $(node).append("<li id='#{nodeData.id}-node' node='1' onclick='clickNode(event)'><a href='#'>#{nodeData.label}</a></li>")
    else
      $(node).append("<li id='#{nodeData.id}-node' onclick='showUserReport(event)'><a href='#'>#{nodeData.label}</a></li>")
  treeData.push(treeNodeData) if pushStack
  $("#{nodeContainer} ul.root").listview()


window.clickNode = (event)->
  [id, _] = $(event.currentTarget).attr("id").split("-")
  isNode = $(event.currentTarget).attr("node") and true
  $("#subordinatePage a.headerBack").css("display", "inline")
  $("#subordinatePage h1").empty()
  getChildNodeById(subordinateUserAndDepartments, id)

getChildNodeById = (dataSource, id)->
  for nodeData in dataSource
    if nodeData.id == id
      $("#subordinatePage h1").append(nodeData.label)
      renderSubordinate(nodeData.children, "#subordinatePage div.subordinate", true)
      return
    if nodeData.children
      getChildNodeById(nodeData.children, id)

window.showUserReport = (event)->
  [id, _] = $(event.currentTarget).attr("id").split("-")
  console.log id


window.init = init