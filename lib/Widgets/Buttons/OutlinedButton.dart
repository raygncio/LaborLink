import 'package:flutter/material.dart';

import '../../styles.dart';

class AppOutlinedButton extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final double? height;
  final Color color;
  final double borderRadius;
  final double? borderWidth;
  final VoidCallback? command;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? padding;

  const AppOutlinedButton(
      {Key? key,
      this.prefixIcon,
      this.height,
      this.padding,
      this.textStyle,
      this.borderWidth,
      required this.text,
      required this.color,
      required this.command,
      required this.borderRadius})
      : super(key: key);

  @override
  State<AppOutlinedButton> createState() => _AppOutlinedButtonState();
}

class _AppOutlinedButtonState extends State<AppOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    // final deviceWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: SizedBox(
          height: widget.height ?? 42,
          child: OutlinedButton(
            onPressed: widget.command,
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius))),
                side: MaterialStateProperty.all<BorderSide>(BorderSide(
                    color: widget.color, width: widget.borderWidth ?? 2))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: widget.prefixIcon != null,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 9),
                    child: widget.prefixIcon,
                  ),
                ),
                Text(
                  widget.text,
                  style: widget.textStyle ??
                      getTextStyle(
                          textColor: widget.color,
                          fontFamily: AppFonts.poppins,
                          fontWeight: AppFontWeights.bold,
                          fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
