import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:laborlink/styles.dart';

class AppBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const AppBottomNavBar(
      {Key? key, required this.selectedIndex, required this.onChanged})
      : super(key: key);

  @override
  State<AppBottomNavBar> createState() => AppBottomNavBarState();
}

class AppBottomNavBarState extends State<AppBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Visibility(
          visible: !isKeyboardVisible,
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.handyman_outlined), label: "Activity"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.flag_outlined), label: "Report"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: "Profile"),
            ],
            selectedItemColor: AppColors.primaryBlue,
            currentIndex: widget.selectedIndex,
            onTap: (index) => setState(() {
              widget.onChanged(index);
            }),
            unselectedItemColor: AppColors.grey,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            selectedLabelStyle: getTextStyle(
                textColor: AppColors.primaryBlue,
                fontFamily: AppFonts.montserrat,
                fontWeight: AppFontWeights.semiBold,
                fontSize: 7),
            unselectedLabelStyle: getTextStyle(
                textColor: AppColors.primaryBlue,
                fontFamily: AppFonts.montserrat,
                fontWeight: AppFontWeights.semiBold,
                fontSize: 7),
          ),
        );
      },
    );
  }
}
