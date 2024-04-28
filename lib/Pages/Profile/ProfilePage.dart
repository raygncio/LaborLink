import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Profile/CreditBalancePage.dart';
import 'package:laborlink/Pages/Profile/ViewHandymanProfile.dart';
import 'package:laborlink/Pages/Report/ReportIssuePage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/LogoutButton.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/client.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

final _firebase = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DatabaseService service = DatabaseService();
  final _fullNameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  String? _userRole;
  double? balance;

  Map<String, dynamic> getUserInfo = {};

  File? defaultAvatar;
  final _labelTextStyle = getTextStyle(
      textColor: AppColors.black,
      fontFamily: AppFonts.montserrat,
      fontWeight: AppFontWeights.semiBold,
      fontSize: 11);

  final _inputTextStyle = getTextStyle(
      textColor: AppColors.black,
      fontFamily: AppFonts.montserrat,
      fontWeight: AppFontWeights.semiBold,
      fontSize: 12);

  final _defaultBorder = Border.all(color: AppColors.secondaryBlue, width: 1);
  GestureDetector buildClickableIcon(Widget iconWidget, Function() onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: iconWidget,
    );
  }

  @override
  void initState() {
    // _fullNameController.text = "Allan Ray C. Escueta";
    // _birthdateController.text = "August 8, 2023";
    // _emailController.text = "customer@gmail.com";
    // _phoneNumberController.text = "09171234567";
    // _addressController.text = "Tønsberg, Norway";

    super.initState();
    fetchUserData();
    _loadDefaultAvatar();
    _getCreditBalance();
  }

  _getCreditBalance() async {
    balance = await service.computeCreditBalance(widget.userId);
    setState(() {});
  }

  Future<void> _loadDefaultAvatar() async {
    defaultAvatar =
        await getImageFileFromAssets('icons/person-circle-blue.png');
    setState(() {}); // Update the state to display the default avatar
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<void> fetchUserData() async {
    try {
      Client clientInfo = await service.getUserData(widget.userId);
      getUserInfo = await service.getUserInfo(widget.userId);
      String fullName =
          '${clientInfo.firstName[0].toUpperCase()}${clientInfo.firstName.substring(1).toLowerCase()} ${clientInfo.middleName ?? " "} ${clientInfo.lastName[0].toUpperCase()}${clientInfo.lastName.substring(1).toLowerCase()} ${clientInfo.suffix ?? ""}';

      String formattedDate =
          DateFormat('MMMM d, y').format(clientInfo.dob!); // Format the date

      String address =
          '${clientInfo.streetAddress} ${clientInfo.city ?? " "} ${clientInfo.state} ${clientInfo.zipCode ?? ""}';

      setState(() {
        _fullNameController.text = fullName;
        _birthdateController.text = formattedDate;
        _emailController.text = clientInfo.emailAdd;
        _phoneNumberController.text = '0${clientInfo.phoneNumber}';
        _addressController.text = address;
        _userRole = clientInfo.userRole;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void payCreditBalance() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return CreditBalancePage(
            userId: widget.userId,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthdateController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: deviceWidth,
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Profile",
                        style: getTextStyle(
                            textColor: AppColors.secondaryYellow,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 27),
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(7),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/icons/person-circle-blue.png', // Add placeholder image path here
                                width: 75,
                                height: 75,
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 10,
                            right: 13,
                            child: CircleAvatar(
                              backgroundColor: AppColors.secondaryBlue,
                              maxRadius: 8,
                              child: Icon(
                                Icons.edit,
                                size: 7,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _fullNameController.text,
                        style: getTextStyle(
                            textColor: AppColors.white,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _emailController.text,
                        style: getTextStyle(
                            textColor: AppColors.white,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.regular,
                            fontSize: 10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 11),
                      child: SizedBox(
                        width: 155,
                        child: Row(
                          children: [
                            AppFilledButton(
                              height: 27,
                              text: "Reviews and Ratings",
                              fontSize: 12,
                              fontFamily: AppFonts.montserrat,
                              color: AppColors.secondaryYellow,
                              command: onViewReviewsAndRatings,
                              borderRadius: 8,
                              textColor: AppColors.secondaryBlue,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: deviceWidth,
                    color: AppColors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 34, right: 52, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _userRole == 'handyman'
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Credit Balance",
                                            style: getTextStyle(
                                                textColor: AppColors.black,
                                                fontFamily: AppFonts.montserrat,
                                                fontWeight: AppFontWeights.bold,
                                                fontSize: 14),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, left: 18),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 35,
                                                  child: Stack(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          AppFilledButton(
                                                            text: balance == 0.0
                                                                ? 'No balance'
                                                                : 'Php${balance.toString()}',
                                                            fontFamily: AppFonts
                                                                .montserrat,
                                                            fontSize: 12,
                                                            color: AppColors
                                                                .secondaryBlue,
                                                            command:
                                                                payCreditBalance,
                                                            borderRadius: 8,
                                                          ),
                                                        ],
                                                      ),
                                                      const Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20),
                                                            child: Icon(
                                                              Icons.payment,
                                                              color: AppColors
                                                                  .white,
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.secondaryBlue,
                                        strokeWidth: 4,
                                      ),
                                    ),
                              Text(
                                "My Information",
                                style: getTextStyle(
                                    textColor: AppColors.black,
                                    fontFamily: AppFonts.montserrat,
                                    fontWeight: AppFontWeights.bold,
                                    fontSize: 14),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 22, left: 18),
                                child: Column(
                                  children: [
                                    AppNormalTextFormField(
                                        label: "Full Name",
                                        labelTextStyle: _labelTextStyle,
                                        labelPadding: const EdgeInsets.only(
                                            left: 8, bottom: 5),
                                        borderRadius: 8,
                                        controller: _fullNameController,
                                        contentPadding: const EdgeInsets.only(
                                            left: 17, right: 11),
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                              "assets/icons/person-circle-blue.png",
                                              height: 24,
                                              width: 24),
                                        ),
                                        suffixIcon: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: buildClickableIcon(
                                            Image.asset(
                                              "assets/icons/edit-filled-blue.png",
                                              height: 16,
                                              width: 16,
                                            ),
                                            () {
                                              print("Edit icon clicked");
                                            },
                                          ),
                                        ),
                                        height: 35,
                                        inputTextStyle: _inputTextStyle,
                                        textAlign: TextAlign.center,
                                        defaultBorder: _defaultBorder,
                                        errorBorder: _defaultBorder),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: AppNormalTextFormField(
                                          label: "Birthdate",
                                          labelTextStyle: _labelTextStyle,
                                          labelPadding: const EdgeInsets.only(
                                              left: 8, bottom: 5),
                                          borderRadius: 8,
                                          controller: _birthdateController,
                                          contentPadding: const EdgeInsets.only(
                                              left: 17, right: 11),
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Image.asset(
                                                "assets/icons/calendar-filled-blue.png",
                                                height: 21,
                                                width: 21),
                                          ),
                                          suffixIcon: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: buildClickableIcon(
                                              Image.asset(
                                                "assets/icons/edit-filled-blue.png",
                                                height: 16,
                                                width: 16,
                                              ),
                                              () {
                                                print("Edit icon clicked");
                                              },
                                            ),
                                          ),
                                          height: 35,
                                          inputTextStyle: _inputTextStyle,
                                          textAlign: TextAlign.center,
                                          defaultBorder: _defaultBorder,
                                          errorBorder: _defaultBorder),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: AppNormalTextFormField(
                                          label: "Email",
                                          labelTextStyle: _labelTextStyle,
                                          labelPadding: const EdgeInsets.only(
                                              left: 8, bottom: 5),
                                          borderRadius: 8,
                                          controller: _emailController,
                                          contentPadding: const EdgeInsets.only(
                                              left: 17, right: 11),
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Image.asset(
                                                "assets/icons/email-filled-blue.png",
                                                height: 24,
                                                width: 24),
                                          ),
                                          suffixIcon: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: buildClickableIcon(
                                              Image.asset(
                                                "assets/icons/edit-filled-blue.png",
                                                height: 16,
                                                width: 16,
                                              ),
                                              () {
                                                print("Edit icon clicked");
                                              },
                                            ),
                                          ),
                                          height: 35,
                                          inputTextStyle: _inputTextStyle,
                                          textAlign: TextAlign.center,
                                          defaultBorder: _defaultBorder,
                                          errorBorder: _defaultBorder),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: AppNormalTextFormField(
                                          label: "Phone Number",
                                          labelTextStyle: _labelTextStyle,
                                          labelPadding: const EdgeInsets.only(
                                              left: 8, bottom: 5),
                                          borderRadius: 8,
                                          controller: _phoneNumberController,
                                          contentPadding: const EdgeInsets.only(
                                              left: 17, right: 11),
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Image.asset(
                                                "assets/icons/phone-filled-blue.png",
                                                height: 24,
                                                width: 24),
                                          ),
                                          suffixIcon: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: buildClickableIcon(
                                              Image.asset(
                                                "assets/icons/edit-filled-blue.png",
                                                height: 16,
                                                width: 16,
                                              ),
                                              () {
                                                print("Edit icon clicked");
                                              },
                                            ),
                                          ),
                                          height: 35,
                                          inputTextStyle: _inputTextStyle,
                                          textAlign: TextAlign.center,
                                          defaultBorder: _defaultBorder,
                                          errorBorder: _defaultBorder),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: AppNormalTextFormField(
                                          label: "Address",
                                          labelTextStyle: _labelTextStyle,
                                          labelPadding: const EdgeInsets.only(
                                              left: 8, bottom: 5),
                                          borderRadius: 8,
                                          controller: _addressController,
                                          contentPadding: const EdgeInsets.only(
                                              left: 21, right: 11),
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Image.asset(
                                                "assets/icons/address-filled-blue.png",
                                                height: 21,
                                                width: 16),
                                          ),
                                          suffixIcon: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: buildClickableIcon(
                                              Image.asset(
                                                "assets/icons/edit-filled-blue.png",
                                                height: 16,
                                                width: 16,
                                              ),
                                              () {
                                                print("Edit icon clicked");
                                              },
                                            ),
                                          ),
                                          height: 35,
                                          inputTextStyle: _inputTextStyle,
                                          textAlign: TextAlign.center,
                                          defaultBorder: _defaultBorder,
                                          errorBorder: _defaultBorder),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 38),
                                child: Text(
                                  "Others",
                                  style: getTextStyle(
                                      textColor: AppColors.black,
                                      fontFamily: AppFonts.montserrat,
                                      fontWeight: AppFontWeights.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, left: 18),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      child: Stack(
                                        children: [
                                          Row(
                                            children: [
                                              AppOutlinedButton(
                                                text: "Change Password",
                                                textStyle: getTextStyle(
                                                    textColor: AppColors.black,
                                                    fontFamily:
                                                        AppFonts.montserrat,
                                                    fontWeight:
                                                        AppFontWeights.semiBold,
                                                    fontSize: 12),
                                                color: AppColors.secondaryBlue,
                                                command: onChangePassword,
                                                borderRadius: 8,
                                                borderWidth: 1,
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Image.asset(
                                                  "assets/icons/lock-filled-blue.png",
                                                  width: 18),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, left: 18),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      child: Stack(
                                        children: [
                                          Row(
                                            children: [
                                              AppOutlinedButton(
                                                text: "Report an Issue",
                                                textStyle: getTextStyle(
                                                    textColor: AppColors.black,
                                                    fontFamily:
                                                        AppFonts.montserrat,
                                                    fontWeight:
                                                        AppFontWeights.semiBold,
                                                    fontSize: 12),
                                                color: AppColors.secondaryBlue,
                                                command: onReportAnIssue,
                                                borderRadius: 8,
                                                borderWidth: 1,
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Image.asset(
                                                  "assets/icons/flag-filled-blue.png",
                                                  width: 18),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 31, bottom: 16),
                          child: Center(
                            child: LogoutButton(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onViewReviewsAndRatings() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ViewHandymanProfile(handymanInfo: getUserInfo),
    ));
  }

  void onChangePassword() {}

  void onReportAnIssue() => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReportIssuePage(userId: widget.userId),
      ));
}
