import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laborlink/Pages/Client/ClientMainPage.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/providers/current_user_provider.dart';
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('>>>>>>>>>>> connection state waiting');
            return const SplashHandymanPage();
          }

          Future.delayed(const Duration(seconds: 5), () {});

          if (snapshot.hasData) {
            // means a user is logged in  (has token)
            print('>>>>>>>>>>> snapshot has data');

            ref.read(currentUserProvider.notifier).saveCurrentUserInfo();

            Map<String, dynamic> userInfo = ref.watch(currentUserProvider);
            String? userId = userInfo['userId'];
            String? userRole = userInfo['userRole'];

            print('>>>>>>>>>>> userId: $userId');
            print('>>>>>>>>>>> userrole: $userRole');

            if (userRole == 'client') {
              return ClientMainPage(userId: userId!);
            } else if (userRole == 'handyman') {
              return HandymanMainPage(userId: userId!);
            }
          }

          print('>>>>>>>>>>> no login data');
          return const LandingPage();
        },
      ),
    );
  }
}
