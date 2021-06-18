import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_media/Classes/app_settings.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'package:social_media/api/Models/Author.dart';
import 'package:social_media/api/Models/Comment.dart';
import 'package:social_media/api/Models/User.dart';
import 'Models/Post.dart';
import 'package:http/http.dart' as http;

class APIServices{
  static String _serverAddress = "http://10.0.2.2:8000/";

  static Future<UserDataModel> signup(User user) async{
    var image = await downloadPost(user.photoURL);
    var data = {
      'name'   : user.displayName,
      'email'  : user.email,
      'avatar' : base64Encode(File(image).readAsBytesSync())
    };
    final response = await http.post(_serverAddress + "userdetail",body: data);
    File(image).deleteSync(recursive: true);
    return response.statusCode == 201 || response.statusCode == 200 ? UserDataModel.fromJson(jsonDecode(response.body)) : null;
  }

  login(String userId) async{}

  static Future<PostsModel> fetchPostsForFeedScreen({String url}) async{
    var response = await http.get(url == null ? _serverAddress + 'feed/' : url);
    return response.statusCode == 200 ? PostsModel.fromJson(jsonDecode(response.body)) : null;
  }

  static Future<UserDataModel> fetchUserDetails(String userId) async{
    var response = await http.get(_serverAddress + 'userdetail?userId=$userId');
    return response.statusCode == 200 ? UserDataModel.fromJson(jsonDecode(response.body)) : null;
  }

  static Future<UserModel> fetchUser(String userId) async{
    var response = await http.get(_serverAddress + 'user?userId=$userId');
    return response.statusCode == 200 ? UserModel.fromJson(jsonDecode(response.body)) : null;
  }

  static Future<List> fetchPosts(List<String> postIds) async{
    var response = await http.get(_serverAddress + 'post?postIds=' + postIds.join());
    return response.statusCode == 200 ? jsonDecode(response.body).map((element) => Author.fromJson(element)).toList() : null;
  }

  static Future<UserDataModel> updateAccountDetails({name, id, about, gender, dob, image}) async{
    final data = {
      "name": '$name',
      "userId": '$id',
      "bio": '$about',
      "gender": '$gender',
      "dob": '$dob',
      "avatar": image != null ? base64Encode(File(image).readAsBytesSync()) : apiController.userdetail.value.avatar
    };
    final response = await http.put(_serverAddress + "userdetail",body: data);
    return response.statusCode == 200 ? UserDataModel.fromJson(jsonDecode(response.body)) : null;
  }

  static Future<List<PostModel>> createPost({String imageFilePath, String postCaption, String userid}) async{
    final data = {
      'userId' : userid,
      'image' : base64Encode(File(imageFilePath).readAsBytesSync()),
      'caption' : postCaption
    };
    final response = await http.post(_serverAddress + 'post/',body: data);
    return response.statusCode == 201 ? jsonDecode(response.body).map((element) => PostModel.fromJson(element)).toList().cast<PostModel>() : null;
  }
  
  static deletePost({String postId, String userId}) async{
    http.delete(_serverAddress + 'post?postId=$postId',);
  }
  static deleteAccount(String userId) async{}

  static like(int postId) async{
    await http.get(_serverAddress + 'like?postId=$postId');
  }

  static Future<bool> followUser(int userId, int followerId) async{
    var response = await http.get(_serverAddress + 'follow?userId=$userId&followerId=$followerId');
    return response.statusCode == 200 ? true : false;
  }
  
  static Future<List<CommentModel>> fetchComments(int postId) async{
    final response = await http.get(_serverAddress + 'comment?postId=$postId');
    List<CommentModel> cm = [];

    if(response.statusCode == 200){
      final decodedJsonData =  jsonDecode(response.body);
      decodedJsonData.forEach((e) => cm.add(CommentModel.fromJson(e)));
    }
    return cm.length != null ? cm : null;
  }

  static commentOnPost(String postId,String userId, String content) async{
    final data = {
      'userId': userId,
      'postId': postId,
      'content' : content
    };
    var response = await http.post(_serverAddress + 'comment',body: data);
    return response.statusCode == 200 ? true : false;
  }
  
  static deleteComment(String commentId) async{
    await http.delete(_serverAddress + 'comment?commentId=$commentId');
  }

  static Future<bool> reportPost({postid, reportType, useremail}) async{
    final data = {
        'postId': postid,
        'email': useremail,
        'type' : reportType
    };
    var response = await http.post(_serverAddress + 'report/',body: data);
    return response.statusCode == 200 ? true : false;
  }
  
  static Future<List> searchEngine(String keyword) async{
    final response = await http.get(_serverAddress + 'search?query=$keyword');
    return response.statusCode == 200 ? jsonDecode(response.body).map((element) => Author.fromJson(element)).toList() : null;
  }

  // todo ask storage permission before download
  static Future downloadPost(String url) async {
    if(await Permission.storage.request().isGranted){
      HttpClient httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getExternalStorageDirectory()).path.split('Android')[0] + 'Download/';
      File file = new File('$dir/srfkj${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(bytes);
      return file.path;
    }else{
      showToast(message: "Please provide storage permission");
    }
  }
}