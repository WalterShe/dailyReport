// Generated by CoffeeScript 1.10.0
(function() {
  var NUMOFPAGE, ShowReportsViewModel, getReportNum, getReports, reportvm;

  ShowReportsViewModel = function() {
    var self;
    self = this;
    self.reports = ko.observableArray([]);
    self.reportNum = ko.observable(0);
    self.userId = ko.observable(null);
    self.pageNum = ko.computed(function() {
      var pageNum;
      pageNum = Math.ceil(self.reportNum() / NUMOFPAGE);
      if (pageNum === 0) {
        pageNum = 1;
      }
      return pageNum;
    });
    self.currentPage = ko.observable(1);
    return self;
  };

  NUMOFPAGE = 4;

  getReports = function(userId) {
    var data;
    if (userId == null) {
      userId = null;
    }
    data = {
      page: reportvm.currentPage(),
      numOfPage: NUMOFPAGE,
      userId: userId
    };
    return ReportModel.getReports(data, function(response) {
      if (response.state === 0) {
        return;
      }
      return reportvm.reports(response.data);
    });
  };

  getReportNum = function(userId) {
    if (userId == null) {
      userId = null;
    }
    return ReportModel.getReportNum(userId, function(response) {
      if (response.state === 0) {
        return;
      }
      return reportvm.reportNum(response.data);
    });
  };

  window.initPageState = function() {
    reportvm.reports([]);
    reportvm.reportNum(0);
    return reportvm.userId(null);
  };

  reportvm = new ShowReportsViewModel();

  ko.applyBindings(reportvm);

  window.getReports = getReports;

  window.getReportNum = getReportNum;

  window.reportvm = reportvm;

  $("div.pagination").on("click", "button.pageNext", function() {
    gotoPage(reportvm.currentPage() + 1);
    return false;
  });

  $("div.pagination").on("click", "button.pagePre", function() {
    gotoPage(reportvm.currentPage() - 1);
    return false;
  });

  window.gotoPage = function(page) {
    reportvm.currentPage(page);
    return getReports(reportvm.userId());
  };

}).call(this);
