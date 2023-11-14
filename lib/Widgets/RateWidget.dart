import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class RateWidget extends StatefulWidget {
  final int rate;
  final double iconSize;

  const RateWidget({Key? key, required this.rate, required this.iconSize})
      : super(key: key);

  @override
  State<RateWidget> createState() => _RateWidgetState();
}

class _RateWidgetState extends State<RateWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
          widget.rate,
          (index) => Icon(
                Icons.star_rounded,
                color: AppColors.secondaryYellow,
                size: widget.iconSize,
              )),
    );
  }
}
