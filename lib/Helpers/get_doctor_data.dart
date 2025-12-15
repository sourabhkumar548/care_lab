import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

// ============================================
// DOCTOR DATA LOADER
// ============================================
class DoctorData {
  static Future<List<String>> loadDoctorsFromAssets() async {
    try {
      final String response = await rootBundle.loadString('assets/doctors.txt');

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
}

// ============================================
// DOCTOR INPUT FIELD WIDGET
// ============================================
class DoctorInputField extends StatefulWidget {
  final Function(String)? onDoctorSelected;
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
  List<String> allDoctors = [];
  List<String> filteredDoctors = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null && _controller.text.isEmpty) {
      _controller.text = widget.initialValue!;
    }
    loadDoctors();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showDropdown();
      } else {
        Future.delayed(Duration(milliseconds: 200), () {
          _hideDropdown();
        });
      }
    });
  }

  Future<void> loadDoctors() async {
    allDoctors = await DoctorData.loadDoctorsFromAssets();
    if (mounted) setState(() {});
  }

  void _filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors = allDoctors.take(50).toList();
    } else {
      filteredDoctors = allDoctors
          .where((doctor) =>
          doctor.toLowerCase().contains(query.toLowerCase()))
          .take(50)
          .toList();
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
    if (renderBox == null) return OverlayEntry(builder: (_) => SizedBox.shrink());

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
            constraints: BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: filteredDoctors.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  title: Text(
                    filteredDoctors[index],
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    _controller.text = filteredDoctors[index];
                    widget.onDoctorSelected?.call(filteredDoctors[index]);
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
    _filterDoctors('');
    widget.onDoctorSelected?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: TextStyle(color: Colors.black),
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
              fillColor: Colors.grey.shade100,
              labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 11.sp),
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            onChanged: _filterDoctors,
          ),
        ),

        if (_controller.text.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _clearText,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.grey.shade600,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
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

// ============================================
// USAGE EXAMPLE
// ============================================
// Use this in your NewCaseEntry widget:
//
// Expanded(
//   child: DoctorInputField(
//     controller: doctorCtrl,
//     initialValue: "Self",
//     onDoctorSelected: (doctor) {
//       setState(() {
//         doctorCtrl.text = doctor;
//       });
//     },
//   ),
// ),