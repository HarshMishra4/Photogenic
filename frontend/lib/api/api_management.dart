import 'package:get/state_manager.dart';
import 'package:social_media/api/Models/Author.dart';
import 'package:social_media/api/Models/User.dart';
import 'package:social_media/api/api.dart';
import 'Models/Post.dart';

class APIController extends GetxController{
  APIController({this.id});
  int id;
  var userdetail = UserDataModel().obs;
  var feeds = PostsModel().obs;
  var users = Authors().obs;

  @override
  void onInit() {
    if(id != null){
      storeUserDetail('$id');
    }
    storeFetchedPosts();
    super.onInit();
  }

  Future<void> storeFetchedPosts({String url}) async{
    feeds.value = await APIServices.fetchPostsForFeedScreen();
  }

  Future<void> storeUserDetail(String userId) async{
    userdetail.value = await APIServices.fetchUserDetails(userId);
  }

  Future<void> searchUsers(String keyword) async{
    users.value = Authors.prepareList(await APIServices.searchEngine(keyword));
  }
}

