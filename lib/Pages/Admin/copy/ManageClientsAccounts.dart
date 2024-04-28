import 'package:flutter/material.dart';
import 'package:laborlink/Widgets/Cards/ClientAccountStatusCard.dart';
import 'package:laborlink/Widgets/TextFormFields/NormalTextFormField.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';

class ManageClientsAccounts extends StatefulWidget {
  const ManageClientsAccounts({Key? key}) : super(key: key);

  @override
  State<ManageClientsAccounts> createState() => _ManageClientsAccountsState();
}

class _ManageClientsAccountsState extends State<ManageClientsAccounts> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final deviceWidth = MediaQuery.of(context).size.width;
    // final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
          child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            appBar(),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 52),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: 10,
                              right: 9,
                              top: 19,
                              bottom: index == 9 ? 19 : 0),
                          child: ClientAccountStatusCard(
                              clientInfo: dummyClients[index],
                              accountStatus: index % 2 == 0
                                  ? ClientAccountStatus.active
                                  : ClientAccountStatus.blocked),
                        );
                      },
                    ),
                  ),
                  searchBox(),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  void onBack() => Navigator.of(context).pop();

  Widget appBar() => Container(
        height: 151,
        color: AppColors.secondaryBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 11, right: 11),
                    child: GestureDetector(
                      onTap: onBack,
                      child: Image.asset(
                        "assets/icons/back-btn-2.png",
                        width: 10,
                        height: 18,
                      ),
                    ),
                  ),
                  Text(
                    "Manage Accounts",
                    style: getTextStyle(
                        textColor: AppColors.secondaryYellow,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.bold,
                        fontSize: 20),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 33),
              child: Text(
                "Clients",
                style: getTextStyle(
                    textColor: AppColors.secondaryYellow,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 40),
              ),
            )
          ],
        ),
      );

  Widget searchBox() => Container(
        color: AppColors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 14, left: 10, right: 9, bottom: 14),
          child: SizedBox(
            height: 42,
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
              height: 42,
              errorBorder: null,
              hintText: "Search for handyman",
              hintTextStyle: getTextStyle(
                  textColor: AppColors.grey,
                  fontFamily: AppFonts.montserrat,
                  fontWeight: AppFontWeights.regular,
                  fontSize: 15),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 11.87, horizontal: 14.25),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(right: 13.82),
                child: Icon(
                  Icons.search,
                  color: AppColors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      );
}
