class AttendanceModel {
  final String id;
  final String date;
  final String checkIn;
  final String? checkOut;
  final DateTime createdAt;
  final Map? checkInLocation;
  final Map? checkOutLocation;

  //constructor
  AttendanceModel({
    required this.id,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.createdAt,
    required this.checkInLocation,
    required this.checkOutLocation
  });

  factory AttendanceModel.fromJSON(Map<String, dynamic> data) {
    return AttendanceModel(
      id: data['employee_id'], 
      date: data['date'], 
      checkIn: data['check_in'], 
      checkOut: data['check_out'], 
      createdAt: DateTime.parse(data['created_at']), //supabase come as string
      checkInLocation: data['check_in_location'],
      checkOutLocation: data['check_out_location']
    );
  }
}
