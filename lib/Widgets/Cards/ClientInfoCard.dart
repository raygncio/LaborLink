import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/RateWidget.dart';
import 'package:laborlink/styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ClientInfoCard extends StatefulWidget {
  final Map<String, dynamic> clientInfo;
  const ClientInfoCard({Key? key, required this.clientInfo}) : super(key: key);

  @override
  State<ClientInfoCard> createState() => ClientInfoCardState();
}

class ClientInfoCardState extends State<ClientInfoCard> {
  @override
  Widget build(BuildContext context) {
    String firstName = widget.clientInfo['firstName'] ?? '';
    String middleName = widget.clientInfo['middleName'] ?? '';
    String lastName = widget.clientInfo['lastName'] ?? '';
    String suffix = widget.clientInfo['suffix'] ?? '';

    String fullname = '$firstName $middleName $lastName $suffix';
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 12,
              color: AppColors.blackShadow,
            ),
          ]),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 14, right: 10, top: 10, bottom: 10),
        child: Row(
          children: [
            SizedBox(
              height: 61,
              width: 61,
              child: ClipOval(
                child: Image.asset('assets/icons/person-circle-blue.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fullname,
                      style: getTextStyle(
                          textColor: AppColors.primaryBlue,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      children: [
                        AppBadge(
                            label: widget.clientInfo["city"] ?? '',
                            type: BadgeType.normal)
                      ],
                    ),
                  ),
                  // *************** RATINGS
                  // static ratings
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: RatingBar.builder(
                        initialRating: 3, // input
                        itemCount: 5,
                        itemSize: 15,
                        ignoreGestures: true,
                        itemBuilder: (ctx, index) => const Icon(
                              Icons.star,
                              color: AppColors.secondaryYellow,
                            ),
                        onRatingUpdate: (rating) {}),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
