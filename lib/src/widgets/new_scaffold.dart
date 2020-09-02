import 'package:congorna/src/widgets/orders2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:congorna/src/widgets/jasacuci.dart';
import 'package:congorna/src/widgets/navbar.dart';
import 'package:congorna/src/widgets/orders.dart';
import 'package:congorna/src/screen/profile.dart';
import 'package:congorna/src/widgets/vendor_scaffold.dart';

abstract class AppSliverScaffold {
  static CupertinoPageScaffold cupertinoSliverScaffold(
      {String navTitle, Widget pageBody, BuildContext context}) {
    return CupertinoPageScaffold(
        child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          AppNavbar.cupertinoNavBar(title: navTitle, context: context),
        ];
      },
      body: pageBody,
    ));
  }

  static Scaffold materialSliverScaffold({
    String navTitle,
    Widget pageBody,
    BuildContext context,
  }) {
    // return Scaffold(
    //   body: SafeArea(
    //     hedaerSliverBuilder:
    //     child: AppNavbar.materialNavBar(title: navTitle, pinned: false),
    //     body: pageBody(),
    //   ),
    // );
    // return Scaffold(
    //   body: NestedScrollView(
    //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //       return <Widget>[
    //         AppNavbar.materialNavBar(
    //           title: navTitle,
    //           pinned: false,
    //         )
    //       ];
    //     },
    //     body: pageBody,
    //   ),
    // );
  }
}
