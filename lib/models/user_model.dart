class UserModel {
  //the same as created in supabase
  final String id;
  final String email;
  final String name;
  final int? department; //we'll have another table for department (this will be the foreign key to primary key)
  final String employeeId; 

//constructor
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.department,  //it can be null
    required this.employeeId,
  });

  //factory method to convert JSON data coming from supabase
  factory UserModel.fromJSON(Map<String,dynamic> data) {
    return UserModel(
      id: data['id'], 
      email: data['email'], 
      name: data['name'], 
      department: data['department'],
      employeeId: data['employee_id']
    );
  }
}