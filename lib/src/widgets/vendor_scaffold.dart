import 'package:flutter/cupertino.dart';
import 'package:congorna/src/widgets/jasacuci.dart';
import 'package:congorna/src/widgets/orders.dart';
import 'package:congorna/src/screen/profile.dart';
import 'package:congorna/src/styles/colors.dart';

abstract class VendorScaffold {
  static CupertinoTabScaffold get cupertinoTabScaffold {
    return CupertinoTabScaffold(
      tabBar: _cupertinoTabBar,
      tabBuilder: (context, index) {
        return _pageSelection(index);
      },
    );
  }

  static get _cupertinoTabBar {
    return CupertinoTabBar(
      backgroundColor: AppColors.purpleViolet2,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.create), title: Text('Product')),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.create), title: Text('Order')),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.create), title: Text('Profile'))
      ],
    );
  }

  static Widget _pageSelection(int index) {
    if (index == 0) {
      return JasaCuci();
    }

    if (index == 1) {
      return Orders();
    }

    return Profile();
  }
}
