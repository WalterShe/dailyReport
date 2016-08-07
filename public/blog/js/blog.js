(function() {
	var getBLogs;
	getBLogs = function(userId) {
		var data1;
		if (userId == null) {
			userId = null;
		}
		data1 = {
			page: 1,
			numOfPage: 5,
			userId: userId
		};
		return BlogModel.getBlogs(data1, function(response) {
			//console.log(response.data)
			var blog = new Vue({
				el: '#blogList',
				data: {
					blogs: response.data
				}
			})
			return blog;
		});
	};
	window.getBLogs = getBLogs;
	getBLogs();
}).call(this);