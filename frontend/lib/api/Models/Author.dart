class Author {
  int id;
  String bio;
  String name;
  String userId;
  bool isVerified;
  String avatar;
  int follower;
  List<String> following;

  Author({this.id, this.bio, this.name, this.userId, this.isVerified, this.avatar, this.follower, this.following});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bio = json['bio'];
    name = json['name'];
    userId = json['userId'];
    isVerified = json['isVerified'];
    avatar = json['avatar'];
    follower = json['follower'];
    following = json['following'].cast<String>();
  }
}

class Authors {
  List<Author> authors;

  Authors({this.authors});

  Authors.prepareList(list){
    authors = List<Author>();
    list.forEach((element) => authors.add(element));
  }
}