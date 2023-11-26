import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Registration/AccountCreatedPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/OutlinedButton.dart';
import 'package:laborlink/Widgets/Checkbox.dart';
import 'package:laborlink/styles.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  final dummyText =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo";

  bool agreeWithTermsAndCondition = false;
  bool agreeWithPrivacyPolicy = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: deviceWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icons/LOGO 1.png",
                  height: 48,
                  width: 157,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Text(
                    "TERMS & CONDITIONS",
                    overflow: TextOverflow.visible,
                    style: getTextStyle(
                        textColor: AppColors.tertiaryBlue,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: FontWeight.bold,
                        fontSize: 36),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: SizedBox(
                    height: 350,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Text(
                            "1. Acceptance of Terms\n\n"
                            "Welcome to Laborlink! By accessing or using the Laborlink mobile application, "
                            "you agree to be bound by these Terms and Conditions, our Privacy Policy, and all "
                            "applicable laws and regulations. If you do not agree to these terms, please refrain "
                            "from using our application.\n\n"
                            "2. Services\n\n"
                            "Laborlink provides a platform connecting clients and laborers for various services "
                            "including but not limited to plumbing, painting, maintenance, etc. Laborers can accept "
                            "or decline offers from clients based on their availability and expertise.\n\n"
                            "3. User Registration\n\n"
                            "a. Clients and Laborers: To access the full features of the application, users must "
                            "register an account. By registering, users agree to provide accurate and complete "
                            "information, including personal details and valid identification.\n\n"
                            "b. Handymen: In addition to personal information, handymen must provide a valid National "
                            "Bureau of Investigation (NBI) clearance and Technical Education and Skills Development "
                            "Authority (TESDA) certificate upon registration. Laborlink reserves the right to verify the "
                            "authenticity of NBI clearances through fake detection processes.\n\n"
                            "4. User Responsibilities\n\n"
                            "a. Clients: Clients agree to accurately describe their service needs and provide a safe "
                            "working environment for the laborers.\n\n"
                            "b. Handymen: Handymen agree to accept offers based on their expertise and availability. "
                            "They must maintain professional conduct while using the Laborlink platform.\n\n"
                            "5. Privacy\n\n"
                            "Laborlink respects user privacy and handles personal information in accordance with its "
                            "Privacy Policy. By using the application, users consent to the collection, storage, and "
                            "use of their personal data as outlined in the Privacy Policy.\n\n"
                            "6. Intellectual Property\n\n"
                            "All content, trademarks, logos, and intellectual property displayed on Laborlink remain "
                            "the property of Laborlink. Users may not reproduce, distribute, or use this content "
                            "without prior written permission.\n\n"
                            "7. Limitation of Liability\n\n"
                            "Laborlink is not liable for any damages, losses, or disputes arising from interactions "
                            "between clients and laborers. Users acknowledge and accept the inherent risks of using "
                            "the platform.\n\n"
                            "8. Termination\n\n"
                            "Laborlink reserves the right to terminate or suspend user accounts if there is a breach "
                            "of these Terms and Conditions or any illegal activities associated with the use of the "
                            "application.\n\n"
                            "9. Changes to Terms\n\n"
                            "Laborlink reserves the right to modify or update these Terms and Conditions at any time. "
                            "Continued use of the application constitutes acceptance of any changes made.\n\n"
                            "10. Contact Information\n\n"
                            "For questions or concerns regarding these Terms and Conditions, please contact us at [Contact Email/Address].",
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.justify,
                            style: getTextStyle(
                              textColor: AppColors.tertiaryBlue,
                              fontFamily: AppFonts.montserrat,
                              fontWeight: AppFontWeights.medium,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: AppCheckBox(
                    label: "I AGREE WITH THE TERMS AND CONDITIONS",
                    labelStyle: getTextStyle(
                        textColor: AppColors.tertiaryBlue,
                        fontFamily: AppFonts.poppins,
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: 11),
                    checkboxColor: AppColors.grey,
                    borderRadius: 3,
                    borderWidth: 2,
                    onChanged: (value) {
                      setState(() {
                        agreeWithTermsAndCondition = value;
                      });
                    },
                  ),
                ),
                AppCheckBox(
                    label: "I AGREE WITH THE PRIVACY POLICY",
                    labelStyle: getTextStyle(
                        textColor: AppColors.tertiaryBlue,
                        fontFamily: AppFonts.poppins,
                        fontWeight: AppFontWeights.semiBold,
                        fontSize: 11),
                    checkboxColor: AppColors.grey,
                    borderRadius: 3,
                    borderWidth: 2,
                    onChanged: (value) {
                      setState(() {
                        agreeWithPrivacyPolicy = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      AppOutlinedButton(
                          padding: const EdgeInsets.only(right: 10),
                          text: "CANCEL",
                          color: AppColors.tertiaryBlue,
                          command: onCancel,
                          borderRadius: 8),
                      AppFilledButton(
                          padding: const EdgeInsets.only(left: 10),
                          enabled: agreeWithTermsAndCondition &&
                              agreeWithPrivacyPolicy,
                          fontFamily: AppFonts.poppins,
                          fontSize: 15,
                          height: 42,
                          text: "CONTINUE",
                          color: AppColors.tertiaryBlue,
                          command: onRegister,
                          borderRadius: 8)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCancel() {}

  void onRegister() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const AccountCreatedPage(),
      ),
    );
  }
}
