import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/styles.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 124,
      child: Row(
        children: [
          AppFilledButton(
            height: 35,
            text: "Log Out",
            fontSize: 12,
            fontFamily: AppFonts.montserrat,
            color: AppColors.accentOrange,
            suffixIcon: Image.asset(
                "assets/icons/logout-filled-white.png",
                width: 15),
            command: onLogout,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }

  void onLogout() {
    yesCancelDialog(context, "Are you sure you want to log out?");
  }
}
