import 'package:employee_attendance/constants/constants.dart';
import 'package:employee_attendance/models/attendance_model.dart';
import 'package:employee_attendance/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  AttendanceModel? attendanceModel;

  String todayDate = DateFormat("dd MMMM yyyy").format(DateTime.now());

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Variable to hold the month to get/check history 
  //At beginning, it will be only that month only, then can change later
  String _attendanceHistoryMonth = DateFormat('MMMM yyyyy').format(DateTime.now());

  String get attendanceHistoryMonth => _attendanceHistoryMonth;

  set attendanceHistoryMonth(String value) {
    _attendanceHistoryMonth = value;
    notifyListeners();
  }

  Future getTodayAttendance() async {
    final List result = await _supabase
        .from(Constants.attendanceTable)
        .select()
        .eq("employee_id",
            _supabase.auth.currentUser!.id) //2 params: column and value
        .eq("date", todayDate); //particularly date and employee will be one

    //check whether employee has checked in for today.
    if (result.isNotEmpty) {
      attendanceModel = AttendanceModel.fromJSON(result.first); //only one
    }
    notifyListeners();
  }

  Future markAttendance(BuildContext context) async {
    //check whether employee has checked in for today. if not, insert a new data for that date, if yes, update data with the checkout time only (because already checked)
    if (attendanceModel?.checkIn == null) {
      await _supabase.from(Constants.attendanceTable).insert({
        'employee_id': _supabase.auth.currentUser!.id,
        'date': todayDate,
        'check_in': DateFormat('HH:mm').format(DateTime.now()),
      });
    } else if (attendanceModel?.checkOut == null) {
      await _supabase.from(Constants.attendanceTable).update({
        'check_out': DateFormat('HH:mm').format(DateTime.now()),
      }).eq('employee_id', _supabase.auth.currentUser!.id).eq('date', todayDate); //make sure we are updating that particular data only
    } else {
      Utils.showSnackBar("You have already checked out today", context);
    }
    //get latest data and update ui
    getTodayAttendance();
  }

  //Checks the date column for the search (list of AttendanceModel)
  Future<List<AttendanceModel>> getAttendanceHistory() async {
    final List data = await _supabase
      .from(Constants.attendanceTable)
      .select()
      .eq('employee_id', _supabase.auth.currentUser!.id)
      //check date column and check all rows which equals to that month
      .textSearch('date', "'$attendanceHistoryMonth'", config: 'english')
      .order('created_at', ascending: false);

      //map each attendance and convert in a list
      return data.map((attendance) => AttendanceModel.fromJSON(attendance)).toList();
  }

}
