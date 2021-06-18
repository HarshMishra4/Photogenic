import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/Classes/app_settings.dart';
import 'package:social_media/Screens/main_screen.dart';
import 'package:social_media/api/api_management.dart';

APIController apiController;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Shader linearGradient = AppDataLightMode.appThemecolor.createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  Size size;

  @override
  void initState() { 
    super.initState();
    Timer.periodic(Duration(seconds: 1),(timer) async{
      if(timer.tick == 3){
        timer.cancel();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        apiController = Get.put(APIController(id: prefs.getInt('userId')));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          BackGround(),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera,size: 100,color: Color(0xFFa8e063)),
                SizedBox(height: 10.0),
                SimmerEffect(child: Text("Photogenic", style:GoogleFonts.lobster(fontSize: 50,foreground: Paint()..shader = linearGradient)))
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(80.0),
              child: SizedBox(height: 40,width: 40,child: CircularProgressIndicator()),
            ),
          )
        ],
      ),
    );
  }
}

class BackGround extends StatelessWidget {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
            right: 0,
            top: 0,
            child: Image.asset('assets/top1.png',width: size.width, color: Colors.tealAccent,),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset('assets/top2.png',width: size.width, color: Colors.greenAccent),
          ),        
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset('assets/bottom2.png',width: size.width, color: Colors.lightBlueAccent),
          ),
      ],
    );
  }
}

class SimmerEffect extends StatefulWidget {
  final Widget child;
  SimmerEffect({this.child});

  @override
  _SimmerEffectState createState() => _SimmerEffectState();
}

class _SimmerEffectState extends State<SimmerEffect> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
  }
  @override
  void dispose() { 
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _widget) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [Color(0xFFa8e063), Colors.lightGreenAccent[100], Color(0xFFa8e063)],
              stops: [controller.value - 0.3, controller.value, controller.value + 0.3],
            ).createShader(
              Rect.fromLTWH(0, 0, rect.width, rect.height),
            );
          },
          child: widget.child,
          blendMode: BlendMode.srcIn,
        );
      },
    );
  }
}