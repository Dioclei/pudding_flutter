import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser user;

Future<FirebaseUser> handleSignIn() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  user = await auth.signInWithCredential(credential);
  print("signed in " + user.displayName);

  //updates information in firestore
  Firestore.instance.collection('users').document(user.uid).setData({ //this adds/updates the user to the database.
    'displayname': user.displayName,
    'nickname': user.displayName,
    'email': user.email,
    'photoUrl': user.photoUrl});

  return user;
}

void handleSignOut() {
  _googleSignIn.signOut();
  auth.signOut();
}

bool checkIfSignedIn() => user != null;

Future<FirebaseUser> switchAccounts() async {
  handleSignOut();
  handleSignIn().then((FirebaseUser _user) {
    print("${_user.displayName} is signed in!");
    user = _user;
  });
  return user;
}