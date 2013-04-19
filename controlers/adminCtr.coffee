
crypto = require('crypto');
check = require('validator').check
sanitize = require('validator').sanitize

userModel = require('../models/usersModel')
departmentModel = require('../models/departmentsModel')
{Response} = require('../vo/Response')



exports.index = (req, res) ->
  res.render("admin/department")

exports.usersIndex = (req, res) ->
  res.render("admin/users")

exports.createUser = (req, res) ->
  userName = sanitize(req.body.userName).trim()
  password = sanitize(req.body.password).trim()
  errorMessage = ""
  try
    check(userName, "字符长度为6-25，不能含有:符号").len(6,25).notContains(":")
  catch  error
    errorMessage = error.message

  try
    check(password, "字符长度为7-25，不能含有:符号").len(7,25).notContains(":")
  catch  error
    errorMessage = "#{errorMessage}, #{error.message}"

  if errorMessage == ""
    hashedPassword = crypto.createHash("sha1").update(password).digest('hex');
    userModel.createUser(userName, hashedPassword, (response)->
      res.send(response))
  else
    res.send(new Response(0,errorMessage))

#创建一个新部门
exports.createDepartment = (req, res) ->
  departmentName = sanitize(req.body.departmentName).trim()
  parentId = sanitize(req.body.pid).trim()
  errorMessage = ""
  try
    check(departmentName, "部门名称不能为空").notEmpty().notContains(":")
    departmentModel.createDepartment(departmentName, parentId, (response)->
       res.send(response))
  catch  error
    errorMessage = error.message
    consol.log errorMessage
    res.send(new Response(0,errorMessage))

#删除部门
exports.removeDepartment = (req, res) ->
  departmentId = sanitize(req.body.departmentId).trim()
  departmentModel.removeDepartment(departmentId, (response)->
    res.send(response))

 #获取所有部门
exports.getAllDepartments = (req, res) ->
  departmentModel.getAllDepartments((response)->
    res.send(response))
