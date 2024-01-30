import 'package:employee_attendance/models/department.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);
    //if it has not been initialized, call to initialize
    //if page is loaded for 1st time, insert name controller (input by user) to user  
    dbService.allDepartments.isEmpty ? dbService.getAllDepartments() : null;

    nameController.text.isEmpty 
      ? nameController.text = dbService.userModel?.name ?? '' 
      : null;

    return Scaffold(
      body: dbService.userModel == null ? const Center(
        child: CircularProgressIndicator(),
      ) : Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 80),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Text("Employee ID: ${dbService.userModel?.employeeId}"),
              const SizedBox(height: 30,),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text("Full name"),
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 15,),

              //DROPDOWN MENU
              dbService.allDepartments.isEmpty ? const LinearProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder()
                      ),
                      //if employee dept is null, use first id of dept
                      value: dbService.employeeDepartment ?? dbService.allDepartments.first.id,
                      items: dbService.allDepartments.map((DepartmentModel item) {
                        return DropdownMenuItem(
                          value: item.id,
                          child: Text(
                            item.title,
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                      onChanged: (selectedValue) {
                        //change the employee department
                        dbService.employeeDepartment = selectedValue;
                      },
                    ),
                ),
                const SizedBox(height: 40,),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      //Calling function with the text inside the input as parameter
                      //Don't need to send dept ID as param because it is changed on onChange above
                      dbService.updateProfile(nameController.text.trim(), context);
                    },
                    child: const Text("Update Profile", style: TextStyle(fontSize: 20),),
                  ),
                )
            ],
          ),
        ),
      )
    );
  }
}
