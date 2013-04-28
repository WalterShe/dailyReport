# report model层，处理数据调用和解析 ---------------------------------------------------------------
class ReportModel

  #返回数据格式为[ { date: '2013-4-30',cotent: '<p><br /></p>4.30 reports' },{ date: '2013-4-30',content: '4.30 reports' }]
  @createReport: (data, callback)->
    $.post("/write", data, (response)->
      callback(response)
    , "json")

window.ReportModel = ReportModel