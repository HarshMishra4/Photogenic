import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/Classes/app_settings.dart';
import 'package:social_media/Screens/sub-screens/login-screen.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'dart:ui' as ui;
import 'sub-screens/camera_screen.dart';
import 'package:social_media/Screens/notification_page.dart';
import 'package:social_media/Screens/search_page.dart';
import 'package:social_media/Screens/user_account.dart';
import 'package:social_media/Widgets/gradient_frame.dart';
import 'sub-screens/post_widget.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Page Controller
  PageController _pageController = PageController(initialPage: 0,keepPage: true);
  
  // LinearGradient Shader to achive Gradient Text
  final Shader linearGradient = AppDataLightMode.appThemecolor.createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: currentPageIndex == 0 
      ? AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Photogenic", style:GoogleFonts.lobster(fontSize: 30,foreground: Paint()..shader = linearGradient)),
        leading: maskGradient(Icon(Icons.camera,size: 35)),
      ) : null,
      // Body of the screens
      body: Stack(
        children: [
          Obx(
            () => PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                setState(() => currentPageIndex = value);
              },
              children: [
                // Screen One
                PostsListWidget(postsData: apiController.feeds.value,),
                // Screen Two
                SearchPage(),
                // Screen Three
                UserAccountNotification(),
                // Screen Four
                Profile()
              ],
            ),
          ),
          bottomAppBar()
        ],
      ),
    );
  }

  Widget bottomAppBar(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // color: Colors.white,
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 10)],color: Colors.white),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(color: currentPageIndex == 0 ? null : Colors.grey[500], onPressed: () => _pageController.jumpToPage(0), splashColor: Colors.transparent, highlightColor: Colors.transparent, icon: Icon(Icons.home_rounded, size: 30)),
            IconButton(color: currentPageIndex == 1 ? null : Colors.grey[500], onPressed: () => _pageController.jumpToPage(1), splashColor: Colors.transparent, highlightColor: Colors.transparent, icon: Icon(Icons.search),iconSize: 30),
            IconButton(onPressed: () {
              apiController.userdetail.value.avatar != null ? popBottomSheet() : showToast(message: 'You are not logged in');
            }, splashColor: Colors.transparent, highlightColor: Colors.transparent, icon: maskGradient(Icon(Icons.camera_enhance_rounded)),iconSize: 35,),
            IconButton(color: currentPageIndex == 2 ? null : Colors.grey[500], onPressed: () => _pageController.jumpToPage(2), splashColor: Colors.transparent, highlightColor: Colors.transparent, icon: Icon(FontAwesomeIcons.bell)),
            IconButton(
              color: currentPageIndex == 3 ? null : Colors.grey[500], onPressed: () {
                if(apiController.userdetail.value.avatar != null){
                  _pageController.jumpToPage(3);
                }else{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                }
              }, splashColor: Colors.transparent, highlightColor: Colors.transparent,
              icon: apiController.userdetail.value.avatar != null
                ? GradientCircleAvatar(image: apiController.userdetail.value.avatar,showFrame: apiController.userdetail.value.isVerified,frameThickness: 2.0,backgroundColor: AppDataLightMode.avatarBackgroundColor,)
                : Icon(Icons.account_circle_rounded)
            )
            
            // Icon(FontAwesomeIcons.userAlt))
          ]
        )
      ),
    );
  }

  Widget menuButton({int pageIndex,String label,IconData icon,}){
    return InkWell(
      onTap: () => _pageController.jumpToPage(pageIndex),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: currentPageIndex == pageIndex ? null : Colors.grey[500]),
          currentPageIndex == pageIndex ? SizedBox(height: 0.0) : Text("Home")
        ],
      ),
    );
  }

  maskGradient(Widget icon){
    return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (Rect bounds) {
      return ui.Gradient.linear(
        Offset(4.0, 24.0),
        Offset(24.0, 4.0),
        [Color(0xFF56ab2f), Color(0xFFa8e063)],
      );
    },
    child: icon);
  }

  popBottomSheet() async{
    var data = await showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
      context: context, builder: (context) => PopUpMenu());
    print(data);
  }

}