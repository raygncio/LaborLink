import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborlink/Pages/Client/ClientMainPage.dart';
import 'package:laborlink/Pages/Handyman/HandymanMainPage.dart';
import 'package:laborlink/otp/controllers/auth_service.dart';
import 'package:laborlink/ai/style.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:lottie/lottie.dart';

class VerifyPhonePage extends ConsumerStatefulWidget {
  const VerifyPhonePage({super.key});

  @override
  ConsumerState<VerifyPhonePage> createState() {
    return _VerifyPhonePageState();
  }
}

class _VerifyPhonePageState extends ConsumerState<VerifyPhonePage> {
  DatabaseService service = DatabaseService();
  Timer? timer;

  final TextEditingController _otpController = TextEditingController();
  final _otpFormKey = GlobalKey<FormState>();

  Future<String>? userRole;
  Future<String>? phoneNumber;
  String? userId;
  String? linkedPhoneNumber;
  bool canResendOtp = true;
  // bool successfulOtp = false;

  @override
  void dispose() {
    timer?.cancel(); // dispose timer when not used
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // get userId
    userId = FirebaseAuth.instance.currentUser!.uid;

    // get userRole
    userRole = getUserRole();

    // get registered phone number
    phoneNumber = getPhoneNumber();

    // get linked phone number
    linkedPhoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;

    if (linkedPhoneNumber == null) {
      //check phone linking status every 3 sec
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (timer) => checkLinkedPhone(),
      );
    }
  }

  refreshButton() async {
    setState(() {
      canResendOtp = false;
    });

    await Future.delayed(const Duration(seconds: 10));

    setState(() {
      canResendOtp = true;
    });
  }

  Future checkLinkedPhone() async {
    await FirebaseAuth.instance.currentUser!.reload();
    // update UI upon checking
    setState(() {
      linkedPhoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
    });

    // cancels periodic checking when linked phone number
    // is finally not null upon reloading
    if (linkedPhoneNumber != null) timer?.cancel();
  }

  showErrorMessages(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.red,
      ),
    );
  }

  Future<String> getUserRole() async {
    Client clientInfo =
        await service.getUserData(FirebaseAuth.instance.currentUser!.uid);

    return clientInfo.userRole;
  }

  Future<String> getPhoneNumber() async {
    Client clientInfo =
        await service.getUserData(FirebaseAuth.instance.currentUser!.uid);
    return clientInfo.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    print('>>>>>>>>>>>>userRole: $userRole');
    print('>>>>>>>>>>>>>phoneNumber: $phoneNumber');

    if (linkedPhoneNumber != null) {
      return FutureBuilder(
        future: userRole,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'client') {
              return ClientMainPage(userId: userId!);
            } else if (snapshot.data == 'handyman') {
              return HandymanMainPage(userId: userId!);
            }
          }

          // loading
          return const Scaffold(
            backgroundColor: AppColors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: FutureBuilder(
            future: phoneNumber,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String phoneNumber = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animations/success.json'),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Verify your phone number',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                  textColor: AppColors.secondaryBlue,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: AppFontWeights.bold,
                                  fontSize: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      readOnly: true,
                      initialValue:
                          '+63 $phoneNumber', // registered phone number
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // send otp button
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: !canResendOtp
                            ? null
                            : () {
                                print('>>>>>>>>>>>>$phoneNumber');
                                refreshButton();
                                AuthService.sendOtp(
                                  phoneNumber:
                                      phoneNumber, // registered phone number

                                  // exception handling for sendOtp function
                                  errorStep: () => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Error in sending OTP',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: AppColors.red,
                                    ),
                                  ),

                                  // if code sent successfully
                                  nextStep: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          'OTP Verification',
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(
                                              textColor:
                                                  AppColors.secondaryBlue,
                                              fontFamily: AppFonts.poppins,
                                              fontWeight: AppFontWeights.bold,
                                              fontSize: 24),
                                        ),
                                        content: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('Enter 6 digit OTP'),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Form(
                                              key: _otpFormKey,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: _otpController,
                                                decoration: InputDecoration(
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .primaryBlue)),
                                                  labelText: 'Enter OTP',
                                                  floatingLabelStyle:
                                                      const TextStyle(
                                                          color: AppColors
                                                              .primaryBlue),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.length != 6) {
                                                    return "Invalid OTP";
                                                  }

                                                  return null;
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              if (_otpFormKey.currentState!
                                                  .validate()) {
                                                AuthService.proceed(
                                                        otp:
                                                            _otpController.text)
                                                    .then(
                                                  (value) {
                                                    if (value == 'Success') {
                                                      Navigator.pop(context);

                                                      // run build again
                                                      setState(() {});
                                                    } else {
                                                      print(
                                                          '>>>>>>>>>>>> OTP ERROR');
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            value,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          backgroundColor:
                                                              AppColors.red,
                                                        ),
                                                      );
                                                      setState(() {});
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              'Submit',
                                              style: getTextStyle(
                                                  textColor:
                                                      AppColors.secondaryBlue,
                                                  fontFamily: AppFonts.poppins,
                                                  fontWeight:
                                                      AppFontWeights.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue),
                        child: Text(
                          'Send OTP',
                          style: getTextStyle(
                              textColor: AppColors.white,
                              fontFamily: AppFonts.poppins,
                              fontWeight: AppFontWeights.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                );
              }
              // loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
