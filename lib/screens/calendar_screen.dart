import 'package:employee_attendance/services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {

    final attendanceService = Provider.of<AttendanceService>(context);

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20, top: 60, bottom: 10),
          child: const Text(
            "My Attendance",
            style: TextStyle(fontSize: 25),
            ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //show current month and button to select a month
            Text(
              attendanceService.attendanceHistoryMonth, 
              style: const TextStyle(fontSize: 25),
              ),
              OutlinedButton(onPressed: () async {
                //show months (no future months)
                final selectedDate = await SimpleMonthYearPicker.showMonthYearPickerDialog(context: context, disableFuture: true);
                String pickedMonth = DateFormat('MMMM yyyy').format(selectedDate);
                //In the attendance service, it will send the value to the set, which will notify the listener (rebuild screen)
                attendanceService.attendanceHistoryMonth = pickedMonth;
              }, 
              child: const Text("Pick a month"))
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: attendanceService.getAttendanceHistory(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  //OUTPUT WIDGET
                } else {
                  return const Center(
                    child: Text(
                      "No Data Available",
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                }
              }
              return const LinearProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.grey,
              );
            }),
          ),
      ],
    );
  }
}