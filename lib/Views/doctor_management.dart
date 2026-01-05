
import 'dart:io';

import 'package:care_lab_software/Views/doctor_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:path_provider/path_provider.dart';

import '../Helpers/uiHelper.dart';
import 'loginscreen.dart';


class DoctorData {
  // Load doctors from assets file
  static Future<List<String>> loadDoctorsFromAssets() async {
    try {
      // Load the file from assets
      final String response = await rootBundle.loadString('assets/doctors.txt');

      // Split by lines and filter empty lines
      final List<String> doctors = response
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim())
          .toList();

      return doctors;
    } catch (e) {
      print('Error loading doctors: $e');
      return [];
    }
  }

  // Alternative: Load and search doctors
  static Future<List<String>> searchDoctors(String query) async {
    final doctors = await loadDoctorsFromAssets();

    if (query.isEmpty) {
      return doctors;
    }

    return doctors
        .where((doctor) =>
        doctor.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}


class DoctorManagement extends StatefulWidget {
  const DoctorManagement({super.key});

  @override
  State<DoctorManagement> createState() => _DoctorManagementState();
}

class _DoctorManagementState extends State<DoctorManagement> {

  List<String> doctors = [];
  List<String> filteredDoctors = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    setState(() => isLoading = true);

    final loadedDoctors = await DoctorData.loadDoctorsFromAssets();

    setState(() {
      doctors = loadedDoctors;
      filteredDoctors = loadedDoctors;
      isLoading = false;
    });
  }

  void filterDoctors(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDoctors = doctors;
      } else {
        filteredDoctors = doctors
            .where((doctor) =>
            doctor.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if(accessCode != "/doctor_list_management"){

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LabLoginScreen()), (val)=>true);

    }

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Device.width < 1100 ?

      Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            //SIDE BAR
            Container(
              height: 180,
              child: UiHelper.custHorixontalTab(container: "5",context: context),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Doctor List Management"),

                    const SizedBox(height: 20,),

                    PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search doctors...',
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: filterDoctors,
                        ),
                      ),
                    ),

                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : filteredDoctors.isEmpty
                        ? Center(
                      child: Text(
                        'No doctors found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(filteredDoctors[index]),
                          onTap: () {
                            // Handle doctor selection
                            print('Selected: ${filteredDoctors[index]}');
                          },
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      )

          :
      Center(
        child: Row(
          children: [
            //SIDE BAR
            Container(
              width: Adaptive.w(15),
              child: UiHelper.custsidebar(container: "5",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Doctor List Management",widget: ElevatedButton(onPressed: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorManagementScreen()));
                    }, child: UiHelper.CustText(text: "Add New Doctor"))),

                    const SizedBox(height: 20,),

                    PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search doctors...',
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: filterDoctors,
                        ),
                      ),
                    ),


                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : filteredDoctors.isEmpty
                        ? Center(
                      child: Text(
                        'No doctors found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      // itemCount: filteredDoctors.length,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(filteredDoctors[index]),
                          onTap: () {
                            // Handle doctor selection
                            print('Selected: ${filteredDoctors[index]}');
                          },
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//ADD AND DELETE

