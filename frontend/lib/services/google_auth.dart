import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// lets define Login Methods  And Logins

final FirebaseAuth auth = FirebaseAuth.instance; // instance will be final
final GoogleSignIn googleSignIn = GoogleSignIn();

// SignIn Method

Future signInWithGoogle() async {
  try {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    final UserCredential authResult = await auth.signInWithCredential(credential);
    return authResult.user;
  } on Exception catch (e) {}
  return null;
}

// LogOut Method
Future signOutWithGoogle() async {
  try {
    await googleSignIn.signOut();
  } on Exception catch (e) {}
}