import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class AppProgressIndicator extends StatefulWidget {
  final String description;
  final int max;
  final int currentProgress;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? descriptionPadding;
  const AppProgressIndicator(
      {Key? key,
      this.padding,
      this.descriptionPadding,
      required this.description,
      required this.max,
      required this.currentProgress})
      : super(key: key);

  @override
  State<AppProgressIndicator> createState() => _AppProgressIndicatorState();
}

class _AppProgressIndicatorState extends State<AppProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getCurrentProgress(),
          Padding(
            padding: widget.descriptionPadding ??  const EdgeInsets.only(top: 16),
            child: Text(
              widget.description,
              style: getTextStyle(
                  textColor: AppColors.tertiaryBlue,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.regular,
                  fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget progressBox(isDone) => Container(
        height: 34,
        width: 34,
        color: isDone ? AppColors.tertiaryBlue : AppColors.greyD9,
      );

  Widget getCurrentProgress() {
    List<Widget> progressWidget = [
      progressBox(widget.currentProgress >= 1),
    ];

    for (int i = 0; i < widget.max - 1; i++) {
      bool isDone = widget.currentProgress > i + 1;

      progressWidget.addAll(tripleDot(isDone));
      progressWidget.add(Padding(
        padding: const EdgeInsets.only(left: 10),
        child: progressBox(isDone),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: progressWidget,
    );
  }

  List<Widget> tripleDot(isDone) {
    return List.generate(
      3,
      (index) => Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
              color: isDone ? AppColors.secondaryBlue : AppColors.greyD9,
              shape: BoxShape.circle),
        ),
      ),
    );
  }
}
