import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasha_app/screens/login_screen.dart';
import 'package:tasha_app/shared/components/components.dart';

class GoogleHelper {
  static User? userGoogle;
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  static String? accessToken;
  static String? idToken;

  static GoogleLogin() async {
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    accessToken = googleAuth?.accessToken;
    idToken = googleAuth?.idToken;
    final credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    userGoogle = FirebaseAuth.instance.currentUser;

    print(FirebaseAuth.instance.currentUser?.email);

  }

  static GoogleLogout(context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    await googleSignIn.signOut();
    navigateAndFinish(context, LoginScreen());
  }
}
