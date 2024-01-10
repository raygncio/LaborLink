import 'package:flutter/material.dart';
import 'package:laborlink/dummyDatas.dart';
import 'package:laborlink/styles.dart';

class LaborMenu extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final Function(String) onLaborSelected;
  const LaborMenu({Key? key, this.padding, required this.onLaborSelected})
      : super(key: key);

  @override
  State<LaborMenu> createState() => _LaborMenuState();
}

class _LaborMenuState extends State<LaborMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            mainAxisExtent: 65),
        itemCount: labors.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> labor = labors[index];
          String laborImgPath = labor["path"];
          String laborName = labor["name"];

          return GestureDetector(
            onTap: () {
              onLaborSelect(
                  index); // Pass the index when a labor category is tapped
            },
            child: Column(
              children: [
                SizedBox(
                  height: 38,
                  width: 38,
                  child: Image.asset(laborImgPath),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    laborName,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                        textColor: AppColors.black,
                        fontFamily: AppFonts.montserrat,
                        fontWeight: AppFontWeights.medium,
                        fontSize: 8),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void onLaborSelect(int index) {
    String selectedLaborName = labors[index]["name"];
    // print('Selected labor: $selectedLaborName');
    // Call the callback function with the selected labor name
    widget.onLaborSelected(selectedLaborName);
  }
}
