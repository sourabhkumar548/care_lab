import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/DoctorCtrl/cibit/doctor_cubit.dart';
import '../Model/doctor_model.dart';

// Import your cubit and model
// import 'package:your_app/bloc/doctor_cubit.dart';
// import 'package:your_app/model/doctor_model.dart';

// ============================================
// DOCTOR INPUT FIELD WIDGET WITH BLOC
// ============================================
class DoctorInputField extends StatefulWidget {
  final Function(Doctor)? onDoctorSelected;
  final String? initialValue;
  final TextEditingController? controller;

  const DoctorInputField({
    Key? key,
    this.onDoctorSelected,
    this.initialValue,
    this.controller,
  }) : super(key: key);

  @override
  _DoctorInputFieldState createState() => _DoctorInputFieldState();
}

class _DoctorInputFieldState extends State<DoctorInputField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  List<Doctor> allDoctors = [];
  List<Doctor> filteredDoctors = [];
  OverlayEntry? _overlayEntry;
  Doctor? _lastValidSelection;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null && _controller.text.isEmpty) {
      _controller.text = widget.initialValue!;
    }

    // Load doctors from API using Cubit
    context.read<DoctorCubit>().GetDoctor();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showDropdown();
      } else {
        Future.delayed(Duration(milliseconds: 200), () {
          _hideDropdown();
          _validateSelection();
        });
      }
    });
  }

  void _validateSelection() {
    final currentText = _controller.text.trim();

    if (currentText.isEmpty) return;

    final isValid = allDoctors.any((doctor) =>
    doctor.doctorName?.toLowerCase() == currentText.toLowerCase());

    if (!isValid) {
      // Revert to last valid selection
      _controller.text = _lastValidSelection?.doctorName ?? '';
      if (mounted && currentText.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a doctor from the list'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors = allDoctors.take(50).toList();
    } else {
      filteredDoctors = allDoctors.where((doctor) {
        final name = doctor.doctorName?.toLowerCase() ?? '';
        final post = doctor.post?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) || post.contains(searchQuery);
      }).take(50).toList();
    }

    if (filteredDoctors.isNotEmpty && _focusNode.hasFocus) {
      _showDropdown();
    } else {
      _hideDropdown();
    }

    if (mounted) setState(() {});
  }

  void _showDropdown() {
    _hideDropdown();

    if (filteredDoctors.isEmpty && _controller.text.isEmpty) {
      filteredDoctors = allDoctors.take(50).toList();
    }

    if (filteredDoctors.isEmpty || !mounted) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return OverlayEntry(builder: (_) => SizedBox.shrink());
    }

    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: BoxConstraints(maxHeight: 250),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: filteredDoctors.isEmpty
                ? Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No matching doctors found',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: filteredDoctors.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    doctor.doctorName ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: doctor.post != null
                      ? Text(
                    doctor.post!,
                    style: TextStyle(fontSize: 12),
                  )
                      : null,
                  onTap: () {
                    _controller.text = doctor.doctorName ?? '';
                    _lastValidSelection = doctor;
                    widget.onDoctorSelected?.call(doctor);
                    _hideDropdown();
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _clearText() {
    _controller.clear();
    _lastValidSelection = null;
    _filterDoctors('');
    if (widget.onDoctorSelected != null) {
      // Create empty doctor to notify clearing
      widget.onDoctorSelected?.call(Doctor());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      listener: (context, state) {
        if (state is DoctorErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMsg),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  context.read<DoctorCubit>().GetDoctor();
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        // Update doctor list when loaded
        if (state is DoctorLoadedState) {
          allDoctors = state.doctorModel.doctor ?? [];
          if (_controller.text.isEmpty) {
            filteredDoctors = allDoctors.take(50).toList();
          }
        }

        final isLoading = state is DoctorLoadingState;
        final hasError = state is DoctorErrorState;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(color: Colors.black),
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: "Enter Doctor Name",
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black45, width: 1.5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                      fillColor: isLoading ? Colors.grey.shade200 : Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: 'font-bold',
                        fontSize: 11.sp,
                      ),
                      prefixIcon: isLoading
                          ? Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                          : Icon(Icons.person),
                      suffixIcon: _controller.text.isNotEmpty && !isLoading
                          ? IconButton(
                        icon: Icon(Icons.close, size: 20),
                        onPressed: _clearText,
                      )
                          : null,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterDoctors,
                  ),
                ),
                if (hasError && !isLoading)
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.red),
                    onPressed: () {
                      context.read<DoctorCubit>().GetDoctor();
                    },
                    tooltip: 'Retry loading doctors',
                  ),
              ],
            ),
            if (hasError && !isLoading)
              Padding(
                padding: EdgeInsets.only(top: 8, left: 12),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      'Failed to load doctors',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        context.read<DoctorCubit>().GetDoctor();
                      },
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (state is DoctorLoadedState && allDoctors.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  '${allDoctors.length} doctors available',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _hideDropdown();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }
}