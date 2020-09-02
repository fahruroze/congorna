import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:congorna/src/blocs/customer_bloc.dart';

import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/utils/screenconfig.dart';
import 'package:provider/provider.dart';

class JenisJasaCard extends StatelessWidget {
  // from model
  // final RecipeBundle recipeBundle;
  final Function press;

  const JenisJasaCard({Key key, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var customerBloc = Provider.of<CustomerBloc>(context);
    double defaultSize = ScreenConfig.defaultSize;
    return GestureDetector(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.purpleViolet,
            borderRadius: BorderRadius.circular(defaultSize * 2)),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(defaultSize * 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Text(
                    "Kumba Shoe",
                    style: TextStyle(
                        fontFamily: "Hagrid",
                        fontWeight: FontWeight.bold,
                        fontSize: defaultSize * 1.9,
                        color: AppColors.putih),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: defaultSize * 1,
                  ),
                  Text(
                    "Silahkan Order Layanan Cuci Sepatu",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: defaultSize * 1.5,
                        color: AppColors.putih),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: defaultSize * 1,
                  ),
                  buildInfoRow(defaultSize,
                      iconSrc: "assets/icons/sneaker.svg", text: "5 Layanan"),
                  buildInfoRow(defaultSize,
                      iconSrc: "assets/icons/pejasa.svg", text: "2 Pejasa"),
                  Spacer(),
                ],
              ),
            )),
            // SizedBox(
            //     // width: defaultSize * 0.5,
            //     ),
            AspectRatio(
              aspectRatio: 0.85,
              child: Image.asset(
                "assets/images/sneaker.png",
                fit: BoxFit.cover,
                alignment: Alignment.topLeft,
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildInfoRow(double defaultSize, {String iconSrc, text}) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          iconSrc,
          height: 25,
        ),
        SizedBox(width: defaultSize),
        Text(text,
            style: TextStyle(
              color: AppColors.putih,
              fontWeight: FontWeight.bold,
            ))
      ],
    );
  }
}
