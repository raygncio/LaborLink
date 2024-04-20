import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/Widgets/Badge.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/TextFormFields/TextAreaFormField.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/review.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/Pages/Client/ClientMainPage.dart';

class RatingsPage extends StatefulWidget {
  final Map<String, dynamic> ratings;
  final String user;
  const RatingsPage({Key? key, required this.ratings, required this.user})
      : super(key: key);

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  final _reviewController = TextEditingController();
  double rating = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String firstName = widget.ratings['firstName'] ?? '';
    String middleName = widget.ratings['middleName'] ?? '';
    String lastName = widget.ratings['lastName'] ?? '';
    String suffix = widget.ratings['suffix'] ?? '';

    String fullname =
        '${firstName[0].toUpperCase()}${firstName.substring(1).toLowerCase()} $middleName ${lastName[0].toUpperCase()}${lastName.substring(1).toLowerCase()} $suffix';
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SizedBox(
          width: deviceWidth,
          child: Stack(
            children: [
              SizedBox(
                width: deviceWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 98 + 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          fullname,
                          style: getTextStyle(
                              textColor: AppColors.secondaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 25),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: Container(
                                height: 21.18,
                                width: 21.18,
                                decoration: BoxDecoration(
                                  color: AppColors.dirtyWhite,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Image.asset(
                                    "assets/icons/${widget.ratings['specialization'].toString().toLowerCase()}.png",
                                    width: 23.53,
                                    height: 22.59),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: Text(
                                widget.ratings['title'],
                                style: getTextStyle(
                                    textColor: AppColors.secondaryBlue,
                                    fontFamily: AppFonts.montserrat,
                                    fontWeight: AppFontWeights.bold,
                                    fontSize: 10),
                              ),
                            ),
                            AppBadge(
                              label: widget.ratings['userRole'] == 'client'
                                  ? 'Client'
                                  : "Handyman",
                              type: BadgeType.normal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 43),
                          child: Text(
                            "Rate your overall experience!",
                            style: getTextStyle(
                                textColor: AppColors.secondaryBlue,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.bold,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "We would love to hear your feedback",
                            style: getTextStyle(
                                textColor: AppColors.black,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.regular,
                                fontSize: 15),
                          ),
                        ),
                        ratingWidget(),
                        Padding(
                          padding: const EdgeInsets.only(top: 27),
                          child: Text(
                            "Tell us about the service!",
                            style: getTextStyle(
                                textColor: AppColors.secondaryBlue,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.regular,
                                fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 38, right: 37, top: 6),
                          child: TextAreaFormField(
                              controller: _reviewController,
                              height: 199,
                              maxLength: 100,
                              inputTextStyle: getTextStyle(
                                  textColor: AppColors.black,
                                  fontFamily: AppFonts.montserrat,
                                  fontWeight: AppFontWeights.regular,
                                  fontSize: 12),
                              defaultBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: AppColors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: AppColors.grey),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            width: 127,
                            child: Row(
                              children: [
                                AppFilledButton(
                                    height: 32,
                                    text: "Submit",
                                    fontSize: 15,
                                    fontFamily: AppFonts.montserrat,
                                    color: AppColors.accentOrange,
                                    command: submitRating,
                                    borderRadius: 5),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 98,
                width: deviceWidth,
                decoration: const BoxDecoration(
                    color: AppColors.secondaryBlue,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: AppColors.blackShadow,
                      )
                    ]),
                child: Stack(
                  children: [
                    // Positioned(
                    //   top: 17,
                    //   left: 14,
                    //   child: GestureDetector(
                    //     onTap: onBack,
                    //     child: Image.asset(
                    //       "assets/icons/back-btn-2.png",
                    //       width: 12,
                    //       height: 23,
                    //     ),
                    //   ),
                    // ),
                    Align(
                      alignment: const FractionalOffset(0.5, 5),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                            color: AppColors.white, shape: BoxShape.circle),
                        child: ClipOval(
                            child:
                                Image.network(imgUrl, width: 75, height: 75)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ratingWidget() => Padding(
        padding: const EdgeInsets.only(top: 23),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  rating = 1;
                });
              },
              child: Icon(
                Icons.star_rounded,
                color: rating >= 1
                    ? AppColors.secondaryYellow
                    : AppColors.dirtyWhite,
                size: 36,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  rating = 2;
                });
              },
              child: Icon(
                Icons.star_rounded,
                color: rating >= 2
                    ? AppColors.secondaryYellow
                    : AppColors.dirtyWhite,
                size: 36,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  rating = 3;
                });
              },
              child: Icon(
                Icons.star_rounded,
                color: rating >= 3
                    ? AppColors.secondaryYellow
                    : AppColors.dirtyWhite,
                size: 36,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  rating = 4;
                });
              },
              child: Icon(
                Icons.star_rounded,
                color: rating >= 4
                    ? AppColors.secondaryYellow
                    : AppColors.dirtyWhite,
                size: 36,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  rating = 5;
                });
              },
              child: Icon(
                Icons.star_rounded,
                color: rating >= 5
                    ? AppColors.secondaryYellow
                    : AppColors.dirtyWhite,
                size: 36,
              ),
            ),
          ],
        ),
      );

  void submitRating() async {
    // Get the values
    double selectedRating = rating;
    String review = _reviewController.text;

    // Validate if the user has selected a rating
    if (selectedRating == 0 || review == " ") {
      // Handle errors during user creation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please rate the user before submitting."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      DatabaseService service = DatabaseService();
      try {
         String userId = widget.user == 'client'
          ? widget.ratings["clientId"]
          : widget.ratings["handymanId"];

        Review reviews = Review(
          rating: selectedRating,
          comment: review,
          userId: userId,
          requestId: widget.ratings["requestId"],
        );

        await service.addReviews(reviews);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reviews submitted succesfully."),
            backgroundColor: Colors.orangeAccent,
          ),
        );

        if (widget.user == 'client') {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  ClientMainPage(userId: widget.ratings["clientId"]),
            ));
          });
        } else {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  HandymanMainPage(userId: widget.ratings["handymanId"]),
            ));
          });
        }
      } catch (e) {
        // Handle errors during user creation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error creating user: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void onBack() => Navigator.of(context).pop();
}
