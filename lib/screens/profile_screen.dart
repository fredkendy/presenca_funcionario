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
  int selectedValue = 0;

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
              )
            ],
          ),
        ),
      )
    );
  }
}
