import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:congorna/src/blocs/auth_bloc.dart';
import 'package:congorna/src/blocs/jasa_bloc.dart';
import 'package:congorna/src/models/jasa.dart';
import 'package:congorna/src/widgets/attribute.dart';
import 'package:congorna/src/widgets/card.dart';
import 'package:congorna/src/widgets/sliver_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:congorna/src/widgets/appstate.dart';

class ChooseJasa extends StatefulWidget {
  @override
  _ChooseJasaState createState() => _ChooseJasaState();
}

final ordersScaffoldKey = GlobalKey<ScaffoldState>();

class _ChooseJasaState extends State<ChooseJasa> {
  @override
  void initState() {
    var jasaBloc = Provider.of<JasaBloc>(context, listen: false); //inst
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Map());
  }
}

class Map extends StatefulWidget {
  final String jasaId;

  Map({this.jasaId});
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    var jasaBloc = Provider.of<JasaBloc>(context);

    var authBloc = Provider.of<AuthBloc>(context);

    return FutureBuilder<Jasa>(builder: (context, snapshot) {
      if (!snapshot.hasData && widget.jasaId != null) {
        return Scaffold(
          body: Center(
              child: (Platform.isIOS)
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator()),
        );
      }

      Jasa existingJasa;

      if (widget.jasaId != null) {
        //Edit Logic
        existingJasa = snapshot.data;
        loadValues(jasaBloc, existingJasa, authBloc.mahasiswaId);
      }

      return (Platform.isIOS)
          ? AppSliverScaffold.cupertinoSliverScaffold(
              navTitle: '',
              pageBody: pageBody(true, jasaBloc, context, existingJasa),
              context: context)
          : AppSliverScaffold.materialSliverScaffold(
              navTitle: '',
              pageBody: pageBody(false, jasaBloc, context, existingJasa),
              context: context);
    });
  }

  Widget pageBody(
      bool isIOS, JasaBloc jasaBloc, BuildContext context, Jasa existingJasa) {
    print("EXISTING JASA");
    print(existingJasa);
    final appState = Provider.of<AppState>(context);
    var items = Provider.of<List<String>>(context);

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
                        hintText: "pick up",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 105.0,
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
                      controller: appState.destinationController,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        appState.sendRequest(value);
                      },
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.local_taxi,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "destination?",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 24.0,
                  right: 24.0,
                  left: 24.0,
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
                      child: Column(
                        children: [
                          Text(
                            'Rp.1000.00',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'price/hr',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                StreamBuilder<String>(
                                    stream: jasaBloc.jasaName,
                                    builder: (context, snapshot) {
                                      return AppCard(
                                        jasaName: (existingJasa != null)
                                            ? existingJasa.jasaName
                                            : null,
                                        jasaHarga: (existingJasa != null)
                                            ? existingJasa.jasaHarga
                                            : null,
                                        jasaServices: (existingJasa != null)
                                            ? existingJasa.jasaServices
                                            : null,
                                        jasaTimes: (existingJasa != null)
                                            ? existingJasa.jasaTimes
                                            : null,
                                        jasaImage: (existingJasa != null)
                                            ? existingJasa.jasaImage
                                            : null,
                                      );
                                    }),
                              ])
                        ],
                      )),
                ),
              ],
            ),
    );
  }
}

loadValues(JasaBloc jasaBloc, Jasa jasa, String vendorId) {
  // jasaBloc.changeJasa(jasa);
  jasaBloc.changeVendorId(vendorId);
  if (jasa != null) {
    //EDIT FORM
    jasaBloc.changeJasaTimes(jasa.jasaTimes);
    jasaBloc.changeJasaName(jasa.jasaName);
    jasaBloc.changeJasaHarga(jasa.jasaHarga.toString());
    jasaBloc.changeJasaServices(jasa.jasaServices);
    jasaBloc.changeJasaImage(jasa.jasaImage ?? '');
  } else {
    //ADD FORM
    jasaBloc.changeJasaTimes(null);
    jasaBloc.changeJasaName(null);
    jasaBloc.changeJasaServices(null);
    jasaBloc.changeJasaHarga(null);
    jasaBloc.changeJasaImage('');
  }
}
