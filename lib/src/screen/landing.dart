import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:congorna/src/blocs/customer_bloc.dart';
import 'package:congorna/src/components/landing/landing_body.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:congorna/src/widgets/button.dart';
import 'package:congorna/utils/screenconfig.dart';
import 'package:congorna/src/widgets/landing/myBottomNavBar.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var customerBloc = Provider.of<CustomerBloc>(context);
    ScreenConfig().init(context);
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: buildAppBar(context, customerBloc),
      );
    } else {
      return Scaffold(
        appBar: buildAppBar(context, customerBloc),
        body: LandingBody(),
        // bottomcustomerBlocNavigationBar: MyBottomNavBar(),
      );
    }
  }

  Widget buildAppBar(BuildContext context, customerBloc) {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
        color: AppColors.purpleViolet,
      ),
      centerTitle: true,
      title: Text(
        "Kumbah",
        style: TextStyles.header,
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {},
          color: AppColors.purpleViolet,
        ),
        SizedBox(
          width: ScreenConfig.defaultSize * 0.5,
        )
      ],
    );

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     // AppButton(
    //     //   buttonText: 'Kumbah Shoes',
    //     //   buttonType: ButtonType.Brown,
    //     //   onPressed: () => Navigator.pushNamed(context, '/vendor'),
    //     // ),
    //     // AppButton(
    //     //   buttonText: 'Kumbah Cloth',
    //     //   buttonType: ButtonType.Brown,
    //     //   onPressed: () => Navigator.pushNamed(context, '/vendor'),
    //     // ),
    //     // AppButton(
    //     //   buttonText: 'Kumbah Helm',
    //     //   buttonType: ButtonType.Brown,
    //     //   onPressed: () => Navigator.pushNamed(context, '/vendor'),
    //     // ),
    //     // AppButton(
    //     //   buttonText: 'Kumbah Motor',
    //     //   buttonType: ButtonType.Brown,
    //     //   onPressed: () => Navigator.pushNamed(context, '/vendor'),
    //     // )
    //   ],
    // );
  }
}
