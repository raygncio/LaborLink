import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:laborlink/Pages/Client/Home/SuccessPage.dart';
import 'package:laborlink/Pages/Handyman/Activity/HandymanActivityPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/HistoryButton.dart';
import 'package:laborlink/Widgets/Cards/DirectRequestCard.dart';
import 'package:laborlink/Widgets/Cards/HandymanDirectRequestCard.dart';
import 'package:laborlink/Widgets/Cards/NoOngoingServiceCard.dart';
import 'package:laborlink/Widgets/Cards/OngoingRequestCard.dart';
import 'package:laborlink/Widgets/Cards/OpenRequestCard.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/Widgets/Forms/RequestForm.dart';
import 'package:laborlink/Widgets/LaborMenu.dart';
import 'package:laborlink/Widgets/NavBars/TabNavBar.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/models/handyman.dart';
import 'package:laborlink/styles.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/request.dart';
import '../../../Widgets/Cards/NoOngoingRequestCard.dart';

class HandymanHomePage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  final String userId;
  const HandymanHomePage(
      {Key? key, required this.navigateToNewPage, required this.userId})
      : super(key: key);

  @override
  State<HandymanHomePage> createState() => _HandymanHomePageState();
}

class _HandymanHomePageState extends State<HandymanHomePage> {
  final _searchController = TextEditingController();
  DatabaseService service = DatabaseService();
  late GlobalKey<RequestFormState> requestFormKey;
  late String specialization;
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> offers = [];
  List<Map<String, dynamic>> interested = [];
  Handyman? handyman;

  int _selectedTabIndex = 0;

  bool _showSearchResult = false;

  @override
  void initState() {
    // TODO: implement initState
    displayRequest();
    super.initState();
  }

  void displayRequest() async {
    try {
      handyman = await service.getHandymanData(widget.userId);

      if (handyman!.specialization.isNotEmpty) {
        specialization = handyman!.specialization;
        updateFindLaborTabContent(specialization);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

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
                        leftLabel: "Find Labor",
                        rightLabel: "Direct Request",
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
    setState(() {
      _selectedTabIndex = selectedTabIndex;
    });
  }

  _loadData() async {
    try {
      List<Map<String, dynamic>> results = await service
          .getUserAndRequestBaseOnSearch(_searchController.text.toLowerCase());

      // Check if the widget is still mounted before updating the state
      if (mounted) {
        setState(() {
          _showSearchResult = results.isNotEmpty;
          _searchResults = results;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void updateFindLaborTabContent(String? searchText) async {
    if (searchText == null) return;

    try {
      List<Map<String, dynamic>> results =
          await service.getUserAndRequestBaseOnSearch(searchText.toLowerCase());

      // Check if the widget is still mounted before updating the state
      if (mounted) {
        setState(() {
          _showSearchResult = results.isNotEmpty;
          _searchResults = results;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void onHistoryButtonClick() {
    widget.navigateToNewPage(0);
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
                        padding: const EdgeInsets.only(top: 38),
                        child: Text("Hello, User!",
                            style: getTextStyle(
                                textColor: AppColors.secondaryYellow,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: AppFontWeights.bold,
                                fontSize: 30)),
                      ),
                      Text(
                        _selectedTabIndex == 0
                            ? "Find a customer in need of\nservice!"
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
    return _selectedTabIndex == 0 ? findLaborTab() : directRequestTab();
  }

  Widget searchSection() => Container(
        decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 12,
                  color: AppColors.blackShadow)
            ]),
        child: searchBox(),
      );

  Widget searchBox() => Padding(
        padding: const EdgeInsets.only(left: 10, right: 9, top: 15, bottom: 16),
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
            hintText: "Search for labor",
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
            onChanged: updateFindLaborTabContent,
          ),
        ),
      );

  Widget findLaborTab() => Padding(
        padding: const EdgeInsets.only(top: 54),
        child: Stack(
          children: [
            openRequestsSection(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 505),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 23),
                    child: Column(children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Use FutureBuilder here
                          getOngoingService(),

                          // HistoryButton(
                          //   command: onHistoryButtonClick,
                          //   backgroundColor: AppColors.white,
                          // ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
            searchSection(),
          ],
        ),
      );

  // Widget openRequestsSection() => FutureBuilder(
  //       future: service.getAllUserAndItsRequest(widget.userId),
  //       builder: (context, AsyncSnapshot<List<UserAndRequest>> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return CircularProgressIndicator();
  //         } else if (snapshot.hasError) {
  //           return Text("Error: ${snapshot.error}");
  //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //           return Text("No open requests found.");
  //         } else {
  //           return Padding(
  //             padding: const EdgeInsets.only(left: 9, right: 9, top: 77),
  //             child: ListView.builder(
  //               itemCount: snapshot.data!.length,
  //               itemBuilder: (context, index) {
  //                 // Access client and request using snapshot.data![index].client and snapshot.data![index].request
  //                 return Padding(
  //                   padding: EdgeInsets.only(
  //                       top: index == 0 ? 15 : 9,
  //                       bottom: index == snapshot.data!.length - 1 ? 75 : 0),
  //                   child: OpenRequestCard(
  //                     client: snapshot.data![index].client,
  //                     request: snapshot.data![index].request,
  //                   ),
  //                 );
  //               },
  //             ),
  //           );
  //         }
  //       },
  //     );

  Widget openRequestsSection() => Padding(
        padding: const EdgeInsets.only(left: 9, right: 9, top: 77),
        child: ListView.builder(
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> currentClientRequest = _searchResults[index];
            return Padding(
              padding: EdgeInsets.only(
                  top: index == 0 ? 15 : 9, bottom: index == 9 ? 75 : 0),
              child: OpenRequestCard(
                  clientRequestInfo: currentClientRequest,
                  userId: widget.userId),
            );
          },
        ),
      );

  Widget directRequestTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: service.getDirectRequestOfHandyman(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          List<Map<String, dynamic>> results = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.only(top: 54),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 26, top: 21),
                    child: Text("Request addressed to you",
                        style: getTextStyle(
                          textColor: AppColors.secondaryBlue,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: AppFontWeights.regular,
                          fontSize: 10,
                        )),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 9),
                        child: DirectRequestCard(
                          userId: widget.userId,
                          requestInfo: results[index],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget getOngoingService() {
    return FutureBuilder<Widget>(
      future: getOngoingServiceContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data ?? const NoOngoingRequestCard();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<Widget> getOngoingServiceContent() async {
    DatabaseService service = DatabaseService();
    Request? requestInfo = await service.getHandymanService(widget.userId);
    print(">>>>>>>>>>>>$requestInfo");
    print('$requestInfo.title');
    if (requestInfo != null) {
      return OngoingRequestCard(
        title: requestInfo.title,
        address: requestInfo.address,
        // imgUrl: "https://monstar-lab.com/global/assets/uploads/2019/04/male-placeholder-image.jpeg.webp", //replace with the profile pic image
      );
    } else {
      return NoOngoingRequestCard();
    }
  }
}
