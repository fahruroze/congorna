import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:congorna/src/blocs/auth_bloc.dart';
import 'package:congorna/src/screen/login.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';
import 'package:congorna/utils/screenconfig.dart';
import 'package:provider/provider.dart';
import 'custom_shape.dart';
import 'profile_info.dart';
import 'profile_menu_item.dart';

class ProfileBody extends StatefulWidget {
  // const ProfileBody({Key key}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  StreamSubscription<FirebaseUser> profileStateSubcription;
  @override
  void initState() {
    final authBloc = Provider.of<AuthBloc>(context, listen: false);

    profileStateSubcription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    profileStateSubcription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    // var name = authBloc.isLoggedIn();
    return SingleChildScrollView(
      child: StreamBuilder<FirebaseUser>(
          stream: authBloc.currentUser,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: <Widget>[
                  InfoProfile(
                    image: "assets/images/pic.png",
                    // name: (snapshot.data.displayName == null)
                    //     ? 'tidak ada nama'
                    //     : snapshot.data.displayName,
                    name: 'tidak ada nama',
                    // name: displayName,
                    email: 'tidak ada email',

                    numberPhone: "+6282117835213",
                  ),
                  SizedBox(
                    height: ScreenConfig.defaultSize * 0.1,
                  ),
                  ProfileMenuItem(
                    iconSrc: "assets/icons/bookmark_fill.svg",
                    title: "Saved Jasa",
                    onPressed: () {},
                  ),
                  ProfileMenuItem(
                    iconSrc: "assets/icons/language.svg",
                    title: "Rubah Bahasa",
                    onPressed: () {},
                  ),
                  ProfileMenuItem(
                    iconSrc: "assets/icons/info.svg",
                    title: "Help",
                    onPressed: () {},
                  ),
                  ProfileMenuItem(
                    iconSrc: "assets/icons/logout.svg",
                    title: "Logout",
                    onPressed: () => authBloc.logout(),
                  )
                ],
              );
            } else {
              return Column(
                children: <Widget>[
                  InfoProfile(
                    // image: "assets/images/pic.png",
                    // name: "Alev",

                    // image: (snapshot.data.photoUrl == null)
                    //     ? "assets/images/pic.png"
                    //     : snapshot.data.photoUrl + '?width=400&height=500',

                    // name: (snapshot.data.displayName == null)
                    //     ? 'tidak ana nama'
                    //     : snapshot.data.displayName,
                    // name: 'displayName',
                    image: (snapshot.data.photoUrl != null)
                        ? snapshot.data.photoUrl + '?width=400&height=500'
                        : "assets/images/pic.png",

                    name: snapshot.data.displayName,

                    email: (snapshot.data.email != null)
                        ? snapshot.data.email
                        : (snapshot.data.uid != null)
                            ? snapshot.data.uid
                            : 'Tidak ada uid',

                    numberPhone: "+6282117835213",
                  ),
                  SizedBox(
                    height: ScreenConfig.defaultSize * 0.1,
                  ),
                  ProfileMenuItem(
                    iconSrc: "assets/icons/bookmark_fill.svg",
                    title: "Saved Jasa",
                    onPressed: () {},
                  ),
                  ProfileMenuItem(
                    iconSrc: "assets/icons/language.svg",
                    title: "Rubah Bahasa",
                    onPressed: () {},
                  ),
                  ProfileMenuItem(
                    iconSrc: "assets/icons/info.svg",
                    title: "Help",
                    onPressed: () {},
                  ),
                  ProfileMenuItem(
                    iconSrc: "assets/icons/logout.svg",
                    title: "Logout",
                    onPressed: () => authBloc.logout(),
                  )
                ],
              );
            }
          }),
    );
  }
}

// Widget pageBody(BuildContext context) {
//     var authBloc = Provider.of<AuthBloc>(context);
//     return Center(
//         child: (Platform.isIOS)
//             ? CupertinoButton(
//                 child: Text('Logout'),
//                 onPressed: () => authBloc.logout(),
//               )
//             : FlatButton(
//                 child: Text('Logout'),
//                 onPressed: () => authBloc.logout(),
//               ));
//   }
