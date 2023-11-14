import 'package:flutter/material.dart';
import 'package:laborlink/styles.dart';

enum BadgeType {
  normal,
  inProgress,
  complete,
  blocked,
  offer,
}

class AppBadge extends StatefulWidget {
  final String label;
  final BadgeType type;
  final EdgeInsetsGeometry? padding;

  const AppBadge({Key? key, this.padding, required this.label, required this.type})
      : super(key: key);

  @override
  State<AppBadge> createState() => _AppBadgeState();
}

class _AppBadgeState extends State<AppBadge> {
  Map<BadgeType, Map<String, Color>> tagColor = {
    BadgeType.normal: {
      "fg": AppColors.primaryBlue,
      "bg": AppColors.blueBadge,
    },
    BadgeType.inProgress: {
      "fg": AppColors.accentOrange,
      "bg": AppColors.orangeBadge,
    },
    BadgeType.complete: {
      "fg": AppColors.green,
      "bg": AppColors.greenBadge,
    },
    BadgeType.blocked: {
      "fg": AppColors.black,
      "bg": AppColors.blackBadge,
    },
    BadgeType.offer: {
      "fg": AppColors.pink,
      "bg": AppColors.pinkBadge,
    }
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(3),
      color: tagColor[widget.type]!["bg"],
      child: Text(
        widget.label,
        style: getTextStyle(
            textColor: tagColor[widget.type]!['fg'],
            fontFamily: AppFonts.montserrat,
            fontWeight: AppFontWeights.medium,
            fontSize: 9),
      ),
    );
  }
}
