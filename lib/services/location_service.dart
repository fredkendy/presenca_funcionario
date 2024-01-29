import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

//Code also available on pub.dev documentation

class LocationService {
  Location location = Location();
  late LocationData _locData;

  //return a map of string/double (latitude/longitude) and it can be null
  Future<Map<String, double?>?> initializeAndGetLocation(BuildContext context) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    //Check if location is enabled in the device
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Utils.showSnackBar("Please enable Location Service", context);
        return null; //other code won't be executed
      }
    }

    //Ask permission for location if service is enabled
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Utils.showSnackBar("Please allow Location Access", context);
        return null;
      }
    }

    //Return the coordinates
    _locData = await location.getLocation();
    return {
      'latitude': _locData.latitude,
      'longitude': _locData.longitude
    };
  }
}