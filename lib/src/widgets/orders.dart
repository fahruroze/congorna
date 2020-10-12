
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congorna/src/blocs/order_bloc.dart';
import 'package:congorna/src/models/M_Orders.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ndialog/ndialog.dart';
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

  Dio dio=new Dio();
  ModelOrders modelOrders;


  showAlertDialog({BuildContext context,String idOrder}) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () =>Navigator.pop(context),
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.pop(context);
        ubahStatus(context: context,idOrder: idOrder);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Pesan"),
      content: Text("Apakah anda Yakin ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> ubahStatus({BuildContext context,String idOrder})async{
      dio=new Dio();
      print(idOrder);
      ProgressDialog progressDialog=new ProgressDialog(context,title: Text("Loading.."));
      progressDialog.show();
      Response response=await dio.post("http://101.50.0.106:9090/update_status",data: {
        "order_id" : "$idOrder",
        "status" : "Sudah Selesai"
      });

      print(response.data);
      if(response.statusCode==200){
        progressDialog.dismiss();

        getOrders().then((value) {
          setState(() {
            modelOrders=value;
          });
        });
      }

    return true;
  }
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

  Future<ModelOrders> getOrders()async{
    dio=new Dio();
    Response response;
    response=await dio.get("http://101.50.0.106:9090/get_order");

    print(response.data);
    return ModelOrders.fromJson(response.data);
  }



  @override
  void initState() {
    super.initState();
    _messages = List<Message>();
    _getToken();
    _configureFirebaseListeners();
    getOrders().then((value) {
      setState(() {
        modelOrders=value;
      });
    });

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
          : modelOrders==null ? Center(
        child: CircularProgressIndicator() ,
      ): modelOrders.totalData==null ? Center(child: Text("Tidak ada Orders"),) :
      ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10),
          itemCount: modelOrders.data.length,
          itemBuilder: (c,i){
            return Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(modelOrders.data[i].idOrder,style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),

                            ],
                          ),
                        ),
                        Container()
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Nama Jasa",style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
                              Text(modelOrders.data[i].jasaName.toString(),style: GoogleFonts.poppins(),),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Harga Jasa",style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
                              Text(modelOrders.data[i].jasaHarga.toString(),style: GoogleFonts.poppins(),),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tanggal Order",style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
                              Text(DateFormat("EEEE, dd-M-yyyy").format(modelOrders.data[i].jasaTimes),style: GoogleFonts.poppins(),),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Status",style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
                              Text(modelOrders.data[i].status.toString(),style: GoogleFonts.poppins(),),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    FlatButton(onPressed: (){
                      showAlertDialog(context: context,idOrder: modelOrders.data[i].idOrder);
                    }, child: Text("Order Sudah diterima ?"))
                  ],
                ),
              ),
            );
          }),

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
