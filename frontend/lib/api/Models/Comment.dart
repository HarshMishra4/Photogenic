import 'Author.dart';

class CommentModel {
  int id;
  Author author;
  String content;
  String commentedOn;
  int post;

  CommentModel({this.id, this.author, this.content, this.commentedOn, this.post});

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'] != null ? new Author.fromJson(json['author']) : null;
    content = json['content'];
    commentedOn = json['commentedOn'];
    post = json['post'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['author'] = this.author.id;
    data['content'] = this.content;
    data['post'] = this.post;
    return data;
  }
}