import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:congorna/src/blocs/auth_bloc.dart';
import 'package:congorna/src/styles/tabbar.dart';
import 'package:congorna/src/widgets/jasacuci.dart';
import 'package:congorna/src/widgets/navbar.dart';
import 'package:congorna/src/widgets/orders.dart';
import 'package:congorna/src/screen/profile.dart';
import 'package:congorna/src/widgets/vendor_scaffold.dart';
import 'package:provider/provider.dart';

class Vendor extends StatefulWidget {
  @override
  _VendorState createState() => _VendorState();

  static TabBar get vendorTabBar {
    return TabBar(
      unselectedLabelColor: TabBarStyles.unselectedLabelColor,
      labelColor: TabBarStyles.labelColor,
      indicatorColor: TabBarStyles.indicatorColor,
      tabs: <Widget>[
        Tab(icon: Icon(Icons.list)),
        Tab(icon: Icon(Icons.shopping_cart)),
        Tab(
          icon: Icon(Icons.person),
        )
      ],
    );
  }
}

class _VendorState extends State<Vendor> {
  StreamSubscription _userSubscription;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var authBloc = Provider.of<AuthBloc>(context, listen: false);
      _userSubscription = authBloc.mahasiswa.listen((mahasiswa) async {
        if (mahasiswa == null) {
          return Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              AppNavbar.cupertinoNavBar(title: 'Jasa Name', context: context)
            ];
          },
          body: VendorScaffold.cupertinoTabScaffold,
        ),
      );
    } else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                AppNavbar.materialNavBar(
                    title: 'Vendor Name', tabBar: Vendor.vendorTabBar)
              ];
            },
            body: TabBarView(children: <Widget>[
              JasaCuci(),
              Orders(),
              Profile(),
            ]),
          ),
        ),
      );
    }
  }
}
