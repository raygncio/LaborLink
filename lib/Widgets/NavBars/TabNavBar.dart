import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class AppTabNavBar extends StatefulWidget {
  final int selectedTabIndex;
  final String leftLabel;
  final String rightLabel;
  final Function(int) onChanged;

  const AppTabNavBar(
      {Key? key,
      required this.selectedTabIndex,
      required this.leftLabel,
      required this.rightLabel,
      required this.onChanged})
      : super(key: key);

  @override
  State<AppTabNavBar> createState() => AppTabNavBarState();
}

class AppTabNavBarState extends State<AppTabNavBar> {
  Color selectedFg = AppColors.black;
  Color selectedBg = AppColors.white;
  Color unselectedFg = AppColors.white;
  Color unselectedBg = AppColors.primaryBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: <double>[
            0.5,
            0.5
          ],
              colors: <Color>[
            AppColors.primaryBlue,
            AppColors.white,
          ])),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => updateSelectedTabIndex(0),
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: widget.selectedTabIndex == 0 ? selectedBg : unselectedBg,
                  borderRadius: widget.selectedTabIndex == 0
                      ? const BorderRadius.only(topRight: Radius.circular(10))
                      : const BorderRadius.only(
                          bottomRight: Radius.circular(10)),
                ),
                child: Center(
                    child: Text(widget.leftLabel,
                        style: getTextStyle(
                            textColor: widget.selectedTabIndex == 0
                                ? selectedFg
                                : unselectedFg,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 15))),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => updateSelectedTabIndex(1),
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                    color: widget.selectedTabIndex == 1 ? selectedBg : unselectedBg,
                    borderRadius: widget.selectedTabIndex == 1
                        ? const BorderRadius.only(topLeft: Radius.circular(10))
                        : const BorderRadius.only(
                            bottomLeft: Radius.circular(10))),
                child: Center(
                    child: Text(widget.rightLabel,
                        style: getTextStyle(
                            textColor: widget.selectedTabIndex == 1
                                ? selectedFg
                                : unselectedFg,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 15))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateSelectedTabIndex(int selectedTabIndex) {
    widget.onChanged(selectedTabIndex);
  }
}
