
user = require('../controlers/userCtr')
department = require('../controlers/departmentCtr')
admin = require('../controlers/adminCtr')
report = require('../controlers/reportCtr')

exports.createRutes = (app)->
  app.get('/', report.index);
  app.get('/write', report.writeIndex);
  app.post('/write', report.write);
  app.get('/show', report.showIndex);
  app.post('/getreports', report.getReports);
  app.get('/login', user.loginIndex);
  app.post('/login', user.login);
  app.post('/admin/createuser', user.createUser);
  app.post('/admin/removeuser', user.removeUser);
  app.get('/admin/getallusers', user.getAllUsers);
  app.post('/admin/updateuser', user.updateUser);

  app.get('/admin', admin.index);
  app.get('/admin/users', admin.usersIndex);

  app.post('/admin/createdepartment', department.createDepartment);
  app.get('/admin/alldepartments', department.getAllDepartments);
  app.post('/admin/removedepartment', department.removeDepartment);
  app.post('/admin/updatedepartment', department.updateDepartment);