import 'package:social_media/api/Models/Post.dart';

import 'Author.dart';

class UserModel {
  int id;
  String bio;
  String name;
  String userId;
  bool isVerified;
  String avatar;
  int follower;
  List<String> following;
  List<PostModel> posts;

  UserModel({this.id, this.bio, this.name, this.userId, this.isVerified, this.avatar, this.follower, this.following, this.posts});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bio = json['bio'];
    name = json['name'];
    userId = json['userId'];
    isVerified = json['isVerified'];
    avatar = json['avatar'];
    follower = json['follower'];
    following = json['following'].cast<String>();
    if (json['posts'] != null) {
      posts = List<PostModel>();
      json['posts'].forEach((v) {
        posts.add(new PostModel.fromJson(v));
      });
    }else {
      posts = List<PostModel>();
    }
  }
}


class UserDataModel {
  int id;
  String bio;
  String dob;
  String name;
  String userId;
  bool isVerified;
  String avatar;
  String gender;
  int follower;
  List<String> following;
  List<PostModel> posts;

  UserDataModel({this.id, this.bio, this.name, this.userId, this.isVerified, this.avatar, this.follower, this.following, this.posts, this.dob,  this.gender});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bio = json['bio'];
    dob = json['dob'];
    gender = json['gender'];
    name = json['name'];
    userId = json['userId'];
    isVerified = json['isVerified'];
    avatar = json['avatar'];
    follower = json['follower'];
    following = json['following'].cast<String>();
    if (json['posts'] != null) {
      posts = new List<PostModel>();
      json['posts'].forEach((v) {
        posts.add(new PostModel.fromJson(v));
      });
    }else {
      posts = List<PostModel>();
    }
  }
}