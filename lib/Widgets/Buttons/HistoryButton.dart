import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class HistoryButton extends StatefulWidget {
  final VoidCallback command;
  final Color? backgroundColor;

  const HistoryButton({Key? key, this.backgroundColor, required this.command}) : super(key: key);

  @override
  State<HistoryButton> createState() => _HistoryButtonState();
}

class _HistoryButtonState extends State<HistoryButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.command,
          child: Container(
            height: 41,
            width: 41,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? AppColors.dirtyWhite,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Transform.rotate(
                angle: 0.4,
                child: Transform.scale(
                    scale: 0.6,
                    child: Image.asset("assets/icons/receipt-solid.png"))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            "History",
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
