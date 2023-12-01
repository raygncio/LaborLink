import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laborlink/ai/screens/splash_one.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/database_service.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application...
  @override
  Widget build(BuildContext context) {
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
            return const ChatScreen();
          }

          return const LandingPage();
        },
      ),
    );
  }

  getUserInfo() async {
    DatabaseService service = DatabaseService();

    Client clientInfo = await service.getUserData(userCredential.user!.uid);

        if (clientInfo.userRole == "handyman") {
          // User is a handyman, navigate to the handyman page.
          toHandyman();
        } else if (clientInfo.userRole == "client") {
          // User is a client, navigate to the client page.
          toClient();
        } 
  }
}


