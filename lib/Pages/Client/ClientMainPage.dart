import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Client/Activity/ClientActivityPage.dart';
import 'package:laborlink/Pages/Client/Home/ClientHomePage.dart';
import 'package:laborlink/Pages/Profile/ProfilePage.dart';
import 'package:laborlink/Pages/Report/IssuesReportedPage.dart';
import 'package:laborlink/Pages/LoadingPage.dart';
import 'package:laborlink/Widgets/NavBars/BottomNavBar.dart';
import 'package:laborlink/styles.dart';

class ClientMainPage extends StatefulWidget {
  final String userId;
  const ClientMainPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ClientMainPage> createState() => _ClientMainPageState();
}

class _ClientMainPageState extends State<ClientMainPage> {
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
