//import 'dart:html';
//import 'dart:js';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:congorna/src/widgets/locationpath.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:congorna/src/services/google_maps_request.dart';
import 'package:location/location.dart' as locData;

class AppState with ChangeNotifier {
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  bool locationServiceActive = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;
  Marker markerCar;
  Circle circleCar;
  locData.Location _locationTracker = locData.Location();

  AppState() {
    getUserLocation();
    loadingInitialPosition();
  }

// SET GAMBAR CAR
  Future<Uint8List> getMarker(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

// ! TO GET THE USERS LOCATION
  Future<String> getUserLocation() async {
    print("GET USER METHOD RUNNING =========");
    print("GET USER METHOD RUNNING COBA");

    //Position position = await Geolocator()
    //    .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //List<Placemark> placemark = await Geolocator()
    //    .placemarkFromCoordinates(position.latitude, position.longitude);
    var location = await _locationTracker.getLocation();
    _initialPosition = LatLng(location.latitude, location.longitude);
    try {
      Uint8List imageData = await getMarker('assets/car_icon.png', 65);
      _addMarkerCar(location, imageData);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Unauthorization");
      }
    }

    print(
        "the latitude is: ${location.latitude} and th longitude is: ${location.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    var coba = _initialPosition.toString();
    //locationController.text = placemark[0].name;
    // notifyListeners();
    print(coba);

    notifyListeners();
    return coba;
  }

  Future<void> getPelangganLocation() async {
    print("GET USER METHOD RUNNING =========");
    print("GET USER METHOD RUNNING PELANGGAN");

    //Position position = await Geolocator()
    //    .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //List<Placemark> placemark = await Geolocator()
    //    .placemarkFromCoordinates(position.latitude, position.longitude);
    var location = await _locationTracker.getLocation();
    _initialPosition = LatLng(location.latitude, location.longitude);

    print(
        "the latitude is: ${location.latitude} and th longitude is: ${location.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    var coba = _initialPosition.toString();
    //locationController.text = placemark[0].name;
    // notifyListeners();
    print(coba);
    return coba;
  }

  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black));
    notifyListeners();
  }

  // ! ADD A MARKER ON THE MAO
  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  // ADD A MARKER CAR
  void _addMarkerCar(locData.LocationData locationData, Uint8List imageData) {
    LatLng latlng = LatLng(locationData.latitude, locationData.longitude);
    markerCar = Marker(
        markerId: MarkerId("home"),
        position: latlng,
        rotation: locationData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData));
    circleCar = Circle(
        circleId: CircleId("car"),
        radius: locationData.accuracy,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latlng,
        fillColor: Colors.blue.withAlpha(70));
    notifyListeners();
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
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
      /* if value is negetive then bitwise not the value */
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

  // ! SEND REQUEST
  void sendRequest(String intendedLocation) async {
    //parameter lat lng
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        initialPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

//  LOADING INITIAL POSITION
  void loadingInitialPosition() async {
    await Future.delayed(Duration(seconds: 5)).then((v) {
      if (initialPosition == null) {
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }
}
