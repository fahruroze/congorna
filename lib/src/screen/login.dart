import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:congorna/src/blocs/auth_bloc.dart';
import 'package:congorna/src/models/pejasa.dart';
import 'package:congorna/src/screen/landing.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:congorna/src/styles/textfield.dart';
import 'package:congorna/src/widgets/alerts.dart';
import 'package:congorna/src/widgets/button.dart';
import 'package:congorna/src/widgets/insta_login.dart';
import 'package:congorna/src/widgets/social_button.dart';
import 'package:congorna/src/widgets/textfield.dart';
import 'package:congorna/utils/screenconfig.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../styles/colors.dart';
import '../styles/base.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  StreamSubscription _userSubscription;
  StreamSubscription _errorMessageSubscription;

  @override
  void initState() {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);
    _userSubscription = authBloc.mahasiswa.listen((mahasiswa) {
      // _userSubscription = authBloc.currentUser.listen((user) {
      if (mahasiswa != null)
        Navigator.pushReplacementNamed(context, '/landing');
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
    _userSubscription.cancel();
    _errorMessageSubscription.cancel();
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
    final authBloc = Provider.of<AuthBloc>(context);
    // authBloc.showInstagramSignUpWeb = true;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        padding: EdgeInsets.only(top: 100.0),
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              "Kumbah",
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
              "Silahkan isi form login",
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
                  buttonText: 'Login',
                  buttonType: (snapshot.data == true)
                      ? ButtonType.Login
                      : ButtonType.Disable,
                  onPressed: () => authBloc.loginEmail(contextLanding: context),
                );
              }),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Atau login dengan',
              style: TextStyle(
                  fontFamily: 'Hagrid',
                  fontSize: ScreenConfig.blockHorizontal * 3.5,
                  fontWeight: FontWeight.normal,
                  color: AppColors.hitam),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: BaseStyles.listPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocialButton(
                    socialButtonType: SocialButtonType.Facebook,
                    onPressed: () => authBloc.loginFacebook(
                          context: context,
                          contextLanding: context,
                        )),

                // SignInButton(
                //   Buttons.Facebook,
                //   onPressed: () => authBloc.loginFacebook(),
                // ),
                SizedBox(width: 15.0),
                SocialButton(
                  socialButtonType: SocialButtonType.Google,
                  // onPressed: () => Navigator.pushNamed(context, '/login'),
                  onPressed: () => Navigator.pushReplacement(
                      context,

                      // authBloc.showInstagramSignUpWeb.sink.add(true);

                      MaterialPageRoute(
                        builder: (context) => InstaLogin(),
                      )),
                ),
                // onPressed: () {
                //   setState(() => _showInstagramSignUpWeb = true);
                //   // setState(() => authBloc.showInstagramSignUpWeb);
                // }),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: BaseStyles.listPadding,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Belum memiliki akun?',
                  // style: TextStyles.loginText,
                  style: TextStyle(
                      fontFamily: 'Hagrid',
                      fontSize: ScreenConfig.blockHorizontal * 3.5,
                      fontWeight: FontWeight.normal,
                      color: AppColors.hitam),
                  children: [
                    TextSpan(
                        text: 'Signup',
                        style: TextStyles.link,
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => Navigator.pushNamed(context, '/signup'))
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
