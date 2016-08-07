(function() {
		var AddBlogViewModel, init;
		AddBlogViewModel = function() {
			var self;
			self = this;
			return self;
		};

		init = function() {
			new Vue({
				el: '#addblog',
				data: {

				},
				methods: {
					addBlog: function() {
						var post_content = this.postContent.trim();
						var data;
						data  = {
							post_content:post_content
						};
						return BlogModel.addBlog(data, function(response) {
							if (response.state === 0) {
								return;
							}
							return window.location.href = "../index.html";
						});
					}
				}
			})
		};
		init();

	}

).call(this);