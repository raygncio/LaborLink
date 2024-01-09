import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laborlink/Pages/Client/ClientMainPage.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/ai/style.dart';
import 'package:laborlink/otp/verify_email_page.dart';
import 'package:laborlink/providers/current_user_provider.dart';
import 'package:laborlink/splash/splash_handyman.dart';
import 'package:laborlink/splash/splash_loading.dart';
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
            print('>>>>>>>>>>> connection state waiting');
            return const SplashHandymanPage();
          }

          if (snapshot.hasData) {
            print('>>>>>>>>>>> snapshot has data');
            return VerifyEmailPage();

            // return VerifyEmailPage(userId: userId!, userRole: userRole!);

            // if (userRole == 'client') {
            //   return ClientMainPage(userId: userId ?? '');
            // } else if (userRole == 'handyman') {
            //   return HandymanMainPage(userId: userId!);
            // }
          }

          print('>>>>>>>>>>> no login data');
          return const LandingPage();
        },
      ),
    );
  }
}
