
crypto = require('crypto');
check = require('validator').check

departmentModel = require('../models/departmentsModel')
{Response} = require('../vo/Response')


#创建一个新部门
exports.createDepartment = (req, res) ->
  departmentName = req.body.departmentName
  parentId = req.body.pid
  try
    check(departmentName, "部门名称不能为空").notEmpty().notContains(":")
    departmentModel.createDepartment(departmentName, parentId, (response)->
       res.send(response))
  catch  error
    errorMessage = error.message
    res.send(new Response(0, errorMessage))

#删除部门
exports.removeDepartment = (req, res) ->
  departmentId = req.body.departmentId
  departmentModel.removeDepartment(departmentId, (response)->
    res.send(response))

#更新部门
exports.updateDepartment = (req, res) ->
  departmentId = req.body.departmentId
  departmentName = req.body.departmentName
  parentId = req.body.pid
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
