//to save the values that we get from sharedpreferences functions

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class userInfo {
  static String myName = "";
  static GeoPoint myCurrentLocation;
  static String myuId;
  static String myInterest;
}
