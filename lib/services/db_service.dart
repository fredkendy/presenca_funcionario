import 'dart:math';
import 'package:employee_attendance/constants/constants.dart';
import 'package:employee_attendance/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//extends subce we will it use as a Provider
class DbService extends ChangeNotifier {
  //instance of supabase client
  final SupabaseClient _supabase = Supabase.instance.client;

  //it can be null
  UserModel? userModel;

  //function to create a random id for employee_id
  String generateRandomEmployeeId() {
    //creates a 8 digit random ID from these Chars
    final random = Random();
    const allChars = "FLUTTERCOMPANY0123456789";
    final randomString = List.generate(8, (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString;
  }

  //function to insert new user data (var id is the auth id)
  //called while registering a new user
  Future insertNewUser(String email, var id) async {
    await _supabase.from(Constants.employeeTable).insert({
      'id': id,
      'name': '',
      'email': email,
      'employee_id': generateRandomEmployeeId(),
      'department': null,
    });
  }

  //it will return a user model
  Future<UserModel> getUserData() async {
    //query to go to employee table and get data which equals the id in supabase. single because you now that cannot be more than one employee with the same id
    final userData = await _supabase
      .from(Constants.employeeTable)
      .select()
      .eq('id', _supabase.auth.currentUser!.id) //! because it cannot be null
      .single(); 
    userModel = UserModel.fromJSON(userData); //changing data that comes as json to UserModel
    return userModel!; //not null
  }
}