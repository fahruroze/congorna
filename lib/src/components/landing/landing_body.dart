import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:congorna/src/blocs/customer_bloc.dart';
import 'package:congorna/src/widgets/landing/daerah.dart';
import 'package:congorna/src/widgets/landing/jenisJasaCard.dart';
import 'package:congorna/utils/screenconfig.dart';
import 'package:provider/provider.dart';

class LandingBody extends StatelessWidget {
  const LandingBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var customerBloc = Provider.of<CustomerBloc>(context);

    return SafeArea(
      child: Column(
        children: <Widget>[
          DaerahJasaCuci(), //DAERAH Class
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenConfig.defaultSize * 2,
              ),
              child: GridView.builder(
                itemCount: 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      ScreenConfig.orientation == Orientation.landscape ? 2 : 1,
                  mainAxisSpacing: 20,
                  crossAxisSpacing:
                      ScreenConfig.orientation == Orientation.landscape
                          ? ScreenConfig.defaultSize * 2
                          : 0,
                  childAspectRatio: 1.65,
                ),
                itemBuilder: (context, index) => JenisJasaCard(
                  press: () => Navigator.pushNamed(context, '/vendor'),
                ),
              ),
            ),
          ),
          // JenisJasaCard(),
        ],
      ),
    );
  }
}
