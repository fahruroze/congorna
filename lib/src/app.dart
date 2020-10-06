import 'dart:io';
import 'package:congorna/src/blocs/order_bloc.dart';
import 'package:congorna/src/widgets/appstate.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:congorna/src/blocs/auth_bloc.dart';
import 'package:congorna/src/blocs/jasa_bloc.dart';
import 'package:congorna/src/screen/landing.dart';
import 'package:congorna/src/screen/login.dart';
import 'package:congorna/src/screen/welcome_screen.dart';
import 'package:congorna/src/services/firestore_service.dart';
import 'package:congorna/src/services/routes.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:provider/provider.dart';
import 'package:congorna/src/blocs/customer_bloc.dart';

final authBloc = AuthBloc();
final jasaBloc = JasaBloc();
final orderBloc = OrderBloc();
final customerBloc = CustomerBloc(); //new userbloc here

final firestoreService = FirestoreService();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

//STATE APP

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider(create: (context) => authBloc),
      Provider(create: (context) => jasaBloc),
      Provider(create: (context) => orderBloc),
      Provider(create: (context) => customerBloc), //PROVIDER new instance  here
      FutureProvider(create: (context) => authBloc.isLoggedIn()),
      StreamProvider(create: (context) => firestoreService.fetchTimes()),
      ChangeNotifierProvider(create: (context) => AppState())
    ], child: PlatformApp());
  }

//DISPOSE METHODE

  @override
  void dispose() {
    authBloc.dispose();
    jasaBloc.dispose();
    customerBloc.dispose();
    orderBloc.dispose();
    super.dispose();
  }
}

//SCREEN

class PlatformApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isLoggedIn = Provider.of<bool>(context);

//PLATFORM IOS
    if (Platform.isIOS) {
      return CupertinoApp(
        home: (isLoggedIn == null)
            // ? WelcomeScreen()
            ? loadingScreen(true)
            : (isLoggedIn == true) ? Landing() : Login(),
        onGenerateRoute: Routes.cupertinoRoutes,
        theme: CupertinoThemeData(
            scaffoldBackgroundColor: AppColors.secondColor,
            textTheme: CupertinoTextThemeData(
                tabLabelTextStyle: TextStyles.suggestion)),
      );
    } else {
      //PLATFORM ANDROID

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: (isLoggedIn == null)
            ? WelcomeScreen()
            // ? loadingScreen(true)
            // : (isLoggedIn == true) ? Landing() : Login(),
            : (isLoggedIn == true) ? Landing() : WelcomeScreen(),
        onGenerateRoute: Routes.materialRoutes,
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(color: Colors.white, elevation: 0),
            fontFamily: 'BigJohnPRO'),
      );
    }
  }

  Widget loadingScreen(bool isIOS) {
    return (isIOS)
        ? CupertinoPageScaffold(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
