//All methods related to authentication
import 'package:employee_attendance/services/db_service.dart';
import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//extends since we will be using Provider
class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DbService _dbService = DbService(); 

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
      final AuthResponse response = 
        await _supabase.auth.signUp(email: email, password: password);
        if (response != null) {
          await _dbService.insertNewUser(email, response.user!.id);
          Utils.showSnackBar("Successfully registered!", context, color: Colors.green);
          //since we have email, password and context, login in sequence (user dont have to enter credentials after register)
          await loginEmployee(email, password, context);
          Navigator.pop(context);
        }
      
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