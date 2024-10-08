import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laborlink/Pages/Client/Home/SuccessPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Cards/HandymanDirectRequestCard.dart';
import 'package:laborlink/Widgets/Cards/OngoingRequestCard.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/Widgets/Forms/RequestForm.dart';
import 'package:laborlink/Widgets/LaborMenu.dart';
import 'package:laborlink/Widgets/NavBars/TabNavBar.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/models/client.dart';
import 'package:laborlink/styles.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/request.dart';
import '../../../Widgets/Cards/NoOngoingRequestCard.dart';

// final _firebase = FirebaseAuth.instance;
// final _firestore = FirebaseFirestore.instance;
final DatabaseService service = DatabaseService();

class ClientHomePage extends StatefulWidget {
  final Function(int)? navigateToNewPage;
  final String userId;
  const ClientHomePage({Key? key, this.navigateToNewPage, required this.userId})
      : super(key: key);

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  final _searchController = TextEditingController();
  GlobalKey<RequestFormState> requestFormKey = GlobalKey<RequestFormState>();

  int _selectedTabIndex = 0;
  bool _showSearchResult = false;
  bool _hideHeader = false;
  List<Map<String, dynamic>> _searchResults = [];
  double _totalFee = 0.0;

  String currentUserFirstName = '';
  Client? clientInfo;
  bool _hasPendingOrOngoingRequest = false;

  getUserData() async {
    Client userData =
        await service.getUserData(FirebaseAuth.instance.currentUser!.uid);
    clientInfo = userData;
    currentUserFirstName = clientInfo!.firstName;
    setState(() {});
  }

  // Function to check if there is any pending or ongoing request
  Future<void> checkPendingOrOngoingRequest() async {
    Request? requestInfo = await service.getRequestsData(widget.userId);
    setState(() {
      _hasPendingOrOngoingRequest = requestInfo != null;
    });
  }

  @override
  void initState() {
    getUserData();
    checkPendingOrOngoingRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    // check user first name
    if (currentUserFirstName.isNotEmpty) {
      currentUserFirstName =
          '${currentUserFirstName[0].toUpperCase()}${currentUserFirstName.substring(1).toLowerCase()}';
    }

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
        child: Container(
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(deviceWidth),
              Expanded(
                child: Stack(
                  children: [
                    displayTabContent(),
                    AppTabNavBar(
                        selectedTabIndex: _selectedTabIndex,
                        leftLabel: "Direct Request",
                        rightLabel: "Open Request",
                        onChanged: updateSelectedTab),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateSelectedTab(int selectedTabIndex) {
     if (selectedTabIndex == 1 && _hasPendingOrOngoingRequest) {
      // Optionally, provide feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You cannot create a new request while you have a pending or ongoing request."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() {
        _selectedTabIndex = selectedTabIndex;
      });
    }
  }

  void updateDirectRequestTabContent(String? searchText) async {
    // retrieved the handyman whose name will match on the entered text
    bool fromButton = false;

    if (searchText == null) return;

    if (searchText.length > 4 && searchText.substring(0, 4) == 'btn-') {
      fromButton = true;
      searchText = searchText.substring(4);
    }

    // print('>>>>>>>>>>>>>>>>>$searchText');

    try {
      List<Map<String, dynamic>> results =
          await service.getUserAndHandymanDataByFirstName(searchText);

      // print('>>>>>>>>>>>>>$results');

      // prints if and only if search text is from button
      if (fromButton && results.isEmpty) {
        Fluttertoast.showToast(
            msg: "No Handyman Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      setState(() {
        _showSearchResult = results.isNotEmpty;
        _searchResults = results;
      });
    } catch (error) {
      // print('Error fetching user data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Error fetching user data'),
            backgroundColor: Color.fromARGB(255, 245, 27, 11),
          ),
        );
    }
  }

  // void onHistoryButtonClick() =>
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => ClientViewHistory(userId: widget.userId),
  //     ));

  Future<void> submitRequest(requestType) async {
    setState(() {
      if (requestFormKey.currentState != null) {
        requestFormKey.currentState!.isAutoValidationEnabled = true;
      }
    });

    // DatabaseService service = DatabaseService();

    if (requestFormKey.currentState!.validateForm()) {
      // print('>>>> IN open request proceed');

      // Get form data from RequestForm
      Map<String, dynamic> formData = requestFormKey.currentState!.getFormData;

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
          suggestedPrice: _totalFee,
          userId: widget.userId,
        );

        await service.addRequest(request);
        // Continue with your navigation or any other logic
        // requestType can be direct and open

        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => const ClientRequestSuccessPage(),
        ))
            .then(
          (value) {
            if (value == null) return;

            if (value == "home") {
              updateSelectedTab(0);
            } else if (value == "activity") {
              widget.navigateToNewPage!(1);
            }
          },
        );
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

  _getTotalFee(double fee) {
    setState(() {
      _totalFee = fee;
      // print('>>>>>>>>>>>$_totalFee');
    });
  }

  void onOpenRequestProceed() async {
    // Check if the user has an ongoing request
    Request? requestInfo = await service.getRequestsData(widget.userId);

    if (requestInfo != null) {
      // Handle errors during user creation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid. You can only create one request at a time."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      confirmationDialog(context).then((value) {
        if (value == null) return;

        if (value == "proceed") {
          suggestedFeeDialog(context, _getTotalFee).then((value) {
            submitRequest('open');
          });
        }
      });
    }
  }

  Widget header(deviceWidth) => KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Visibility(
              visible: !isKeyboardVisible,
              child: Container(
                width: deviceWidth,
                height: 164,
                color: AppColors.secondaryBlue,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 44),
                        child: Text("Hello, $currentUserFirstName!",
                            style: getTextStyle(
                                textColor: AppColors.secondaryYellow,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.bold,
                                fontSize: 30)),
                      ),
                      Text(
                        _selectedTabIndex == 0
                            ? "Find the handyman you need!"
                            : "Let handymen know your\nrequest!",
                        style: getTextStyle(
                            textColor: AppColors.white,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.regular,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ));
        },
      );

  Widget displayTabContent() {
    return _selectedTabIndex == 0 ? directRequestTab() : openRequestTab();
  }

  Widget searchSection() => Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: _showSearchResult
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))
                : null,
            boxShadow: _showSearchResult
                ? const [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 12,
                        color: AppColors.blackShadow)
                  ]
                : null),
        child: searchBox(),
      );

  Widget searchBox() => Padding(
        padding:
            const EdgeInsets.only(top: 21, left: 26, right: 23, bottom: 27),
        child: SizedBox(
          height: 46,
          child: AppNormalTextFormField(
            controller: _searchController,
            inputTextStyle: getTextStyle(
                textColor: AppColors.black,
                fontFamily: AppFonts.montserrat,
                fontWeight: AppFontWeights.regular,
                fontSize: 15),
            defaultBorder: Border.all(
              color: AppColors.grey,
            ),
            borderRadius: 8,
            height: 46,
            errorBorder: null,
            hintText: "Search by category or by handyman's first name",
            hintTextStyle: getTextStyle(
                textColor: AppColors.grey,
                fontFamily: AppFonts.montserrat,
                fontWeight: AppFontWeights.regular,
                fontSize: 15),
            contentPadding: const EdgeInsets.all(13),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(right: 17),
              child: Icon(
                Icons.search,
                color: AppColors.grey,
                size: 20,
              ),
            ),
            onChanged: updateDirectRequestTabContent,
          ),
        ),
      );

  Widget directRequestTab() => Padding(
        padding: const EdgeInsets.only(top: 54),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 95),
              child: Container(
                color:
                    _showSearchResult ? AppColors.dirtyWhite : AppColors.white,
                child: _showSearchResult
                    ? searchResultSection(_searchResults)
                    : Padding(
                        padding: const EdgeInsets.only(left: 26, right: 23),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(children: [
                            LaborMenu(
                              padding: const EdgeInsets.only(bottom: 28),
                              onLaborSelected: onLaborSelectedCallback,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getOngoingRequest(),
                                // HistoryButton(command: onHistoryButtonClick),
                              ],
                            )
                          ]),
                        ),
                      ),
              ),
            ),
            searchSection(),
          ],
        ),
      );

  Widget searchResultSection(List<Map<String, dynamic>> searchResults) =>
      Padding(
        padding: const EdgeInsets.only(left: 9, right: 9),
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            setState(() {
              _hideHeader = notification.metrics.pixels >= 10;
            });

            return true;
          },
          child: ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> currentHandyman = searchResults[index];

              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 9 : 0),
                child: HandymanDirectRequestCard(
                    handymanInfo: currentHandyman,
                    submitRequest: submitRequest,
                    userId: widget.userId),
              );
            },
          ),
        ),
      );

  Widget openRequestTab() {
    return Padding(
      padding: const EdgeInsets.only(top: 54),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 23, right: 23, top: 9, bottom: 18),
          child: Column(
            children: [
              RequestForm(key: requestFormKey, userId: widget.userId),
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
                        command: onOpenRequestProceed,
                        borderRadius: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getOngoingRequest() {
    return FutureBuilder<Widget>(
      future: getOngoingRequestContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data ?? const NoOngoingRequestCard();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  void onLaborSelectedCallback(String selectedLaborName) {
    String text = '';
    // Handle the selected labor category name as needed
    if (selectedLaborName == 'Installation') {
      text = '${selectedLaborName}s';
    } else {
      text = selectedLaborName;
    }
    // print('Labor selected in main code: $text');

    updateDirectRequestTabContent('btn-${text.toLowerCase()}');
  }

  Future<Widget> getOngoingRequestContent() async {
    Request? requestInfo = await service.getRequestsData(widget.userId);

    if (requestInfo != null) {
      return OngoingRequestCard(
        title: requestInfo.title,
        address: requestInfo.address,
        // imgUrl: "https://monstar-lab.com/global/assets/uploads/2019/04/male-placeholder-image.jpeg.webp", //replace with the profile pic image
      );
    } else {
      return const NoOngoingRequestCard();
    }
  }
}
