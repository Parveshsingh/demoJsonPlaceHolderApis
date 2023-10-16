class PostsModel {
  int userId = 0;
  int id = 0;
  String title = '';
  String body = '';

  PostsModel({this.userId = 0, this.id = 0, this.title = '', this.body = ''});

  PostsModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? 0;
    id = json['id'] ?? 0;
    title = json['title'] ?? "";
    body = json['body'] ?? "";
  }
}


class PostsCommentModel {
  int postId = 0;
  int id = 0;
  String name = '';
  String body = '';

  PostsCommentModel({this.postId = 0, this.id = 0, this.name = '', this.body = ''});

  PostsCommentModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'] ?? 0;
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    body = json['body'] ?? "";
  }
}

