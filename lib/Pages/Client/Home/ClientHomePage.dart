import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:laborlink/Pages/Client/Home/SuccessPage.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/Widgets/Buttons/HistoryButton.dart';
import 'package:laborlink/Widgets/Cards/HandymanDirectRequestCard.dart';
import 'package:laborlink/Widgets/Cards/OngoingRequestCard.dart';
import 'package:laborlink/Widgets/Dialogs.dart';
import 'package:laborlink/Widgets/Forms/RequestForm.dart';
import 'package:laborlink/Widgets/LaborMenu.dart';
import 'package:laborlink/Widgets/NavBars/TabNavBar.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';

import '../../../Widgets/Cards/NoOngoingRequestCard.dart';

class ClientHomePage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  const ClientHomePage({Key? key, required this.navigateToNewPage})
      : super(key: key);

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  final _searchController = TextEditingController();
  late GlobalKey<RequestFormState> requestFormKey;

  int _selectedTabIndex = 0;

  bool _showSearchResult = false;

  bool _hideHeader = false;

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
    setState(() {
      _selectedTabIndex = selectedTabIndex;
    });
  }

  void updateDirectRequestTabContent(String? searchText) {
    if (searchText == null) return;

    setState(() {
      _showSearchResult = searchText.trim().isNotEmpty;
    });
  }

  void onHistoryButtonClick() {}

  void submitRequest(requestType) {
    // requestType can be direct and open
    print(requestType);

    // TODO Add submit request processing

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
          widget.navigateToNewPage(1);
        }
      },
    );
  }

  void onOpenRequestProceed() {
    confirmationDialog(context).then((value) {
      if (value == null) return;

      if (value == "proceed") {
        suggestedFeeDialog(context).then((value) {
          if (value == null) return;

          if (value == "submit") {
            submitRequest("open");
          }
        });
      }
    });
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
                        child: Text("Hello, User!",
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
            hintText: "Search handyman name",
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
                    ? searchResultSection()
                    : Padding(
                        padding: const EdgeInsets.only(left: 26, right: 23),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(children: [
                            const LaborMenu(
                                padding: EdgeInsets.only(bottom: 28)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getOngoingRequest(),
                                HistoryButton(command: onHistoryButtonClick),
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

  Widget searchResultSection() => Padding(
        padding: const EdgeInsets.only(left: 9, right: 9),
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            setState(() {
              _hideHeader = notification.metrics.pixels >= 10;
            });

            return true;
          },
          child: ListView.builder(
            itemCount: dummyFilteredHandyman.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> currentHandyman =
                  dummyFilteredHandyman[index];

              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 9 : 0),
                child: HandymanDirectRequestCard(
                    handymanInfo: currentHandyman,
                    submitRequest: submitRequest),
              );
            },
          ),
        ),
      );

  Widget openRequestTab() {
    requestFormKey = GlobalKey<RequestFormState>();

    return Padding(
      padding: const EdgeInsets.only(top: 54),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 23, right: 23, top: 9, bottom: 18),
          child: Column(
            children: [
              RequestForm(
                key: requestFormKey,
              ),
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
    // TODO: Add logic for ongoing Request
    return const NoOngoingRequestCard();

    return const OngoingRequestCard(
        title: "Request Title",
        address: "1354-D Lacuna St. Bangkal, Makati City",
        imgUrl:
            "https://monstar-lab.com/global/assets/uploads/2019/04/male-placeholder-image.jpeg.webp");
  }
}
