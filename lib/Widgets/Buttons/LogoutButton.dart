import 'package:flutter/material.dart';
import 'package:laborlink/Pages/LoginPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/providers/current_user_provider.dart';
import 'package:laborlink/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laborlink/Pages/LandingPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutButton extends ConsumerStatefulWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  ConsumerState<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends ConsumerState<LogoutButton> {
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
            suffixIcon:
                Image.asset("assets/icons/logout-filled-white.png", width: 15),
            command: onLogout,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }

  void onLogout() {
    yesCancelDialog(context, "Are you sure you want to log out?").then((value) {
      if (value == "yes") {
        ref.invalidate(currentUserProvider);
        FirebaseAuth.instance.signOut();

        // Navigator.of(context).pop();

        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (ctx) => const LandingPage(),
        //   ),
        //   (route) => false,
        // );

        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (ctx) => const LandingPage(),
        //   ),
        // );

        //Navigator.of(context).popUntil((route) => false);
      }
    });
  }
}
