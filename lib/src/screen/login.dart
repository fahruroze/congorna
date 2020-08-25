import 'package:congorna/utils/screenConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    if (Platform.isIOS){
      return CupertinoPageScaffold(
        child: pageBody(context),
      );
    }else{
      return Scaffold(
        body: SafeArea(child: pageBody(context)),
      );
    }
  }
  Widget pageBody(BuildContext context){
    return ListView(
      padding: EdgeInsets.only(top: 150.0),
      children: <Widget>[

        Center(
          child: Text(
            "Aplikasi",
            style: GoogleFonts.sunflower(
              fontSize: ScreenConfig.blockHorizontal * 6,

            ),
          ),
        )
      ],
    );
  }
}
