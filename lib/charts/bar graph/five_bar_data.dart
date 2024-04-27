import 'package:laborlink/charts/bar graph/individual_bar.dart';

class FiveBarData {
  final double firstAmount;
  final double secondAmount;
  final double thirdAmount;
  final double fourthAmount;
  final double fifthAmount;

  FiveBarData({
    required this.firstAmount,
    required this.secondAmount,
    required this.thirdAmount,
    required this.fourthAmount,
    required this.fifthAmount,
  });

  List<IndividualBar> barData = [];

  // initialize bar data
  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: firstAmount),
      IndividualBar(x: 1, y: secondAmount),
      IndividualBar(x: 2, y: thirdAmount),
      IndividualBar(x: 3, y: fourthAmount),
      IndividualBar(x: 4, y: fifthAmount),
    ];
  }
}
