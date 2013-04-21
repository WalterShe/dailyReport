
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
    res.send(new Response(0,errorMessage))

#删除部门
exports.removeDepartment = (req, res) ->
  departmentId = sanitize(req.body.departmentId).trim()
  departmentModel.removeDepartment(departmentId, (response)->
    res.send(response))

#更新部门
exports.updateDepartment = (req, res) ->
  departmentId = sanitize(req.body.departmentId).trim()
  departmentName = sanitize(req.body.departmentName).trim()
  parentId = sanitize(req.body.pid).trim()
  try
    check(departmentName, "部门名称不能为空").notEmpty().notContains(":")
    departmentModel.updateDepartment(departmentId, departmentName, parentId, (response)->
      res.send(response))
  catch  error
    errorMessage = error.message
    res.send(new Response(0,errorMessage))

 #获取所有部门
exports.getAllDepartments = (req, res) ->
  departmentModel.getAllDepartments((response)->
    res.send(response))
