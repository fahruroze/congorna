import 'package:flutter/material.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/utils/screenconfig.dart';

class DaerahJasaCuci extends StatefulWidget {
  @override
  _DaerahJasaCuciState createState() => _DaerahJasaCuciState();
}

class _DaerahJasaCuciState extends State<DaerahJasaCuci> {
  List<String> daerah = ["Indramayu", "Cirebon", "Majalengka", "Kuningan"];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenConfig.defaultSize * 1),
      child: SizedBox(
        height: ScreenConfig.defaultSize * 3.5,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: daerah.length,
            itemBuilder: (context, index) => buildDaerahItem(index)),
      ),
    );
  }

  Widget buildDaerahItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: ScreenConfig.defaultSize * 2),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenConfig.defaultSize * 1,
            vertical: ScreenConfig.defaultSize * 0.5),
        decoration: BoxDecoration(
          color:
              selectedIndex == index ? AppColors.purpleM : Colors.transparent,
          borderRadius: BorderRadius.circular(ScreenConfig.defaultSize * 1.6),
        ),
        child: Text(
          daerah[index],
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: selectedIndex == index
                  ? AppColors.purpleViolet
                  : AppColors.purpleViolet),
        ),
      ),
    );
  }
}
