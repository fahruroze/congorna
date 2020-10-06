
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congorna/src/blocs/order_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:congorna/src/widgets/appstate.dart';

class Orders extends StatefulWidget {
  Orders() : super();

  // final String title
  @override
  _OrdersState createState() => _OrdersState();
}

final ordersScaffoldKey = GlobalKey<ScaffoldState>();

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Peta());
  }
}

class Peta extends StatefulWidget {
  @override
  _PetaState createState() => _PetaState();
}

class _PetaState extends State<Peta> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final Firestore _db = Firestore();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription iosSubcription;
  List<Message> _messages;

  _getToken() async {

    //GET TOKEN
    _firebaseMessaging.getToken().then((deviceToken) {
      print("=================DEVICEEE TOKENNN: $deviceToken");
    });

    String fcmToken = await _firebaseMessaging.getToken();
    FirebaseUser mahasiswa = await _auth.currentUser();

    // SEND TOKEN TO FIRESTORE

    if (fcmToken != null){
      // var tokenRef = _db
      //     .collection('mahasiswa')
      //     .document(mahasiswa.uid);
      var tokenRef = _db
          .collection('mahasiswa')
          .document(mahasiswa.uid)
          .collection('deviceTokensPelanggan')
          .document(fcmToken);
      await tokenRef.setData({
        'token' : fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  _configureFirebaseListeners() {
    var orderBloc = Provider.of<OrderBloc>(context, listen: false); //i
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('==============onMessage: $message');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(content: ListTile(
            title: Text(message['notification']['title']),
            subtitle: Text(message['notification']['body']),
          ),
            actions: <Widget>[
              FlatButton(
                onPressed:() => Navigator.of(context).pop(),
                // onPressed: () => orderBloc.updateOrder(context: context),
                child: Text('OK'),
              )
            ],
          )
        );
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('==============onLaunch: $message');
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('==============onResumee: $message');
        _setMessage(message);
      },
    );
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    final String mMessage = data['message'];
    setState(() {
      Message m = Message(title, body, mMessage);
      _messages.add(m);
    });
  }




  @override
  void initState() {
    super.initState();
    _messages = List<Message>();
    _getToken();
    _configureFirebaseListeners();

  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return SafeArea(
      child: appState.initialPosition == null
          ? Container(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitRotatingCircle(
                      color: Colors.black,
                      size: 50.0,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: appState.locationServiceActive == false,
                  child: Text(
                    "Please enable location services!",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                )
              ],
            ))
          : Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: appState.initialPosition, zoom: 10.0),
                  onMapCreated: appState.onCreated,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  markers: appState.markers,
                  onCameraMove: appState.onCameraMove,
                  polylines: appState.polyLines,
                ),

                Positioned(
                  top: 50.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: appState.locationController,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "Lokasi sekarang",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),

                // Positioned(
                //   top: 105.0,
                //   right: 15.0,
                //   left: 15.0,
                //   child: Container(
                //     height: 50.0,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(3.0),
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(
                //             color: Colors.grey,
                //             offset: Offset(1.0, 5.0),
                //             blurRadius: 10,
                //             spreadRadius: 3)
                //       ],
                //     ),
                //     child: TextField(
                //       cursorColor: Colors.black,
                //       controller: appState.destinationController,
                //       textInputAction: TextInputAction.go,
                //       onSubmitted: (value) {
                //         appState.sendRequest(value);
                //       },
                //       decoration: InputDecoration(
                //         icon: Container(
                //           margin: EdgeInsets.only(left: 20, top: 5),
                //           width: 10,
                //           height: 10,
                //           child: Icon(
                //             Icons.local_taxi,
                //             color: Colors.black,
                //           ),
                //         ),
                //         hintText: "destination?",
                //         border: InputBorder.none,
                //         contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                //       ),
                //     ),
                //   ),
                // ),

//        Positioned(
//          top: 40,
//          right: 10,
//          child: FloatingActionButton(onPressed: _onAddMarkerPressed,
//          tooltip: "aadd marker",
//          backgroundColor: black,
//          child: Icon(Icons.add_location, color: white,),
//          ),
//        )
              ],
            ),
    );
  }
}

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}
