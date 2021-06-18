import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/Screens/main_screen.dart';
import 'package:social_media/Screens/sub-screens/login-screen.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media/services/google_auth.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      title: 'Photogenic',
      home: SplashScreen()
    );
  }
}

class GoogleSignScreen extends StatefulWidget {
  @override
  _GoogleSignScreenState createState() => _GoogleSignScreenState();
}

class _GoogleSignScreenState extends State<GoogleSignScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Sign in with google'),
              onPressed: (){
                signInWithGoogle().then((value) {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => SeconScreen(user: value,)));
                });

              },)
          ],
        ),
      ),
    );
  }
}
// sahitya

class SeconScreen extends StatelessWidget {
  final User user;
  SeconScreen({this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.displayName),
            Image.network(user.photoURL),
            Text(user.email),
            RaisedButton(
              child: Text('Logout'),
              onPressed: (){
                signOutWithGoogle().then((c) => Navigator.pop(context));
              },),
            RaisedButton(
              child: Text('Start App'),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
            }),
          ],
        ),
      ),
    );
  }
}