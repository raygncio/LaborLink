import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

class AppDropdown extends StatefulWidget {
  final bool isDirectRequest;
  final String? directCategory;
  final String? label;
  final TextStyle? labelTextStyle;
  final EdgeInsetsGeometry? labelPadding;
  final double? height;
  final double? width;
  final Function(String) onChanged;

  final List<String> dropdownValues;
  const AppDropdown(
      {Key? key,
      required this.isDirectRequest,
      this.directCategory,
      this.label,
      this.labelTextStyle,
      this.labelPadding,
      required this.height,
      required this.width,
      required this.dropdownValues,
      required this.onChanged})
      : super(key: key);

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  String? _dropdownValue;

  @override
  void initState() {
    if (widget.isDirectRequest) {
      _dropdownValue = widget.dropdownValues.firstWhere(
          (element) => element.toLowerCase() == widget.directCategory,
          orElse: () => widget.dropdownValues.first);
    } else {
      _dropdownValue = widget.dropdownValues.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.label != null,
          child: Padding(
            padding: widget.labelPadding ?? const EdgeInsets.only(bottom: 4),
            child: Text(
              widget.label ?? "",
              style: widget.labelTextStyle,
            ),
          ),
        ),
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.secondaryBlue)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _dropdownValue,
              isDense: true,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.secondaryBlue,
              ),
              style: getTextStyle(
                  textColor: AppColors.black,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.regular,
                  fontSize: 10),
              items: widget.dropdownValues
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  _dropdownValue = value!;
                  widget.onChanged(_dropdownValue!);
                });
              },
            ),
          ),
        )
      ],
    );
  }
}
