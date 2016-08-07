(function() {
	var BlogModel;

	BlogModel = (function() {
		function BlogModel() {}
		BlogModel.getBlogs = function(data, callback) {
			return $.post("/getblogs", data, function(response) {
				return callback(response);
			}, "json");
		};
		
		BlogModel.addBlog = function(data, callback){
			return $.post("/blog/addblog", data, function(response){
				return callback(response);
			}, "json");
		};

		return BlogModel;
	})();
	
	
	window.BlogModel = BlogModel;
}).call(this);