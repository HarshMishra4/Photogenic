import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/Classes/app_settings.dart';
import 'package:social_media/Classes/sizeconfigration.dart';
import 'package:social_media/Screens/sub-screens/account-settings.dart';
import 'package:social_media/Screens/sub-screens/post_widget.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'package:social_media/Widgets/gradient_frame.dart';
import 'package:social_media/api/Models/Post.dart';
import 'package:social_media/api/api.dart';

class Profile extends StatefulWidget {
  final userid;
  final userdetail;
  Profile({this.userid, this.userdetail});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var user;
  bool isLoaded = false;

  @override
  void initState() { 
    setUserDetails().then((_) => setState(() => isLoaded = true));
    super.initState();
  }

  Future setUserDetails() async{
    user = widget.userid != null ? await APIServices.fetchUser('${widget.userid}') : apiController.userdetail.value;
    return;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: isLoaded
      ? DefaultTabController(
        length: 2,
        child: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverPadding(padding: EdgeInsets.only(top: SizeConfig.statusBarHeight.top)),
                SliverAppBar(
                  backgroundColor: Colors.white,
                  collapsedHeight: SizeConfig.setHeight(apiController.userdetail.value.id != user.id ? 230 : 160),
                  expandedHeight: SizeConfig.setHeight(apiController.userdetail.value.id != user.id ? 210 : 160),
                  flexibleSpace: headerSection(),
                ),
                SliverPersistentHeader(
                  delegate: MyDelegate(
                    TabBar(
                    tabs: [
                      Tab(icon: Icon(FontAwesomeIcons.th,size: 20,)),
                      Tab(icon: Icon(FontAwesomeIcons.bookmark,size: 20,)),
                    ],
                    indicatorColor: Colors.green[400],
                    labelColor: Colors.green[400],
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                  )),
                  floating: true,
                  pinned: true,
                )
              ];
            },
            body: Padding(
              padding:EdgeInsets.only(bottom: widget.userid != null ? 0 : 50),
              child: TabBarView(
                children: [postSection(), savedPostSection()]),
            )),
      ) : Center(child: CircularProgressIndicator(),)
    );
  }

  Widget headerSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // UserId
      ListTile(
        contentPadding: EdgeInsets.only(left: 20),
        title: Row(
          children: [
            Text(user.userId,style: TextStyle(fontSize: SizeConfig.setText(20))),
            SizedBox(width: 10),
            user.isVerified ? Icon(Icons.verified, size: 23,color: Colors.lightGreen) : SizedBox()
          ],
        ),
        trailing: IconButton(
          icon: Icon(FontAwesomeIcons.cog),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, _) => AccountSettings(),
            opaque: false));
        }),
      ),
      // User Details
      Padding(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GradientCircleAvatar(
              image: user.avatar,
              backgroundColor: AppDataLightMode.avatarBackgroundColor,
              showFrame: user.isVerified,
              frameThickness: 3.0,
              radius: 40,
            ),
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 35.0,bottom: 10.0),
                      child: Text(user.name, style: GoogleFonts.roboto(color: AppDataLightMode.textColor, 
                      fontWeight: FontWeight.w600, fontSize: SizeConfig.setText(20),)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        pffDetailsSection(user.posts.length, "Posts"),
                        pffDetailsSection(user.follower, "Followers"),
                        pffDetailsSection(user.following.length, "Following"),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 3.0),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
        child: Text(utf8.decode(user.bio.codeUnits),
          style: TextStyle(color: Colors.black87,fontSize: SizeConfig.setText(13),)
          )
      ),
      SizedBox(height: 3.0),
      apiController.userdetail.value.id != user.id
      ? Obx(
        () => SizedBox(
          height: SizeConfig.setHeight(40),
          width: double.maxFinite,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: apiController.userdetail.value.following != null ??
            !apiController.userdetail.value.following.contains('${user.id}')
            ? FlatButton(
              color: Colors.blueAccent,
              textColor: Colors.white,
              child: Text("Follow"),
              onPressed: () async{
                await APIServices.followUser(user.id, apiController.userdetail.value.id);
                apiController.userdetail.value.following.add('${user.id}');
                setUserDetails().then((_) => setState(() {}));
              })
            : FlatButton(
              color: Colors.black87,
              textColor: Colors.white,
              child: Text("Unfollow"),
              onPressed: () async{
                await APIServices.followUser(user.id, apiController.userdetail.value.id);
                apiController.userdetail.value.following.remove('${user.id}');
                setUserDetails().then((_) => setState(() {}));
              }),
          ),
        ),
      ) : SizedBox(),
    ]);
  }

  Widget pffDetailsSection(int title, String label) {
    return Column(
      children: [
        Text('$title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 3.0),
        Text(label)
      ],
    );
  }

  Widget postSection() {
    if(user.posts.length != 0){
      return RefreshIndicator(
        onRefresh: () {setState((){});return Future.value(1);},
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 3.0),
          itemCount: user.posts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 3.0, crossAxisSpacing: 3.0),
          itemBuilder: (context, index) {
            return GestureDetector(
              // Check the user id
              onLongPress:() async{
                if(user.id == apiController.userdetail.value.id){
                  if(await _alertDialog()){
                    APIServices.deletePost(postId: '${user.posts[(user.posts.length - 1) - index].id}');
                  }
                }
              },
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  
              PostsListWidget(postsData: PostsModel(posts: user.posts.reversed.toList(), count: user.posts.length),currentPostIndex: index))),
              child: Image.network(user.posts[(user.posts.length - 1) - index].image, fit: BoxFit.cover),
            );
          },
        ),
      );
    }else{
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, color: Colors.black45,size: 100,),
            SizedBox(height: 10.0),
            Text('No posts available to show',style: TextStyle(fontSize: 23,fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }
  }
  _alertDialog() async{
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure, you want to delete this post"),
        actions: [
          FlatButton(child: Text("Yes"),onPressed: () => Navigator.of(context).pop(true)),
          FlatButton(child: Text("Cancel"),onPressed: () => Navigator.of(context).pop(false)),
        ],
      ),
    );
  }

  Widget savedPostSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_rounded, color: Colors.red,size: 80),
          Text('No saved posts yet',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600)),
          SizedBox(height: 15.0),
          Text('Tap the save icon on post that you want\n to see again.',textAlign: TextAlign.center,style: TextStyle(fontSize: 18))
        ],
      ),
    );
  }

}

class MyDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  MyDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white,child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}