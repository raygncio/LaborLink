import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class MessageButton extends StatefulWidget {
  final VoidCallback command;

  const MessageButton({Key? key, required this.command}) : super(key: key);

  @override
  State<MessageButton> createState() => _MessageButtonState();
}

class _MessageButtonState extends State<MessageButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.command,
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.dirtyWhite,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.asset(
              "assets/icons/message-solid.png",
              width: 23,
              height: 23,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            "Message",
            style: getTextStyle(
                textColor: AppColors.black,
                fontFamily: AppFonts.montserrat,
                fontWeight: AppFontWeights.medium,
                fontSize: 8),
          ),
        )
      ],
    );
  }
}
