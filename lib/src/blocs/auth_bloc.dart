import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:congorna/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:congorna/src/models/mahasiswa.dart';
import 'package:congorna/src/screen/landing.dart';
import 'package:congorna/src/screen/login.dart';
import 'package:congorna/src/screen/signup.dart';
import 'package:congorna/src/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:congorna/src/services/auth_service.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

final RegExp regExpPhone = RegExp(r"^(?:[+0]+)?[0-9]{6,14}$");

class AuthBloc {
  // final _phoneNumber = BehaviorSubject<String>();
  final _userName = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _userImage = BehaviorSubject<String>();

  final _user = BehaviorSubject<User>();
  final _mahasiswa = BehaviorSubject<Mahasiswa>();
  final _errorMessage = BehaviorSubject<String>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final authService = AuthService();
  final fb = FacebookLogin();
  final _stackIndex = BehaviorSubject<int>();
  final _showInstagramSignUpWeb = BehaviorSubject<bool>();

  static final String appId = '3708220475872403';
  static final String appSecret = 'd6e69c40e6975fe5cae1faf59662a1b6';
  static final String redirectUri = 'https://github.com/fahruroze';
  static final String initialUrl =
      'https://api.instagram.com/oauth/authorize?client_id=$appId&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=code';
  final authFunctionUrl =
      'https://us-central1-pasar-2cb89.cloudfunctions.net/makeCustomToken';

  // num _stackIndex = 1;

  // final facebookLogin = new FacebookLogin();
  //Get Data
  // Stream<String> get phoneNumber =>
  //     _phoneNumber.stream.transform(validatePhone);
  // Stream<FirebaseUser> get currentUser => _auth.onAuthStateChanged;

  Stream<FirebaseUser> get currentUser => authService.currentUser;

  Stream<String> get userName => _userName.stream;
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get userImage => _userImage.stream;
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get isValid =>
      CombineLatestStream.combine2(email, password, (email, password) => true);
  Stream<Mahasiswa> get mahasiswa => _mahasiswa.stream;

  Stream<User> get user => _user.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  String get mahasiswaId => _mahasiswa.value.mahasiswaId;

  String get userId => _user.value.userId;
  Stream<int> get stackIndex => _stackIndex.stream;
  Stream<bool> get showInstagramSignUpWeb => _showInstagramSignUpWeb.stream;

  //SET DATA

  Function(String) get changeUserName => _userName.sink.add;
  // Function(String) get changePhoneNumber => _phoneNumber.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeUserImage => _userImage.sink.add;

  dispose() {
    _userName.close();
    _email.close();
    _userImage.close();
    _password.close();
    _mahasiswa.close();

    _user.close();
    _errorMessage.close();
    _stackIndex.close();
    _showInstagramSignUpWeb.close();
  }

  //Transformer
  final validatePhone = StreamTransformer<String, String>.fromHandlers(
      handleData: (phoneNumber, sink) {
    if (phoneNumber != null &&
        phoneNumber.length >= 10 &&
        phoneNumber.length <= 13 &&
        regExpPhone.hasMatch(phoneNumber.trim())) {
      try {
        sink.add(phoneNumber);
      } catch (e) {
        sink.addError('Masukan No Hp yang benar!');
      }
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (regExpEmail.hasMatch(email.trim())) {
      sink.add(email.trim());
    } else {
      sink.addError('Mohon gunakan email yang benar!');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password.trim());
    } else {
      sink.addError('Gunakan minimal 8 karakter!');
    }
  });

  loginEmail({BuildContext contextLanding}) async {
    print('Login up with username and password');
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());

      var mahasiswa = await _firestoreService.fetchUser(authResult.user.uid);
      print('INII USERRR UIDDD');
      print(authResult.user.uid);
      _mahasiswa.sink.add(mahasiswa);

      FirebaseUser profile = await FirebaseAuth.instance.currentUser();

      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = mahasiswa.userName;
      await profile.updateProfile(updateInfo);
      print('USERNAME IS: ${profile.displayName}');
    } on PlatformException catch (e) {
      print(e);
      print('ini ERRORRRRRR');
      _errorMessage.sink.add(e.message);
    }
  }

  signUpEmail() async {
    print('signin up with username and password');
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());
      var mahasiswa = Mahasiswa(
          mahasiswaId: authResult.user.uid,
          userName: _userName.value.trim(),
          // phoneNumber: _phoneNumber.value.trim(),
          email: _email.value.trim());

      await _firestoreService.addUser(mahasiswa);
      _mahasiswa.sink.add(mahasiswa);

      FirebaseUser profile = await FirebaseAuth.instance.currentUser();

      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = mahasiswa.userName;
      await profile.updateProfile(updateInfo);
      print('USERNAME IS: ${profile.displayName}');
    } on PlatformException catch (e) {
      print(e);
      _errorMessage.sink.add(e.message);
    }
  }

  loginFacebook({BuildContext context, contextLanding}) async {
    print('Login pake Facebook');
    try {
      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]);

      switch (res.status) {
        case FacebookLoginStatus.Success:
          print("user login success");

          //get Token
          final FacebookAccessToken fbToken = res.accessToken;
          print('PROSESSS 0000 BROOOO');
          //convert Auth credential
          final AuthCredential credential =
              FacebookAuthProvider.getCredential(accessToken: fbToken.token);

          // User Credential to signIn to firebase
          var result = await authService.signInWithCredential(credential);

          if (result.additionalUserInfo.isNewUser == true) {
            print('KE SIGNUPPPP BROOOO');

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Signup()));
          } else {
            print('LOGIN USER TERDAFTAR FIREBASE AUTH');

            print('FETCH USER FIRESTORE');
            try {
              var result = await authService.signInWithCredential(credential);

              print('INI USER UID');
              print(result.user.uid);

              var mahasiswa =
                  await _firestoreService.fetchUser(result.user.uid);
              _mahasiswa.sink.add(mahasiswa);
            } catch (e) {
              print('USER HARUS REGISTER');
              Navigator.pushReplacement(contextLanding,
                  MaterialPageRoute(builder: (contextLanding) => Signup()));
            }

            // var result = await authService.signInWithCredential(credential);

            // print('INI USER UID');
            // print(result.user.uid);

            // var user = await _firestoreService.fetchUser(result.user.uid);

            // _user.sink.add(user);

            // print('${result.user.displayName} IS LOGIN BRO!');
          }

          // print('SUKSES LOGIN!!!');

          break;
        case FacebookLoginStatus.Cancel:
          print("user login cancel");
          break;
        case FacebookLoginStatus.Error:
          print("user login error");
          break;
      }
    } on PlatformException catch (e) {
      print(e);
      print('ini ERRORRRRRR');
      _errorMessage.sink.add(e.message);
    }
    // ^((?!isSBSettingEnabled|OtherLog|OtherLog2|Annoying Messages).)*$
  }

  signUpFacebook({BuildContext context}) async {
    print('Login pake Facebook');
    // ^((?!isSBSettingEnabled|OtherLog|OtherLog2|Annoying Messages).)*$

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (res.status) {
      case FacebookLoginStatus.Success:
        print("user login success");

        //get Token
        final FacebookAccessToken fbToken = res.accessToken;

        //convert Auth credential
        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: fbToken.token);

        // User Credential to signIn to firebase
        final result = await authService.signInWithCredential(credential);

        if (result.additionalUserInfo.isNewUser == true) {
          print('USER TIDAK TERDAFTAR');
          print('DAFTARKAN FIREBASE');

          print('MODEL USER');
          print('IMAGEEEEE USER');
          print(result.user.photoUrl);

          var mahasiswa = Mahasiswa(
              mahasiswaId: result.user.uid,
              userName: result.user.displayName.trim(),
              email: result.user.email.trim(),
              userImage: result.user.photoUrl.trim());

          await _firestoreService.addUser(mahasiswa);
          _mahasiswa.sink.add(mahasiswa);
        } else {
          try {
            print('USER FETCH FIRESTORE');
            var mahasiswa = await _firestoreService.fetchUser(result.user.uid);
            // _user.sink.add(user);

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
            _errorMessage.sink.add('USER SUDAH TERDAFTAR');

            print('=== USER SUDAH TERDAFTAR ===');
          } catch (e) {
            print('USER TIDAK TERDAFTAR DI DATABASE');

            print('MODEL USER');

            var mahasiswa = Mahasiswa(
                mahasiswaId: result.user.uid,
                userName: result.user.displayName.trim(),
                email: result.user.email.trim(),
                userImage: result.user.photoUrl.trim());

            await _firestoreService.addUser(mahasiswa);
            _mahasiswa.sink.add(mahasiswa);

            // phoneNumber: _phoneNumber.value.trim(),
            // email: _email.value.trim());

            print('${result.user.displayName} IS LOGIN BRO!');
          }
        }

        break;

      case FacebookLoginStatus.Cancel:
        print("user login cancel");
        break;
      case FacebookLoginStatus.Error:
        print("user log,in error");
        break;
    }
  }

  loginInstagram({
    String code,
    BuildContext context,
    contextLanding,
    // contextSignup,
  }) async {
    // setState(() => _stackIndex = 2);
    // _showInstagramSignUpWeb.sink.add(false);
    _stackIndex.sink.add(2);

    try {
      // Step 1. Get user's short token using facebook developers account information
      // Http post to Instagram access token URL.
      final http.Response response = await http
          .post("https://api.instagram.com/oauth/access_token", body: {
        "client_id": appId,
        "redirect_uri": redirectUri,
        "client_secret": appSecret,
        "code": code,
        "grant_type": "authorization_code"
      });

      // Step 2. Change Instagram Short Access Token -> Long Access Token.
      final http.Response responseLongAccessToken = await http.get(
          'https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=$appSecret&access_token=${json.decode(response.body)['access_token']}');

      // Step 3. Take User's Instagram Information using LongAccessToken
      final http.Response responseUserData = await http.get(
          'https://graph.instagram.com/${json.decode(response.body)['user_id'].toString()}?fields=id,username,account_type,media_count&access_token=${json.decode(responseLongAccessToken.body)['access_token']}');

      // Step 4. Making Custom Token For Firebase Authentication using Firebase Function.
      final http.Response responseCustomToken = await http.get(
          '$authFunctionUrl?instagramToken=${json.decode(responseUserData.body)['id']}');

      // Step 5. Sign Up with Custom Token.
      var result = await _auth
          .signInWithCustomToken(
              token: json.decode(responseCustomToken.body)['customToken'])
          .then((AuthResult _authResult) async {
        print('BOOL USER');

        if (_authResult.additionalUserInfo.isNewUser == true) {
          print('USER TIDAK TERDAFTAR');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Signup()));
        } else {
          print('USER TERDAFTAR FIREBASE AUTH');

          print('FETCH USER FIRESTORE');
          try {
            var mahasiswa =
                await _firestoreService.fetchUser(_authResult.user.uid);

            print('SINK USER FOR LOGIN');
            _mahasiswa.sink.add(mahasiswa);

            FirebaseUser profile = await FirebaseAuth.instance.currentUser();

            UserUpdateInfo updateInfo = UserUpdateInfo();
            updateInfo.displayName = mahasiswa.userName;
            await profile.updateProfile(updateInfo);
            print('USERNAME IS: ${profile.displayName}');

            print('${_authResult.user.displayName} IS LOGIN BRO!');
            print('${_authResult.user.uid} IS LOGIN BRO!');

            _stackIndex.sink.add(1);
            _showInstagramSignUpWeb.sink.add(false);

            print('SUKSES LOGINNNNNNNN');
            Navigator.pushReplacement(contextLanding,
                MaterialPageRoute(builder: (contextLanding) => Landing()));
          } catch (e) {
            // Navigator.of(contextSignup).pushNamed('/signup');
            // Navigator.pushNamed(contextSignup, '/landing');
            // Navigator.pushReplacement(contextSignup,
            //     MaterialPageRoute(builder: (contextSignup) => Signup()));
          }
        }

        // user.getIdTokenResult()
      }).catchError((error) {
        print('Unable to sign in using custom token');
      });
      // var user = await _firestoreService.fetchUser(result.);
      // _user.sink.add(user);
      _stackIndex.sink.add(1);
      _showInstagramSignUpWeb.sink.add(false);

      // Change the variable status.

      // setState(() {
      //   _userData = json.decode(responseUserData.body);
      //   _stackIndex = 1;
      //   _showInstagramSingUpWeb = false;
      // });
    } catch (e) {
      print(e.toString());
    }
  }

  signupInstagram({
    String code,
    BuildContext context,
    BuildContext contextLogin,
  }) async {
    // setState(() => _stackIndex = 2);
    _showInstagramSignUpWeb.sink.add(false);
    _stackIndex.sink.add(2);
    // var _stackIndex = 2;

    try {
      // Step 1. Get user's short token using facebook developers account information
      // Http post to Instagram access token URL.
      final http.Response response = await http
          .post("https://api.instagram.com/oauth/access_token", body: {
        "client_id": appId,
        "redirect_uri": redirectUri,
        "client_secret": appSecret,
        "code": code,
        "grant_type": "authorization_code"
      });

      // Step 2. Change Instagram Short Access Token -> Long Access Token.
      final http.Response responseLongAccessToken = await http.get(
          'https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=$appSecret&access_token=${json.decode(response.body)['access_token']}');

      // Step 3. Take User's Instagram Information using LongAccessToken
      final http.Response responseUserData = await http.get(
          'https://graph.instagram.com/${json.decode(response.body)['user_id'].toString()}?fields=id,username,account_type,media_count&access_token=${json.decode(responseLongAccessToken.body)['access_token']}');

      // final http.Response responseUserData = await http.get(
      //     'https://graph.instagram.com/${json.decode(response.body)['userId'].toString()}?fields=id,username,account_type,media_count&access_token=${json.decode(responseLongAccessToken.body)['access_token']}');

      // Step 4. Making Custom Token For Firebase Authentication using Firebase Function.
      final http.Response responseCustomToken = await http.get(
          '$authFunctionUrl?instagramToken=${json.decode(responseUserData.body)['id']}');

      // Step 5. Sign Up with Custom Token.
      var result = await _auth
          .signInWithCustomToken(
              token: json.decode(responseCustomToken.body)['customToken'])
          .then((AuthResult _authResult) async {
        if (_authResult.additionalUserInfo.isNewUser == true) {
          print('USER TIDAK TERDAFTAR');
          print('DAFTARKAN FIREBASE');

          print('MODEL USER');
          var mahasiswa = Mahasiswa(
            mahasiswaId: json.decode(responseUserData.body)['id'],
            userName: json.decode(responseUserData.body)['username'],
            email: json.decode(responseUserData.body)['customToken'],
          );
          print('ADD USER TO FIRESTORE');

          await _firestoreService.addUser(mahasiswa);

          print('SINK USER FOR LOGIN');
          _mahasiswa.sink.add(mahasiswa);

          print('${_authResult.user.displayName} IS LOGIN BRO!');
          FirebaseUser profile = await FirebaseAuth.instance.currentUser();

          UserUpdateInfo updateInfo = UserUpdateInfo();
          updateInfo.displayName = mahasiswa.userName;
          await profile.updateProfile(updateInfo);
          print('USERNAME IS: ${profile.displayName}');

          _stackIndex.sink.add(1);
          _showInstagramSignUpWeb.sink.add(false);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Landing()));
        } else {
          print('USER TERDAFTAR FIREBASE AUTH');

          print('FETCH USER FIRESTORE');

          // var user = await _firestoreService.fetchUser(_authResult.user.uid);

          // if (user != null) {
          //   print('USER SUDAH ADA DI DATABASE');
          //   Navigator.pushReplacement(
          //       context, MaterialPageRoute(builder: (context) => Login()));
          // }

          try {
            var mahasiswa =
                await _firestoreService.fetchUser(_authResult.user.uid);
            // _user.sink.add(user);

            Navigator.pushReplacement(contextLogin,
                MaterialPageRoute(builder: (contextLogin) => Login()));
          } catch (e) {
            print('USER TIDAK TERDAFTAR DI DATABASE');

            print('MODEL USER');
            var mahasiswa = Mahasiswa(
              mahasiswaId: json.decode(responseUserData.body)['id'],
              userName: json.decode(responseUserData.body)['username'],
              email: json.decode(responseUserData.body)['customToken'],
            );
            print('ADD USER TO FIRESTORE');

            await _firestoreService.addUser(mahasiswa);

            print('SINK USER FOR LOGIN');
            _mahasiswa.sink.add(mahasiswa);

            print('${_authResult.user.displayName} IS LOGIN BRO!');
            FirebaseUser profile = await FirebaseAuth.instance.currentUser();

            UserUpdateInfo updateInfo = UserUpdateInfo();
            updateInfo.displayName = mahasiswa.userName;
            await profile.updateProfile(updateInfo);
            print('USERNAME IS: ${profile.displayName}');

            _stackIndex.sink.add(1);
            _showInstagramSignUpWeb.sink.add(false);

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Landing()));
          }
        }

        print('SUKSESSS SIGNUPPPPP');
      }).catchError((error) {
        print('Unable to sign in using custom token');
      });

      // await Firestore.instance
      //     .collection('users')
      //     .document(json.decode(responseUserData.body)['id'])
      //     .setData({
      //   'id': json.decode(responseUserData.body)['id'],
      //   'username': json.decode(responseUserData.body)['username'],
      //   'account_type': json.decode(responseUserData.body)['account_type'],
      //   'media_count': json.decode(responseUserData.body)['media_count'],
      //   'customToken': json.decode(responseCustomToken.body)['customToken']
      // });

      // Change the variable status.

      // setState(() {
      //   _userData = json.decode(responseUserData.body);
      //   _stackIndex = 1;
      //   _showInstagramSingUpWeb = false;
      // });

    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> isLoggedIn() async {
    var firebaseUser = await _auth.currentUser();

    if (firebaseUser == null) return false;

    try {
      var mahasiswa = await _firestoreService.fetchUser(firebaseUser.uid);

      FirebaseUser profile = await FirebaseAuth.instance.currentUser();

      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = firebaseUser.displayName;
      await profile.updateProfile(updateInfo);
      print('IS LOGIN: ${profile.displayName}');
      print('IS LOGIN: ${profile.uid}');
      // print('IS LOGIN: ${profile.userName}');
      print('IS LOGIN: ${profile.email}');

      if (mahasiswa == null) return false;
      _mahasiswa.sink.add(mahasiswa);
      return true;
    } catch (e) {
      if (mahasiswa == null) return false;
    }
  }

  // Future<void> logout() {} => _auth.signOut();

  logout() async {
    print('LOGOUTTT');

    var firebaseUser = await _auth.currentUser();

    FirebaseUser profile = await FirebaseAuth.instance.currentUser();

    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = firebaseUser.displayName;
    await profile.updateProfile(updateInfo);
    // print('IS LOGIN: ${profile.displayName}');

    if (mahasiswa != null) {
      print('LOGOUTTTT: ${profile.email}');
    } else {
      print("GA ADA USER");
    }

    // await _auth.signOut();
    // await _auth.logOut();
    // await authService.logOut();
    await FirebaseAuth.instance.signOut();
    await _auth.currentUser();
    _mahasiswa.sink.add(null);
  }

  clearErrorMessage() {
    _errorMessage.sink.add('');
  }
}
