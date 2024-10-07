import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veto_renew_application/utils/utils.dart';
import 'package:veto_renew_application/widgets/regist/OtpPage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignIn = false;
  bool get isSignIn => _isSignIn;
  
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore for database ops

  bool get isLoading => _isLoading;
  bool _isLoading = false;
  
  String _uid = ''; // Initialize _uid
  String get uid => _uid;

  AuthProvider() {
    checkSignIn();
  }

  // Check if the user is signed in
  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignIn = s.getBool('isSignIn') ?? false;
    notifyListeners();
  }

  // Sign in user (for UI state)
  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  // Log out user (for UI state)
  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  // Sign in with phone number (OTP verification)
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // Verify OTP
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential phoneCred = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );

      User? user = (await _firebaseAuth.signInWithCredential(phoneCred)).user;

      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DATABASE OPS: Check if a user exists in Firestore
  Future<bool> checkExistingUser() async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(_uid).get();
      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }
}
