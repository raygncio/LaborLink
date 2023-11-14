import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laborlink/Pages/Admin/AdminDashboard.dart';
import 'package:laborlink/Pages/Client/ClientMainPage.dart';
import 'package:laborlink/Pages/Client/Home/ClientHomePage.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/Pages/LandingPage.dart';
import 'package:laborlink/Pages/Registration/ClientRegistrationPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((fn) {
//     Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     ).then((fn) {
//       runApp(const MyApp());
//     });
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'LaborLink',
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
