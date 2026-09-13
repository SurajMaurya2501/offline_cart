import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/models/user_model.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await _googleSignIn.initialize();
      _initialized = true;
    } catch (e) {
      debugPrint('GoogleSignIn initialization warning: $e');
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      await initialize();
      final GoogleSignInAccount account = await _googleSignIn.authenticate();

      return UserModel(
        id: account.id,
        displayName: account.displayName ?? '',
        email: account.email,
        photoUrl: account.photoUrl ?? '',
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        debugPrint('Google sign-in dismissed by user');
        return null;
      }
      debugPrint('Google sign-in exception: ${e.code} - ${e.description}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during Google sign-in: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Error during Google sign-out: $e');
      rethrow;
    }
  }
}
