import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

// Example Widget using the doctor list
class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<String> doctors = [];
  List<String> filteredDoctors = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
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
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredDoctors.isEmpty
          ? Center(
        child: Text(
          'No doctors found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
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
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
