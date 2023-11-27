import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laborlink/Pages/Client/Activity/ClientActivityPage.dart';
import 'package:laborlink/Pages/Client/Home/ClientHomePage.dart';
import 'package:laborlink/Pages/Profile/ProfilePage.dart';
import 'package:laborlink/Pages/Report/IssuesReportedPage.dart';
import 'package:laborlink/Pages/LoadingPage.dart';
import 'package:laborlink/Widgets/NavBars/BottomNavBar.dart';
import 'package:laborlink/services/analytics_service.dart';
import 'package:laborlink/styles.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
AnalyticsService _analytics = AnalyticsService();

class ClientMainPage extends StatefulWidget {
  final String userId;
  const ClientMainPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ClientMainPage> createState() => _ClientMainPageState();
}

class _ClientMainPageState extends State<ClientMainPage> {
  int _selectedIndex = 0;
  DateTime? currentBackPressTime;

  _login() async {
    print('>>>>>>>${_auth.currentUser!.uid}');
    await _analytics.setUserProperties(
        userId: _auth.currentUser!.uid, userRole: 'client');
  }

  @override
  void initState() {
    // TODO: implement initState
    _login();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: selectedPage()),
              AppBottomNavBar(
                selectedIndex: _selectedIndex,
                onChanged: updateSelectedIndex,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Exit?');
      return Future.value(false);
    }
    return Future.value(true);
  }

  void updateSelectedIndex(int selectedIndex) {
    setState(() {
      _selectedIndex = selectedIndex;
    });
  }

  Widget selectedPage() {
    if (_selectedIndex == 0) {
      return ClientHomePage(
          navigateToNewPage: updateSelectedIndex, userId: widget.userId);
    } else if (_selectedIndex == 1) {
      return ClientActivityPage(
          navigateToNewPage: updateSelectedIndex, userId: widget.userId);
    } else if (_selectedIndex == 2) {
      return IssuesReportedPage(userId: widget.userId);
    }

    return ProfilePage(userId: widget.userId);
  }
}
