import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Cards/HandymanInfoCard.dart';
import 'package:laborlink/Widgets/Cards/ReviewCard.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/Widgets/Forms/RequestForm.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/request.dart';
import 'package:laborlink/models/handyman_approval.dart';
import 'package:laborlink/models/database_service.dart';

class DirectRequestFormPage extends StatefulWidget {
  final Map<String, dynamic> handymanInfo;
  final String userId;
  const DirectRequestFormPage(
      {Key? key, required this.handymanInfo, required this.userId})
      : super(key: key);

  @override
  State<DirectRequestFormPage> createState() => _DirectRequestFormPageState();
}

class _DirectRequestFormPageState extends State<DirectRequestFormPage> {
  GlobalKey<RequestFormState> requestFormKey = GlobalKey<RequestFormState>();

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
                  color: AppColors.white,
                  child: Stack(
                    children: [
                      formSection(),
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

  void onProceed() {
    if (requestFormKey.currentState!.validateForm()) {
      // Retrieve form data
      Map<String, dynamic> formData = requestFormKey.currentState!.getFormData;

      // Validate each field separately if needed
      String? titleError =
          requestFormKey.currentState!.validateTitle(formData['title']);
      String? descriptionError = requestFormKey.currentState!
          .validateDescription(formData['description']);
      String? addressError =
          requestFormKey.currentState!.validateAddress(formData['address']);

      if (titleError != null ||
          descriptionError != null ||
          addressError != null) {
        // Handle validation errors
        // Show error messages or perform actions accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill out all the required fields."),
            backgroundColor: Color.fromARGB(255, 245, 27, 11),
          ),
        );
      } else {
        confirmationDialog(context).then((value) {
          if (value == null) return;

          if (value == "proceed") {
            suggestedFeeDialog(context).then((value) async {
              if (value == null) return;
                DatabaseService service = DatabaseService();
                try {
                  // Create a user in Firebase Authentication
                  String imageUrl = await service.uploadRequestAttachment(
                      widget.userId, formData['attachment']);

                  Request request = Request(
                    title: formData["title"],
                    category: formData["category"],
                    description: formData["description"],
                    attachment: imageUrl,
                    address: formData["address"],
                    date: formData["date"],
                    time: formData["time"],
                    progress: "pending",
                    instructions: formData["instructions"],
                    suggestedPrice: 2.0,
                    userId: widget.userId,
                    handymanId:  widget.handymanInfo["userId"],
                  );

                  HandymanApproval handymanApproval = HandymanApproval(
                    status: 'direct',
                    handymanId: widget.handymanInfo["userId"],
                    requestId: widget.userId,
                  );

                  await service.addHandymanApproval(handymanApproval);
                  await service.addRequest(request);

                  Navigator.of(context).pop("submit");
                } catch (e) {
                  // Handle errors during user creation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error creating user: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              
            });
          }
        });
      }
    }
  }

  Widget appBar() => Padding(
        padding: const EdgeInsets.only(left: 26, bottom: 14, top: 34),
        child: GestureDetector(
          onTap: onBack,
          child:
              Image.asset("assets/icons/back-btn.png", height: 13, width: 17.5),
        ),
      );

  Widget formSection() => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 94, left: 24, right: 24, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RequestForm(
                  key: requestFormKey,
                  userId: widget.userId,
                  handymanInfo: widget.handymanInfo),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                  children: [
                    AppFilledButton(
                        text: "Proceed",
                        height: 37,
                        fontSize: 15,
                        fontFamily: AppFonts.montserrat,
                        color: AppColors.secondaryBlue,
                        command: onProceed,
                        borderRadius: 8),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
