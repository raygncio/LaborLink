import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laborlink/Pages/Client/ClientMainPage.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/Pages/LoginPage.dart';
import 'package:laborlink/ai/screens/splash_one.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/providers/current_user_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/Pages/LandingPage.dart';
import 'package:laborlink/ai/screens/face_verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
            return const SplashOnePage();
          }

          if (snapshot.hasData) {
            // means a user is logged in  (has token)
            String? userRole =
                ref.read(currentUserProvider.notifier).currentUserRole;

            if (userRole == 'client') {
              return ClientMainPage(userId: userId);
            } else if (userRole == 'handyman') {
              return HandymanMainPage(userId: userId);
            } else {
              return const LoginPage();
            }
          }

          return const LandingPage();
        },
      ),
    );
  }
}
