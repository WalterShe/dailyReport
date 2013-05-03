crypto = require('crypto');
check = require('validator').check
sanitize = require('validator').sanitize
reportModel = require('../models/reportModel')
userModel = require('../models/usersModel')
{Response} = require('../vo/Response')

exports.writeIndex = (req, res) ->
  userId = "28"
  showPage(res, userId, "write")

exports.write = (req, res) ->
  dateStr =  sanitize(req.body.date).trim()
  content =  sanitize(req.body.content).trim()

  errorMessage = ""
  try
    check(dateStr).notEmpty()
    check(content).notEmpty()
    [year, months, date] = dateStr.split("-")
    #console.log "#{year}-#{months}-#{date}"
    check(year).notNull().isNumeric().len(4,4)
    check(months).notNull().isNumeric().len(1,2)
    check(date).notNull().isNumeric().len(1,2)
    reportModel.createReport("28", content, dateStr, (response)->
      res.send(response))
  catch error
    res.send(new Response(0,"日期格式不正确或者内容为空"))

exports.showIndex = (req, res) ->
  userId = "28"
  showPage(res, userId, "show")

showPage = (res, userId, pageTitle) ->
  userModel.hasSubordinate(userId, (result)->
    data = {hasSubordinate: result}
    res.render(pageTitle, data))

exports.showsubordinateIndex = (req, res) ->
  userModel.hasSubordinate("28", (result)->
    if result
      res.render("showsubordinate")
    else
      res.send("您目前没有下属") )

exports.getReports = (req, res) ->
  #第几页
  page =  sanitize(req.body.page).trim()
  userId = sanitize(req.body.userId).trim()
  console.log "userId:#{userId}-"
  userId = "28" #unless userId
  console.log "userId:#{userId}-"
  #每页显示条数
  numOfPage =  sanitize(req.body.numOfPage).trim()
  try
    check(page).isNumeric().min(1)
    check(page).isNumeric().min(1)
    reportModel.getReports(userId, page, numOfPage, (response)->
      res.send(response))
  catch error
    res.send(new Response(0,"页数和每页显示条数为非负数"))

exports.getReportNum = (req, res) ->
  userId = sanitize(req.body.userId).trim()
  userId = "28" #unless userId

  reportModel.getReportNum(userId, (response)->
    res.send(response))

exports.delete = (req, res) ->
  reportId =  req.body.reportId
  reportModel.deleteReport("28", reportId, (response)->
    res.send(response))


exports.getSubordinateUserAndDepartment = (req, res) ->
  userId = "28"
  reportModel.getSubordinateUserAndDepartment("28", (response)->
    res.send(response))