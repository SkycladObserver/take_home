import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:take_home/cache/app_session_cache.dart';
import 'package:take_home/cache/cache_consts.dart';
import 'package:take_home/models/user.dart' as user_model;

class GoogleLoginFailure implements Exception {}

class FacebookLoginFailure implements Exception {}

/// Interface with authentication
class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Future<void> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
        throw GoogleLoginFailure();
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw GoogleLoginFailure();
    }
  }

  Future<void> loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    switch (result.status) {
      case LoginStatus.success:
        final AccessToken accessToken = result.accessToken!;
        final credential = FacebookAuthProvider.credential(accessToken.token);
        await _firebaseAuth.signInWithCredential(credential);

        break;
      default:
        throw FacebookLoginFailure();
    }
  }

  Future<void> loginWithFirebase() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Stream<user_model.User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null
          ? user_model.User.empty
          : user_model.User.fromFirebaseUser(firebaseUser);
      AppSessionCache.instance.write(key: userKey, value: user);
      return user;
    });
  }

  user_model.User get currentUser {
    return AppSessionCache.instance.read(userKey) ?? user_model.User.empty;
  }
}
