vm = new DepartmentViewModel()
ko.applyBindings(vm)
$("#parentDepartment").change(->alert(vm.selectedParentDepartment()["id"]))