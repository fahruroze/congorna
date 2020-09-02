import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:congorna/src/blocs/auth_bloc.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:congorna/src/widgets/alerts.dart';
import 'package:congorna/src/widgets/button.dart';
import 'package:congorna/src/widgets/insta_login.dart';
import 'package:congorna/src/widgets/insta_signup.dart';
import 'package:congorna/src/widgets/social_button.dart';
import 'package:congorna/src/widgets/textfield.dart';
import 'package:congorna/utils/screenconfig.dart';
import 'package:provider/provider.dart';

import '../styles/base.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  StreamSubscription _userSubscription;
  StreamSubscription _errorMessageSubscription;

  @override
  void initState() {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);
    _userSubscription = authBloc.mahasiswa.listen((mahasiwa) {
      // _userSubscription = authBloc.currentUser.listen((user) {
      if (mahasiwa != null) Navigator.pushReplacementNamed(context, '/landing');
    });

    _errorMessageSubscription = authBloc.errorMessage.listen((errorMessage) {
      if (errorMessage != '') {
        //SHOW OUR ALERT
        AppAlerts.showErrorDialog(Platform.isIOS, context, errorMessage)
            .then((_) => authBloc.clearErrorMessage());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _errorMessageSubscription.cancel();
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    ScreenConfig().init(context);
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(context, authBloc),
      );
    } else {
      return Scaffold(
        body: pageBody(context, authBloc),
      );
    }
  }

  Widget pageBody(BuildContext context, AuthBloc authBloc) {
    return ListView(
      padding: EdgeInsets.only(top: 100.0),
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Center(
          child: Text(
            "kumbah",
            style: TextStyle(
                fontFamily: 'Hagrid',
                fontSize: ScreenConfig.blockHorizontal * 12,
                fontWeight: FontWeight.bold,
                color: AppColors.purpleViolet),
          ),
        ),

        SizedBox(
          height: 50,
        ),
        Center(
          child: Text(
            "Silahkan isi form registrasi",
            style: TextStyle(
                fontFamily: 'Hagrid',
                fontSize: ScreenConfig.blockHorizontal * 4.2,
                fontWeight: FontWeight.w600,
                color: AppColors.hitam),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: authBloc.userName,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'Username',
                cupertinoIcon: CupertinoIcons.mail_solid,
                materialIcon: Icons.account_circle,
                textInputType: TextInputType.emailAddress,
                errorText: snapshot.error,
                onChange: authBloc.changeUserName,
              );
            }),
        // StreamBuilder<String>(
        //     stream: authBloc.phoneNumber,
        //     builder: (context, snapshot) {
        //       return AppTextField(
        //         isIOS: Platform.isIOS,
        //         hintText: 'Number Phone',
        //         cupertinoIcon: CupertinoIcons.phone_solid,
        //         materialIcon: Icons.phone,
        //         textInputType: TextInputType.phone,
        //         errorText: snapshot.error,
        //         onChange: authBloc.changePhoneNumber,
        //       );
        //     }),
        StreamBuilder<String>(
            stream: authBloc.email,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'Email',
                cupertinoIcon: CupertinoIcons.mail_solid,
                materialIcon: Icons.email,
                textInputType: TextInputType.emailAddress,
                errorText: snapshot.error,
                onChange: authBloc.changeEmail,
              );
            }),
        StreamBuilder<String>(
            stream: authBloc.password,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'Password',
                cupertinoIcon: IconData(0xf4c9,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage),
                materialIcon: Icons.lock,
                obscureText: true,
                errorText: snapshot.error,
                onChange: authBloc.changePassword,
              );
            }),
        StreamBuilder<bool>(
            stream: authBloc.isValid,
            builder: (context, snapshot) {
              return AppButton(
                buttonText: 'Singup',
                buttonType: (snapshot.data == true)
                    ? ButtonType.Register
                    : ButtonType.Disable,
                onPressed: authBloc.signUpEmail,
              );
            }),
        SizedBox(height: 20),
        Center(
            child: Text(
          'Atau Registrasi dengan',
          style: TextStyle(
              fontFamily: 'Hagrid',
              fontSize: ScreenConfig.blockHorizontal * 3.5,
              fontWeight: FontWeight.normal,
              color: AppColors.hitam),
        )),
        SizedBox(height: 10),
        Padding(
          padding: BaseStyles.listPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SocialButton(
                socialButtonType: SocialButtonType.Facebook,
                onPressed: () => authBloc.signUpFacebook(context: context),
              ),
              SizedBox(width: 15.0),
              SocialButton(
                socialButtonType: SocialButtonType.Google,
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => InstaSignUp()),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: BaseStyles.listPadding,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Sudah memiliki akun?',
                style: TextStyle(
                    fontFamily: 'Hagrid',
                    fontSize: ScreenConfig.blockHorizontal * 3.5,
                    fontWeight: FontWeight.normal,
                    color: AppColors.hitam),
                children: [
                  TextSpan(
                      text: 'Login',
                      style: TextStyles.link,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushNamed(context, '/login'))
                ]),
          ),
        )
      ],
    );
  }
}
