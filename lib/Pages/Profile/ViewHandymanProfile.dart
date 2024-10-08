import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/Cards/ReviewCard.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/database_service.dart';

class ViewHandymanProfile extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  const ViewHandymanProfile({Key? key, required this.handymanInfo})
      : super(key: key);

  @override
  State<ViewHandymanProfile> createState() => _ViewHandymanProfileState();
}

class _ViewHandymanProfileState extends State<ViewHandymanProfile> {
  List<Map<String, dynamic>> results = [];
  final DatabaseService service = DatabaseService();
  bool isReviewsVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      getReviews();
      setState(() {
        isReviewsVisible = true;
      });
    });
  }

  void getReviews() async {
    try {
      results = await service.getHandymanReviews(widget.handymanInfo["ActiveUserId"], widget.handymanInfo["userRole"]);
      print("testing");
      setState(() {
        results = results;
      });
    } catch (error) {
      // print('Error fetching user data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching user data."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: SizedBox(
          width: deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBar(),
              Expanded(
                child: Container(
                  color: AppColors.dirtyWhite,
                  child: Stack(
                    children: [
                      if (isReviewsVisible) reviewsSection(),
                      HandymanInfoCard(handymanInfo: widget.handymanInfo),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onBack() => Navigator.of(context).pop();

  Widget appBar() => Padding(
        padding: const EdgeInsets.only(left: 26, bottom: 14, top: 34),
        child: GestureDetector(
          onTap: onBack,
          child:
              Image.asset("assets/icons/back-btn.png", height: 13, width: 17.5),
        ),
      );

  Widget reviewsSection() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 94, left: 10, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reviews",
                style: getTextStyle(
                    textColor: AppColors.secondaryBlue,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.regular,
                    fontSize: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> currentReview = results[index];
                    String fullName = '';

                    if (currentReview['firstName'] != null) {
                      fullName += currentReview['firstName'] + ' ';
                    }
                    if (currentReview['middle'] != null) {
                      fullName += currentReview['middle'] + ' ';
                    }
                    if (currentReview['lastName'] != null) {
                      fullName += currentReview['lastName'] + ' ';
                    }
                    if (currentReview['suffix'] != null) {
                      fullName += currentReview['suffix'] + ' ';
                    }
                    DateTime? createdAt = currentReview['actualDate']?.toDate();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: ReviewCard(
                        rate:
                            (currentReview["rating"] as double?)?.toInt() ?? 0,
                        date: createdAt != null
                            ? DateFormat.yMMMMd().format(createdAt)
                            : DateFormat.yMMMMd().format(DateTime.now()),
                        reviewerName: fullName,
                        review: currentReview["comment"] ?? ' ',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
