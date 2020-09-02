import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:congorna/src/components/onboardscreen/background.dart';
import 'package:congorna/src/screen/login.dart';
import 'package:congorna/src/screen/signup.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/rounded_button.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:congorna/src/widgets/button.dart';

class OnBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.40,
            ),
            // RoundedButton(
            //   text: "SIGNIN",
            //   press: () {},
            // ),
            // RoundedButton(
            //   text: "SIGNUP",
            //   press: () {},
            //   color: unguMuda,
            // ),
            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Welcome to Kumbah!",
                    style: TextStyles.onBoardText,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 2.0),
              child: Text(
                "Tidak ada waktu untuk mencuci? Jangan buang waktu berhargamu!",
                style: TextStyles.subOnBoardText,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            AppButton(
                buttonText: "SING IN",
                buttonType: ButtonType.Login,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Login();
                      },
                    ),
                  );
                }),
            AppButton(
              buttonText: "SIGN UP",
              buttonType: ButtonType.Register,
              // onPressed: () => Navigator.pushNamed(context, '/signup'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Signup();
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
