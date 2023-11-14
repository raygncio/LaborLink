import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class AppCheckBox extends StatefulWidget {
  final String label;
  final TextStyle? labelStyle;
  final Color checkboxColor;
  final double borderRadius;
  final double borderWidth;
  final Function(bool) onChanged;

  const AppCheckBox(
      {Key? key,
      required this.label,
      required this.labelStyle,
      required this.checkboxColor,
      required this.borderRadius,
      required this.borderWidth,
      required this.onChanged})
      : super(key: key);

  @override
  State<AppCheckBox> createState() => AppCheckBoxState();
}

class AppCheckBoxState extends State<AppCheckBox> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.7,
          child: Checkbox(
            visualDensity: VisualDensity.compact,
            value: isSelected,
            onChanged: (value) => updateValue(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide(
              color: widget.checkboxColor,
              width: widget.borderWidth,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            activeColor: AppColors.tertiaryBlue,
          ),
        ),
        GestureDetector(
          onTap: updateValue,
          child: Text(
            widget.label,
            style: widget.labelStyle,
          ),
        ),
      ],
    );
  }

  void updateValue() {
    setState(() {
      isSelected = !isSelected;
      widget.onChanged(isSelected);
    });
  }
}
