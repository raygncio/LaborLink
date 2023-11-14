import 'package:flutter/material.dart';

import '../../styles.dart';

class AppFilledButton extends StatefulWidget {
  final String text;
  final Color? textColor;
  final Color color;
  final double borderRadius;
  final VoidCallback? command;
  final double? height;
  final double fontSize;
  final String? fontFamily;
  final bool? enabled;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;

  const AppFilledButton(
      {Key? key,
      this.height,
      this.padding,
      this.enabled,
      this.textColor,
      this.suffixIcon,
      required this.text,
      required this.fontSize,
      required this.fontFamily,
      required this.color,
      required this.command,
      required this.borderRadius})
      : super(key: key);

  @override
  State<AppFilledButton> createState() => _AppFilledButtonState();
}

class _AppFilledButtonState extends State<AppFilledButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: widget.padding == null ? EdgeInsets.zero : widget.padding!,
        child: SizedBox(
          height: widget.height,
          child: TextButton(
            onPressed: widget.enabled == null ||
                    (widget.enabled != null && widget.enabled == true)
                ? widget.command
                : null,
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: MaterialStateProperty.all<Color>(
                  widget.enabled == null ||
                          (widget.enabled != null && widget.enabled == true)
                      ? widget.color
                      : AppColors.grey),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(widget.borderRadius))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: getTextStyle(
                      textColor: widget.textColor ?? AppColors.white,
                      fontFamily: widget.fontFamily,
                      fontWeight: AppFontWeights.bold,
                      fontSize: widget.fontSize),
                ),
                Visibility(
                  visible: widget.suffixIcon != null,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: widget.suffixIcon,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
