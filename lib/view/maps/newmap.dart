import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:practice_chatapp/services/auth.dart';
import 'package:practice_chatapp/services/authenticate.dart';
import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';

class NewMap extends StatefulWidget {
  @override
  _NewMapState createState() => _NewMapState();
}

class _NewMapState extends State<NewMap> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0, 0));
  GoogleMapController mapcontroller;
  TextEditingController startAddressController = TextEditingController();
  Position currentPosition;
  Position startPosition;
  Map<MarkerId, Marker> markers = new Map<MarkerId, Marker>();
  PolylinePoints polylinePoints;
  List<LatLng> polyLineCoordinates = [];
  AuthMethods _authMethods = new AuthMethods();

  Map<PolylineId, Polyline> polylines = {};
  //Method to retrieving the current location of user

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        currentPosition = position;
        print('Current Pos: $currentPosition');
        mapcontroller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 18.0)));
      });
    }).catchError((e) {
      print(e);
    });
  }

  //function to retrive all markers
  getMarkers() async {
    DataBaseMethods().getUsersByInterest(userInfo.myInterest).then((value) {
      if (value.documents.isNotEmpty) {
        for (int i = 0; i < value.documents.length; i++)
          if (userInfo.myInterest == value.documents[i].data["interest"]) {
            initMarker(value.documents[i].data, value.documents[i].documentID);
          }
      }
    });
  }

  //create polylines for showing route between 2 places

  //function to retrive one marker
  initMarker(userMap, userId) async {
    final MarkerId markerId = MarkerId(userId);
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(userMap["location"].latitude, userMap["location"].longitude),
        infoWindow: InfoWindow(
          title: userInfo.myName == userMap["name"] ? "me" : userMap["name"],
          snippet: userMap["email"],
        ));
    setState(() {
      markers[markerId] = marker;
    });
  }

  //fuction to get polylines between all marker
  // getPolyLines() async {
  //   await Firestore.instance.collection("users").getDocuments().then((value) {
  //     if (value.documents.isNotEmpty) {
  //       for (int i = 0; i < value.documents.length; i++)
  //         createPolylines(
  //             PointLatLng(currentPosition.latitude, currentPosition.longitude),
  //             PointLatLng(value.documents[i].data["location"].latitude,
  //                 value.documents[i].data["location"].longitude));
  //     }
  //   });
  // }

  // createPloylines(
  //   Position start,
  //   //Position destination
  // ) async {
  //   polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       "AIzaSyDan1Q_T5_GtzEeQNIo6Fkab9IPyONq5fQ",
  //       PointLatLng(start.latitude, start.longitude),
  //       //PointLatLng(destination.latitude, destination.longitude),
  //       PointLatLng(37.432, -122.122),
  //       travelMode: TravelMode.transit);
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }

  //   PolylineId id = PolylineId('${start.latitude} +');

  //   Polyline polyline = Polyline(
  //       polylineId: id,
  //       color: Colors.red,
  //       points: polyLineCoordinates,
  //       width: 3);

  //   setState(() {
  //     polylines[id] = polyline;
  //   });
  // }

  @override
  void initState() {
    getCurrentLocation();
    getMarkers();
    //createPloylines(currentPosition);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
        backgroundColor: Colors.purpleAccent,
        actions: [
          GestureDetector(
            onTap: () {
              _authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 160,
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _initialLocation,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                polylines: Set<Polyline>.of(polylines.values),
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (GoogleMapController controller) {
                  mapcontroller = controller;
                },
              ),
              ClipOval(
                child: Material(
                  color: Colors.orange,
                  child: InkWell(
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.my_location,
                      ),
                    ),
                    onTap: () {
                      mapcontroller.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(
                              currentPosition.latitude,
                              currentPosition.longitude,
                            ),
                            zoom: 18.0)),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
