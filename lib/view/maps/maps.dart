import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:practice_chatapp/modal/infowindow.dart';
import 'package:practice_chatapp/services/database.dart';
import 'package:practice_chatapp/view/profile/userInfo.dart';
import 'package:practice_chatapp/widgets/mainAppNavigator.dart';
import 'package:practice_chatapp/widgets/sharedpreferences.dart';
import 'package:provider/provider.dart';

import '../profile/userInfo.dart';

class Maps extends StatefulWidget {
  // final String userEmail;
  // Maps(this.userEmail);
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController mapController;
  bool mapToggle = false;
  Map<MarkerId, Marker> markers = new Map<MarkerId, Marker>();
  QuerySnapshot userInfoSnapShot;
  List<LatLng> routeCoords = [];
  Set<Polyline> polyline = {};
  PolylinePoints polylinePoints = PolylinePoints();
  //GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey:"AIzaSyDan1Q_T5_GtzEeQNIo6Fkab9IPyONq5fQ");
  //GeoPoint myCurrentPosition;
  //String userEmail = "";
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  @override
  void initState() {
    getUserSnapShot();
    getMarkerData();
    //getUserEmail();
    // dataBaseMethods.getUserByUserEmail(userEmail).then((value) {
    //   if (value != null) {
    //     setState(() {
    //       userInfoSnapShot = value;
    //       myCurrentPosition = userInfoSnapShot.documents[0].data["location"];
    //       print("$userInfoSnapShot + in maps");
    //       getMarkers(myCurrentPosition.latitude, myCurrentPosition.longitude);
    //       mapToggle = true;
    //     });
    //   }
    // });
    // getMarkers(myCurrentPosition.latitude, myCurrentPosition.longitude);
    // setState(() {
    //   mapToggle = true;
    // });
    super.initState();
  }

  getUserSnapShot() async {
    String userEmail = await SharedPreFerences.getUserEmailSharedPreference();
    //print("$userEmail");
    dataBaseMethods.getUserByUserEmail(userEmail).then((value) {
      if (value != null) {
        setState(() {
          userInfoSnapShot = value;
          // userInfoSnapShot.documents[0].data["location"] = GeoPoint(
          //     userInfo.myCurrentLocation.latitude,
          //     userInfo.myCurrentLocation.longitude);
          Geolocator.getCurrentPosition().then((value) {
            userInfoSnapShot.documents[0].data["location"] =
                GeoPoint(value.latitude, value.longitude);
          });
          userInfo.myCurrentLocation =
              userInfoSnapShot.documents[0].data["location"];

          getMarkers(userInfo.myCurrentLocation.latitude,
              userInfo.myCurrentLocation.longitude);

          mapToggle = true;
        });
      }
    });
  }
  //function to get user email
  // getUserEmail() async {
  //   userEmail = await SharedPreFerences.getUserEmailSharedPreference();
  // }

  //function to get Markers

  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );
    setState(() {
      markers[markerId] = _marker;
    });
  }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height - 175,
//                 child: mapToggle
//                     ? GoogleMap(
//                         onMapCreated: onMapCreated,
//                         initialCameraPosition: CameraPosition(
//                             target: LatLng(
//                               userInfo.myCurrentLocation.latitude,
//                               userInfo.myCurrentLocation.longitude,
//                             ),
//                             zoom: 15),
//                         markers: Set<Marker>.of(markers.values),
//                       )
//                     : Center(
//                         child: Text(
//                             'Loading .. plz w8 ${SharedPreFerences.getUserEmailSharedPreference().toString()}'),
//                       ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

// //function is used to intialised controller when Google is created
//   void onMapCreated(controller) {
//     setState(() {
//       mapController = controller;
//     });
//   }
//

//fuction to add polylines between user and someone he/she taps on
  Future<void> getUserDirection() async {}

//function to fetch marker data
  void initMarker(specify, specifyId) async {
    var markerIdval = specifyId;
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
        // onTap: () {
        //   setState(() {
        //     setPolylines(specify);
        //   });
        // },
        markerId: markerId,
        position:
            LatLng(specify["location"].latitude, specify["location"].longitude),
        infoWindow: InfoWindow(
          title: userInfo.myName == specify["name"] ? "me" : specify["name"],
          snippet: specify["email"],
        ));
    setState(() {
      markers[markerId] = marker;
      setPolylines(specify);
    });
  }

//function to get all markers
  getMarkerData() async {
    Firestore.instance.collection("users").getDocuments().then((value) {
      if (value.documents.isNotEmpty) {
        for (int i = 0; i < value.documents.length; i++) {
          initMarker(value.documents[i].data, value.documents[i].documentID);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //final providerObject = Provider.of<InfoWindowModel>(context, listen: false);
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            myLocationEnabled: true,
            onMapCreated: onMapCreated,
            polylines: polyline,
            markers: Set<Marker>.of(markers.values),
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(
                  userInfo.myCurrentLocation.latitude,
                  userInfo.myCurrentLocation.longitude,
                ),
                zoom: 20),
          ),
        ),
      ],
    ));
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  //fuction to set polyline

  void setPolylines(specify) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDan1Q_T5_GtzEeQNIo6Fkab9IPyONq5fQ",
      PointLatLng(userInfo.myCurrentLocation.latitude,
          userInfo.myCurrentLocation.latitude),
      PointLatLng(specify["location"].latitude, specify["location"].longitude),
    );
    if (result.status == 'OK') {
      result.points.forEach((point) {
        routeCoords.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      polyline.add(
        Polyline(
            polylineId: PolylineId(userInfo.myName + "_" + specify["name"]),
            color: Colors.green,
            points: routeCoords),
      );
    });
  }
}

// class MsgDirectionButton extends StatelessWidget {
//   final String uid;
//   MsgDirectionButton({this.uid});
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedPositioned(
//       top: 100,
//       left: 0,
//       right: 0,
//       child: Container(
//         child: (Row(
//           children: [
//             Container(
//               width: 100,
//               height: 40,
//               decoration: BoxDecoration(
//                   color: Colors.blue, borderRadius: BorderRadius.circular(40)),
//               child: Text("Message"),
//             ),
//             Container(
//               width: 100,
//               height: 40,
//               decoration: BoxDecoration(
//                   color: Colors.blue, borderRadius: BorderRadius.circular(40)),
//               child: Text("Directions"),
//             ),
//           ],
//         )),
//       ),
//     );
//   }
// }
