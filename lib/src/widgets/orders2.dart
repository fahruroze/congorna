import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:kumbahapp/src/widgets/orders2.dart';
import 'package:location/location.dart';
import 'package:congorna/src/components/orders/map_pin_pill.dart';
import 'package:congorna/src/models/pin_pill_info.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class Orders extends StatefulWidget {
  Orders({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  // final Set<Marker> _marker = {};
  // final LatLng _currentPosition = LatLng(-6.3464528, 108.2998994);

  // StreamSubscription _locationSubscription;
  // Location _locationTracker = Location();
  // Marker marker;
  // Circle circle;
  // GoogleMapController _controller;

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();

  //ROUTE on the map
  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  // PolylinePoints polylinePoints = PolylinePoints();
  // String googleAPIKey = '<AIzaSyANsaZMplx4fu_344CfHZepqnFwbJDj-UU>';
  String googleAPIKey = '<AIzaSyCzYzyGAR3mvDJeIRquMhAJ71AbhfS8_zg>';

//MARKER custom
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  //LOKASI AWAL user & TUJUAN user
  LocationData currentLocation;
  LocationData destinationLocation;

  //WRAPPER around LOKASI API
  Location location;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
    pinPath: '',
    avatarPath: '',
    location: LatLng(0, 0),
    locationName: '',
    labelColor: Colors.grey,
  );

  PinInformation sourcePinInfo;
  PinInformation destinationPinInfo;

  // static final CameraPosition initialLocation = CameraPosition(
  //   target: LatLng(-6.3464528, 108.2998994),
  //   zoom: 15,
  // );

  @override
  void initState() {
    super.initState();
    location = new Location();
    polylinePoints = PolylinePoints();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap();
    });

    setSourceAndDestinationIcons();

    setInitialLocation();
  }

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0), 'assets/driving_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'assets/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        // "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=${Constants.anotherApiKey}";
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=AIzaSyANsaZMplx4fu_344CfHZepqnFwbJDj-UU";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    values.toString();
    // ProjectLog.logIt(TAG, "Predictions", values.toString());
    var coro = values["routes"][0]["overview_polyline"]["points"];
    print(coro);
    return values["routes"][0]["overview_polyline"]["points"];
  } // Return random string

  void setInitialLocation() async {
    //set LOKASI AWAL dari function getLokasi()

    currentLocation = await location.getLocation();

    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      target: SOURCE_LOCATION,
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
    );
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }

    // return MaterialApp();
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(),
      );
    } else {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              mapType: MapType.normal,
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              onTap: (LatLng loc) {
                pinPillPosition = -100;
              },
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(Utils.mapStyles);
                _controller.complete(controller);

                //KETIKA map sudah dibuat tampilkan PIN MAP
                showPinsOnMap();
              },
            ),
            MapPinPillComponent(
              pinPillPosition: pinPillPosition,
              currentlySelectedPin: currentlySelectedPin,
            )
          ],
        ),
      );
    }
  }

  void showPinsOnMap() {
    //GET Latitude Longitude dari CurrentLocation untuk menampilkan letak awal PIN
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    //GET Latitude Longitude dari destinationLocation untuk menampilkan letak TUJUAN PIN
    var destPosition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);

    sourcePinInfo = PinInformation(
      locationName: "Start Location",
      location: SOURCE_LOCATION,
      pinPath: "assets/driving_pin.png",
      avatarPath: "assets/friend1.jpg",
      labelColor: Colors.blueAccent,
    );

    destinationPinInfo = PinInformation(
      locationName: "End Location",
      location: SOURCE_LOCATION,
      pinPath: "assets/driving_pin.png",
      avatarPath: "assets/friend1.jpg",
      labelColor: Colors.purple,
    );

    //SOURCE PIN
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon));

    //DESTINATION pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo;
            pinPillPosition = 0;
          });
        },
        icon: destinationIcon));
  }

  // void setPolylines() async {
  //   List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
  //     // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     googleAPIKey,
  //     currentLocation.latitude,
  //     currentLocation.longitude,
  //     destinationLocation.latitude,
  //     destinationLocation.longitude,
  //   );

  //   if (result.isNotEmpty) {
  //     result.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });

  //     setState(() {
  //       // _polylines.add(Polyline(
  //       //     width: 2,
  //       //     polylineId: PolylineId("poly"),
  //       //     color: Color.fromARGB(255, 40, 122, 198),
  //       //     points: polylineCoordinates));

  //       _polylines.add(Polyline(
  //           polylineId: PolylineId("poly"),
  //           // Constants.currentRoutePolylineId), //pass any string here
  //           width: 3,
  //           geodesic: true,
  //           points: Utils.convertToLatLng(Utils.decodePoly(encodedPoly)),
  //           color: Colors.blue));
  //     });
  //   }
  // }

  // setState(() {
  //       // _polylines.add(Polyline(
  //       //     width: 2,
  //       //     polylineId: PolylineId("poly"),
  //       //     color: Color.fromARGB(255, 40, 122, 198),
  //       //     points: polylineCoordinates));

  //       _polylines.add(Polyline(
  //           polylineId: PolylineId(
  //                "poly"),
  //               // Constants.currentRoutePolylineId), //pass any string here
  //           width: 3,
  //           geodesic: true,
  //           points: Utils.convertToLatLng(Utils.decodePoly(encodedPoly)),
  //           color: ConstantColors.PrimaryColor));
  //     });

  void updatePinOnMap() async {
    //NEW Cameraposition
    CameraPosition cPosition = CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      //UPDATE position
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      sourcePinInfo.location = pinPosition;

      // the trick is to remove the marker (by id)
      // and add it again at the updated location

      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition,
          icon: sourceIcon));
    });
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';

// DECODE POLY
  static List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negative then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  static List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }
}

Widget pageBody() {
  return Center(
    child: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(-6.3464528, 108.2998994),
        zoom: 17,
      ),
    ),
  );
}
