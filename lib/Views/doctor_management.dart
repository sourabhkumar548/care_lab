import 'dart:io';

import 'package:care_lab_software/Controllers/DoctorCtrl/cibit/doctor_cubit.dart';
import 'package:care_lab_software/Views/doctor_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:path_provider/path_provider.dart';

import '../Controllers/DoctorCtrl/cibit/delete_doctor_cubit.dart';
import '../Helpers/add_agent_doctor.dart';
import '../Helpers/uiHelper.dart';
import 'loginscreen.dart';

class DoctorManagement extends StatefulWidget {
  const DoctorManagement({super.key});

  @override
  State<DoctorManagement> createState() => _DoctorManagementState();
}

class _DoctorManagementState extends State<DoctorManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    context.read<DoctorCubit>().GetDoctor();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _currentPage = 0; // Reset to first page on search
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if (accessCode != "/doctor_list_management") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LabLoginScreen()),
              (val) => true);
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Device.width < 1100
          ? Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            //SIDE BAR
            Container(
              height: 180,
              child: UiHelper.custHorixontalTab(
                  container: "5", context: context),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Doctor List Management"),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    getDoctor()
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          : Center(
        child: Row(
          children: [
            //SIDE BAR
            Container(
              width: Adaptive.w(15),
              child: UiHelper.custsidebar(
                  container: "5", context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(
                        title: "Doctor List Management",
                        widget: ElevatedButton(
                            onPressed: () {
                              addDoctor(context: context);
                            },
                            child: UiHelper.CustText(
                                text: "Add New Doctor"))),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    getDoctor()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search doctors by name...',
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
    );
  }

  Widget getDoctor() {
    return BlocBuilder<DoctorCubit, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is DoctorErrorState) {
          return Center(child: UiHelper.CustText(text: state.errorMsg));
        }
        if (state is DoctorLoadedState) {
          // Filter doctors based on search query
          final filteredDoctors = state.doctorModel.doctor!.where((doctor) {
            return doctor.doctorName!.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredDoctors.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: UiHelper.CustText(
                  text: _searchQuery.isEmpty
                      ? 'No doctors found'
                      : 'No doctors match your search',
                  size: 12.sp,
                ),
              ),
            );
          }

          // Calculate pagination
          final totalPages = (filteredDoctors.length / _itemsPerPage).ceil();
          final startIndex = _currentPage * _itemsPerPage;
          final endIndex = (startIndex + _itemsPerPage > filteredDoctors.length)
              ? filteredDoctors.length
              : startIndex + _itemsPerPage;
          final paginatedDoctors = filteredDoctors.sublist(startIndex, endIndex);

          return Column(
            children: [
              // Doctor List
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final doctor = paginatedDoctors[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade200,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: UiHelper.CustText(
                        text: doctor.doctorName!,
                        size: 11.sp,
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 28,
                        ),
                        onPressed: () {
                          _showDeleteConfirmation(context, doctor.doctorName!,doctor.id!);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: paginatedDoctors.length,
                ),
              ),
              const SizedBox(height: 20),

              // Pagination Controls
              if (totalPages > 1) _buildPaginationControls(totalPages, filteredDoctors.length),
            ],
          );
        }

        return Container();
      },
    );
  }

  Widget _buildPaginationControls(int totalPages, int totalItems) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page info
          UiHelper.CustText(
            text: 'Showing ${_currentPage * _itemsPerPage + 1}-${(_currentPage + 1) * _itemsPerPage > totalItems ? totalItems : (_currentPage + 1) * _itemsPerPage} of $totalItems',
            size: 10.sp,
          ),

          // Navigation buttons
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage = 0)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: UiHelper.CustText(
                  text: 'Page ${_currentPage + 1} of $totalPages',
                  size: 10.sp,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPage < totalPages - 1
                    ? () => setState(() => _currentPage++)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: _currentPage < totalPages - 1
                    ? () => setState(() => _currentPage = totalPages - 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String doctorName,int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete Dr. $doctorName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            BlocConsumer<DeleteDoctorCubit, DeleteDoctorState>(
              listener: (context, state) {
                if(state is DeleteDoctorErrorState){
                  UiHelper.showErrorToste(message: state.errorMsg);
                }
                if(state is DeleteDoctorLoadedState){
                  context.read<DoctorCubit>().GetDoctor();
                  UiHelper.showSuccessToste(message: state.message);
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                if(state is DeleteDoctorLoadingState){
                  return Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: () {
                    context.read<DeleteDoctorCubit>().deleteDoctor(id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                );
              },
            ),
          ],
        );
      },
    );
  }
}