import 'package:congorna/src/screen/choose_jasa.dart';
import 'package:congorna/src/screen/edit_jasa.dart';
import 'package:congorna/src/screen/landing.dart';
import 'package:congorna/src/screen/login.dart';
import 'package:congorna/src/screen/signup.dart';
import 'package:congorna/src/widgets/orders.dart';
import 'package:congorna/src/widgets/orders2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:congorna/src/screen/vendor.dart';
import 'package:congorna/src/widgets/jasacuci.dart';

abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/landing":
        return MaterialPageRoute(builder: (context) => Landing());
        break;
      case "/signup":
        return MaterialPageRoute(builder: (context) => Signup());
        break;
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/vendor":
        return MaterialPageRoute(builder: (context) => Vendor());
      case "/editjasa":
        return MaterialPageRoute(builder: (context) => EditJasa());
      case "/choosejasa":
        return MaterialPageRoute(builder: (context) => ChooseJasa());
      case "/pickup":
        return MaterialPageRoute(builder: (context) => Orders());
      default:
        var routeArray = settings.name.split('/');
        if (settings.name.contains('/choosejasa/')) {
          return MaterialPageRoute(
              builder: (contex) => ChooseJasa(
                    jasaId: routeArray[2],
                  ));
        }
        return MaterialPageRoute(builder: (context) => Login());
    }
  }

  static CupertinoPageRoute cupertinoRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/landing":
        return CupertinoPageRoute(builder: (context) => Landing());
        break;
      case "/signup":
        return CupertinoPageRoute(builder: (context) => Signup());
        break;
      case "/login":
        return CupertinoPageRoute(builder: (context) => Login());
      case "/vendor":
        return CupertinoPageRoute(builder: (context) => Vendor());
      case "/editjasa":
        return CupertinoPageRoute(builder: (context) => EditJasa());
      case "/choosejasa":
        return CupertinoPageRoute(builder: (context) => ChooseJasa());
      case "/pickup":
        return CupertinoPageRoute(builder: (context) => ChooseJasa());
      default:
        var routeArray = settings.name.split('/');
        if (settings.name.contains('/choosejasa/')) {
          return CupertinoPageRoute(
              builder: (context) => ChooseJasa(
                    jasaId: routeArray[2],
                  ));
        }
        // if (settings.name.contains('/pickup/')) {
        //   return CupertinoPageRoute(
        //       builder: (context) => Pickup(
        //             jasaId: routeArray[2],
        //           ));
        // }
        return CupertinoPageRoute(builder: (context) => Login());
    }
  }
}
