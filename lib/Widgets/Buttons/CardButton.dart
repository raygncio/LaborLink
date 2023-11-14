import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class CardButtonWidget extends StatelessWidget {
  final bool isSelected;
  final String imgPath;
  final String description;
  final VoidCallback? command;

  const CardButtonWidget(
      {Key? key,
      required this.imgPath,
      required this.description,
      required this.isSelected,
      required this.command})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: command,
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: isSelected ? AppColors.tertiaryBlue : AppColors.grey),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image.asset(
                imgPath,
                height: 121,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 7, left: 11, right: 11, bottom: 11),
              child: Text(
                description,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: getTextStyle(
                    textColor: AppColors.tertiaryBlue,
                    fontFamily: AppFonts.poppins,
                    fontWeight: AppFontWeights.medium,
                    fontSize: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
