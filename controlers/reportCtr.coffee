crypto = require('crypto');
check = require('validator').check
sanitize = require('validator').sanitize
reportModel = require('../models/reportModel')
{Response} = require('../vo/Response')

exports.index = (req, res) ->
  res.render("index")

exports.writeIndex = (req, res) ->
  res.render("write")

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
  res.render("show")

exports.getReports = (req, res) ->
  #第几页
  page =  sanitize(req.body.page).trim()

  #每页显示条数
  pageNum =  sanitize(req.body.pageNum).trim()

  errorMessage = ""
  try
    check(page).isNumeric().min(1)
    check(page).isNumeric().min(1)
    reportModel.getReports("28", page, pageNum, (response)->
      res.send(response))
  catch error
    res.send(new Response(0,"页数和每页显示条数为非负数"))

exports.getReportNum = (req, res) ->
  reportModel.getReportNum("28", (response)->
    res.send(response))