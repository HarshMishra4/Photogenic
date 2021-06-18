import 'Author.dart';



class PostsModel {
  int count;
  String next;
  String previous;
  List<PostModel> posts;

  PostsModel({this.count, this.next, this.previous, this.posts});

  PostsModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      posts = new List<PostModel>();
      json['results'].forEach((v) {
        posts.add(new PostModel.fromJson(v));
      });
    }
  }
}

class PostModel {
  int id;
  Author author;
  int likes;
  String caption;
  bool isReported;
  String postedOn;
  String image;

  PostModel({this.id, this.author, this.likes, this.caption, this.isReported, this.postedOn, this.image});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'] != null ? new Author.fromJson(json['author']) : null;
    likes = json['likes'];
    caption = json['caption'];
    isReported = json['isReported'];
    postedOn = json['postedOn'];
    image = json['image'];
  }

}