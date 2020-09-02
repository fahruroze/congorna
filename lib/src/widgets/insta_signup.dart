import 'package:flutter/material.dart';
import 'package:congorna/src/blocs/auth_bloc.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstaSignUp extends StatefulWidget {
  // instaLogin({Key key}) : super(key: key);

  @override
  _InstaSignUpState createState() => _InstaSignUpState();
}

class _InstaSignUpState extends State<InstaSignUp> {
  static final String appId = '3708220475872403';
  static final String appSecret = 'd6e69c40e6975fe5cae1faf59662a1b6';
  static final String redirectUri = 'https://github.com/fahruroze';
  static final String initialUrl =
      'https://api.instagram.com/oauth/authorize?client_id=$appId&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=code';
  final authFunctionUrl =
      'https://us-central1-pasar-2cb89.cloudfunctions.net/makeCustomToken';

  bool _showInstagramSignUpWeb = false;
  num _stackIndex = 1;
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);
    return Scaffold(
      body: IndexedStack(
        index: _stackIndex,
        children: <Widget>[
          WebView(
            initialUrl: initialUrl,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith(redirectUri)) {
                if (request.url.contains('error')) print('the url error');
                var startIndex = request.url.indexOf('code=');
                var endIndex = request.url.lastIndexOf('#');
                var code = request.url.substring(startIndex + 5, endIndex);
                print('IINI CODENYAAAA');
                print(code);

                // _logIn(code);
                authBloc.signupInstagram(
                  code: code,
                  context: context,
                  contextLogin: context,
                );

                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (url) => print("Page started " + url),
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            onPageFinished: (url) => setState(() => _stackIndex = 0),
          ),
          Center(child: Text('Loading open web page ...')),
          Center(child: Text('Creating Profile ...'))
        ],
      ),
    );
  }
}
