import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'package:social_media/api/api.dart';
import 'package:social_media/services/google_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Size size;

  @override
  Widget build(BuildContext context) {
  size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(context).viewPadding,
        child: Stack(
          children: [
            Background(),
            Align(alignment: Alignment.center,child: Image.asset('assets/Illustration.png',width: size.height / 3)),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .05,vertical: size.height * .08),
                  child: Text("Photogenic",style: GoogleFonts.lobster(color: Colors.blueGrey[400],fontWeight: FontWeight.w500,fontSize: 50,),),
                ),
                Column(
                  children: [
                    Container(color: Colors.transparent,height: size.height * .4),
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      color: Colors.white,
                      elevation: 15,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 30,child: Image.asset("assets/google.png")),
                            SizedBox(width: 10.0,),
                            Text("Sign in with google", style: TextStyle(fontSize: 18.0))
                          ],
                        ),
                      ),
                      onPressed: () {
                        signInWithGoogle().then((userdata) async{
                          if(userdata != null){
                            var details = await APIServices.signup(userdata);
                            apiController.userdetail.value = details;
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('userId', details.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        });
                        showProgressBox(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  showProgressBox(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(),
    );
  }

  
}

class Background extends StatelessWidget {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
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
            child: Image.asset('assets/bottom1.png',width: size.width, color: Colors.greenAccent),
          ),
          
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset('assets/bottom2.png',width: size.width, color: Colors.lightBlueAccent),
          ),
          
        ],
      ),
    );
  }
}

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: EdgeInsets.symmetric(horizontal: 120),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 50, width: 10,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.white),
        child: Row(
          children: [
            SizedBox(width: 25,height: 25,child: CircularProgressIndicator()),
            SizedBox(width: 15),
            Text("Please wait")
          ],
        ),
      ),
    );
  }
}