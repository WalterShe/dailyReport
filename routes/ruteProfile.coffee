
user = require('../controlers/userCtr')
department = require('../controlers/departmentCtr')
admin = require('../controlers/adminCtr')

exports.createRutes = (app)->
  #app.get('/', routes.index);
  app.get('/login', user.loginIndex);
  app.post('/login', user.login);
  app.post('/admin/createuser', user.createUser);
  app.post('/admin/removeuser', user.removeUser);
  app.post('/admin/getallusers', user.getAllUsers);

  app.get('/admin', admin.index);
  app.get('/admin/users', admin.usersIndex);

  app.post('/admin/createdepartment', department.createDepartment);
  app.get('/admin/alldepartments', department.getAllDepartments);
  app.post('/admin/removedepartment', department.removeDepartment);
  app.post('/admin/updatedepartment', department.updateDepartment);