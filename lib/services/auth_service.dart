//All methods related to authentication
import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//extends since we will be using Provider
class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  //private variable for isLoading and then create getter and setter, so users outside this class can't access directly
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    _isLoading = value;
    //anyone listening to this service will refresh
    notifyListeners();
  }

  Future registerEmployee(String email, String password, BuildContext context) async {
    try {
      setIsLoading = true;
      if (email == "" || password == "") {
        throw ("All fields are required");
      }
      final AuthResponse response = await _supabase.auth.signUp(email: email, password: password);
      Utils.showSnackBar("Success! You can now login", context, color: Colors.green);
      Navigator.pop(context);
      setIsLoading = false;
    } catch(e) {
      setIsLoading = false;
      Utils.showSnackBar(e.toString(), context, color: Colors.red);
    }
  }

  Future loginEmployee(String email, String password, BuildContext context) async {
    try {
      setIsLoading = true;
      if (email == "" || password == "") {
        throw ("All fields are required");
      }
      final AuthResponse response =
          await _supabase.auth.signInWithPassword(email: email, password: password);
      setIsLoading = false;
    } catch (e) {
      setIsLoading = false;
      Utils.showSnackBar(e.toString(), context, color: Colors.red);
    }
  }

  Future signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  //get the current user from supabase
  User? get currentUser => _supabase.auth.currentUser;
}