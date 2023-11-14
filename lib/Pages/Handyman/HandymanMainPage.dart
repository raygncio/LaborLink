import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/ClientActivityPage.dart';
import 'package:laborlink/Pages/Client/Home/ClientHomePage.dart';
import 'package:laborlink/Pages/Handyman/Activity/HandymanActivityPage.dart';
import 'package:laborlink/Pages/Handyman/Home/HanymanHomePage.dart';
import 'package:laborlink/Pages/LoadingPage.dart';
import 'package:laborlink/Pages/Profile/ProfilePage.dart';
import 'package:laborlink/Pages/Report/IssuesReportedPage.dart';
import 'package:laborlink/Pages/Report/ReportIssuePage.dart';
import 'package:laborlink/Pages/Report/ReportSubmittedPage.dart';
import 'package:laborlink/Widgets/NavBars/BottomNavBar.dart';
import 'package:laborlink/styles.dart';

class HandymanMainPage extends StatefulWidget {
  const HandymanMainPage({Key? key}) : super(key: key);

  @override
  State<HandymanMainPage> createState() => _HandymanMainPageState();
}

class _HandymanMainPageState extends State<HandymanMainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
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
    );
  }

  void updateSelectedIndex(int selectedIndex) {
    setState(() {
      _selectedIndex = selectedIndex;
    });
  }

  Widget selectedPage() {
    if (_selectedIndex == 0) {
      return HandymanHomePage(
        navigateToNewPage: updateSelectedIndex,
      );
    } else if (_selectedIndex == 1) {
      return HandymanActivityPage(
        navigateToNewPage: updateSelectedIndex,
      );
    }
    else if (_selectedIndex == 2){
      return const IssuesReportedPage();
    }

    return const ProfilePage();
  }
}
