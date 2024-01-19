import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // for verification id
  static String verifyId = '';

  // to send otp to user

  static Future sendOtp({
    required String phoneNumber,
    required Function errorStep, // directly handle error
    required Function nextStep,
  }) async {
    await _firebaseAuth
        .verifyPhoneNumber(
      timeout: const Duration(seconds: 30),
      phoneNumber: "+63$phoneNumber",
      verificationCompleted: (phoneAuthCredential) async {
        // Automatic handling of the SMS code on Android devices.
        return;
      },
      verificationFailed: (error) async {
        // Handle failure events such as invalid phone numbers or whether the
        // SMS quota has been exceeded.
        return;
      },
      // function when sending code is completed
      codeSent: (verificationId, forceResendingToken) async {
        // Handle when a code has been sent to the device from Firebase,
        // used to prompt users to enter the code.
        verifyId = verificationId;
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        // Handle a timeout of when automatic SMS code handling fails.
        return;
      },
    )
        .onError((error, stackTrace) {
      errorStep();
    });
  }

  // verify the otp
  static Future proceed({required String otp}) async {
    PhoneAuthCredential cred;

    try {
      cred =
          PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

      User currentUser = FirebaseAuth.instance.currentUser!;
      await currentUser.linkWithCredential(cred);

      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }
}
