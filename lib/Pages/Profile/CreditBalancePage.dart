import 'package:flutter/material.dart';
import 'package:laborlink/Pages/Profile/credits_widgets/CreditsList.dart';
import 'package:laborlink/Widgets/Buttons/FilledButton.dart';
import 'package:laborlink/models/database_service.dart';
import 'package:laborlink/models/handyman.dart';
import 'package:laborlink/models/transaction.dart';
import 'package:laborlink/styles.dart';

class CreditBalancePage extends StatefulWidget {
  CreditBalancePage({super.key, required this.userId});

  @override
  State<CreditBalancePage> createState() => _CreditBalancePageState();

  String userId;
}

class _CreditBalancePageState extends State<CreditBalancePage> {
  DatabaseService service = DatabaseService();
  List<Transaction> transactionHistory = [];

  // -1 means loading
  double balance = -1;

  _loadData() async {
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOADING DATA');
    balance = await service.computeCreditBalance(widget.userId);
    transactionHistory =
        await service.getAllTransactionsOfHandyman(widget.userId);
    setState(() {});
  }

  // not yet used
  _makePayment() async {
    String description = 'payment-$balance';
    Handyman handyman = await service.getHandymanData(widget.userId);
    Transaction transactionData = Transaction(
        amount: '+$balance',
        description: description,
        handymanId: handyman.handymanId!);
    await service.addTransaction(transactionData);
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String header = 'Pay Credit Balance';

    Widget mainContent = Center(
      child: balance == -1
          ? const CircularProgressIndicator(
              color: AppColors.secondaryBlue,
            )
          : Text(
              'Php $balance',
              style: getTextStyle(
                  textColor: AppColors.secondaryBlue,
                  fontFamily: AppFonts.poppins,
                  fontWeight: AppFontWeights.bold,
                  fontSize: 70),
            ),
    );

    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      body: SafeArea(
          child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            appBar(header),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 15, top: 22),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      mainContent,
                      Row(
                        children: [
                          AppFilledButton(
                            padding: const EdgeInsets.only(
                                left: 25, right: 23, bottom: 21, top: 28),
                            height: 42,
                            text: "Pay",
                            fontSize: 18,
                            fontFamily: AppFonts.poppins,
                            color: AppColors.accentOrange,
                            borderRadius: 5,
                            command: () {},
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Text(
                          'Transaction History',
                          style: getTextStyle(
                            textColor: AppColors.grey,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: AppFontWeights.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                          child: CreditsList(
                              transactionHistory: transactionHistory)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void onBack() => Navigator.of(context).pop();

  Widget appBar(String header) => Container(
        color: AppColors.secondaryBlue,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 14),
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
                header,
                style: getTextStyle(
                    textColor: AppColors.secondaryYellow,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: AppFontWeights.bold,
                    fontSize: 20),
              )
            ],
          ),
        ),
      );
}
