crypto = require('crypto');
check = require('validator').check
reportModel = require('../models/reportModel')
userModel = require('../models/usersModel')
utils = require('../utils')
{Response} = require('../vo/Response')

exports.index = (req, res) ->
  return unless utils.authenticateUser(req,res)
  res.redirect("/show")

exports.writeIndex = (req, res) ->
  return unless utils.authenticateUser(req,res)
  userId = req.session.userId
  showPage(req, res, userId, "write")

exports.settingMobile = (req, res) ->
  return unless utils.authenticateUserMobile(req,res)
  res.render("mobile/settings")

exports.writeIndexMobile = (req, res) ->
  return unless utils.authenticateUserMobile(req,res)
  userId = req.session.userId
  showPage(req, res, userId, "mobile/write")

exports.write = (req, res) ->
  return unless utils.authenticateUser(req,res)
  userId = req.session.userId
  dateStr = req.body.date
  content = req.body.content

  try
    check(dateStr).notEmpty()
    check(content).notEmpty()
    [year, months, date] = dateStr.split("-")
    #console.log "#{year}-#{months}-#{date}"
    check(year).notNull().isNumeric().len(4,4)
    check(months).notNull().isNumeric().len(1,2)
    check(date).notNull().isNumeric().len(1,2)
    reportModel.createReport(userId, content, dateStr, (response)->
      res.send(response))
  catch error
    res.send(new Response(0,"日期格式不正确或者内容为空"))

exports.showIndex = (req, res) ->
  return unless utils.authenticateUser(req,res)
  userId = req.session.userId
  showPage(req, res, userId, "show")

exports.showIndexMobile = (req, res) ->
  return unless utils.authenticateUserMobile(req,res)
  userId = req.session.userId
  showPage(req, res, userId, "mobile/show")

showPage = (req, res, userId, pageTitle) ->
  userModel.hasSubordinate(userId, (result)->
    data = {hasSubordinate: result, isLoginUser:utils.isLoginUser(req), isAdmin:utils.isAdmin(req)}
    res.render(pageTitle, data))

exports.showsubordinateIndex = (req, res) ->
  return unless utils.authenticateUser(req,res)
  userId = req.session.userId
  userModel.hasSubordinate(userId, (result)->
    if result
      data = {isLoginUser:utils.isLoginUser(req), isAdmin:utils.isAdmin(req)}
      res.render("showsubordinate", data)
    else
      res.send(new Response(0,"您目前没有下属,不需要访问该页面！")) )

exports.subordinateIndexMobile = (req, res) ->
  return unless utils.authenticateUserMobile(req,res)
  userId = req.session.userId
  userModel.hasSubordinate(userId, (result)->
    if result
      data = {isLoginUser:utils.isLoginUser(req), isAdmin:utils.isAdmin(req)}
      res.render("mobile/showsubordinate", data)
    else
      res.send(new Response(0,"您目前没有下属,不需要访问该页面！")) )

exports.getReports = (req, res) ->
  return unless utils.authenticateUser(req,res)

  #第几页
  page =  req.body.page
  userId = req.body.userId
  #没有userId表示访问自己的日报
  userId = req.session.userId unless userId

  #每页显示条数
  numOfPage =  req.body.numOfPage
  try
    check(page).isNumeric().min(1)
    check(page).isNumeric().min(1)
    reportModel.getReports(userId, page, numOfPage, (response)->
      res.send(response))
  catch error
    res.send(new Response(0,"页数和每页显示条数为非负数"))

exports.getReportNum = (req, res) ->
  return unless utils.authenticateUser(req,res)
  userId = req.body.userId
  #没有userId表示访问自己的日报
  userId = req.session.userId unless userId

  reportModel.getReportNum(userId, (response)->
    res.send(response))

exports.delete = (req, res) ->
  return unless utils.authenticateUser(req,res)
  userId = req.session.userId
  reportId =  req.body.reportId
  reportModel.deleteReport(userId, reportId, (response)->
    res.send(response))


exports.getSubordinateUserAndDepartment = (req, res) ->
  return unless utils.authenticateUser(req,res)
  userId = req.session.userId
  reportModel.getSubordinateUserAndDepartment(userId, (response)->
    res.send(response))