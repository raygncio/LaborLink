import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laborlink/Pages/Admin/AdminDashboard.dart';
import 'package:laborlink/otp/verify_email_page.dart';
import 'package:laborlink/splash/splash_handyman.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/Pages/LandingPage.dart';
import 'package:laborlink/ai/screens/face_verification.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //initialize camera upon start
  cameras = await availableCameras();

  // lock orientation
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application...
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'LaborLink',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          // bool isLoadingLoginData = false;

          if (snapshot.connectionState == ConnectionState.waiting) {
            
            return const SplashHandymanPage();
          }

          if (snapshot.hasData) {
            

            // ADMIN
            if (FirebaseAuth.instance.currentUser!.email ==
                'laborlink@gmail.com') {
              return const AdminDashboard();
            }

            // USERS!
            return const VerifyEmailPage();

            // return VerifyEmailPage(userId: userId!, userRole: userRole!);

            // if (userRole == 'client') {
            //   return ClientMainPage(userId: userId ?? '');
            // } else if (userRole == 'handyman') {
            //   return HandymanMainPage(userId: userId!);
            // }
          }

          return const LandingPage();
        },
      ),
    );
  }
}
