import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';

abstract class AppNavbar {
  static CupertinoSliverNavigationBar cupertinoNavBar(
      {String title, @required BuildContext context}) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(
        title,
        style: TextStyles.navTitle,
      ),
      backgroundColor: Colors.transparent,
      border: null,
      leading: GestureDetector(
        child: Icon(CupertinoIcons.back, color: AppColors.brown),
        onTap: () => Navigator.of(context).pop(),
      ),
    );
  }

  static SliverAppBar materialNavBar(
      {@required String title, bool pinned, TabBar tabBar}) {
    return SliverAppBar(
      title: Text(
        title,
        style: TextStyles.navTitleMaterial,
      ),
      backgroundColor: AppColors.purpleViolet,
      bottom: tabBar,
      floating: true,
      pinned: (pinned == null) ? true : pinned,
      snap: true,
    );
  }
}
