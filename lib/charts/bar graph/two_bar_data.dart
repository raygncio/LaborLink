import 'package:laborlink/charts/bar graph/individual_bar.dart';

class TwoBarData {
  final double firstAmount;
  final double secondAmount;

  TwoBarData({required this.firstAmount, required this.secondAmount});

  List<IndividualBar> barData = [];

  // initialize bar data
  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: firstAmount),
      IndividualBar(x: 1, y: secondAmount),
    ];
  }
}
