//create a static function to show snackbar
import 'package:flutter/material.dart';

class Utils {
  //color is optional parameter (it can be null)
  static void showSnackBar(String message, BuildContext context, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text (message), 
      backgroundColor: color,
    ));
  }
}