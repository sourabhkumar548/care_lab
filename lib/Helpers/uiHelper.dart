import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';
import 'package:pdf/widgets.dart' as pw;

class UiHelper{

  static Widget custsidebar({
    required String container,
    required BuildContext context,
  }) {
    return Container(
      width: Adaptive.w(15),
      color: Colors.blue.shade500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              "Care Diagnostics Centre",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontFamily: 'font-bold',
              ),
            ),
          ),
          const Divider(color: Colors.white24),

          // Dashboard
          Container(
            color: container == '1' ? Colors.green.shade300 : Colors.transparent,
            child: sidebarItem(Icons.dashboard, "Dashboard", "/"),
          ),

          // Case Entry
          Container(
            color: container == '2' ? Colors.green.shade300 : Colors.transparent,
            child: sidebarItem(Icons.person_add, "Case Entry", "/case_entry_page"),
          ),

          // Case Entry List
          Container(
            color: container == '3' ? Colors.green.shade300 : Colors.transparent,
            child: sidebarItem(Icons.list_alt, "Case Entry List", "/case_entry_list"),
          ),

          // Reporting
          Container(
            color: container == '4' ? Colors.green.shade300 : Colors.transparent,
            child: sidebarItem(Icons.search, "Reporting", "/reporting_page"),
          ),

          const Divider(color: Colors.white24),

          // Management with Subcategories
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            child: ExpansionTile(
              collapsedIconColor: Colors.white,
              iconColor: Colors.white,
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text("Management", style: TextStyle(color: Colors.white)),
              childrenPadding: const EdgeInsets.only(left: 30),
              children: [
                Container(
                  color: container == '5' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Doctor Management", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/doctor_list_management');
                    },
                  ),
                ),
                Container(
                  color: container == '6' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Agent Management", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/agent_list_management');
                    },
                  ),
                ),
                Container(
                  color: container == '7' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Staff Management", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/staff_list_management');
                    },
                  ),
                ),
                Container(
                  color: container == '8' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Rate List Management", style: TextStyle(color: Colors.white)),
                    onTap: () {
                        Get.toNamed('/rate_list_management');
                    },
                  ),
                ),
              ],
            ),
          ),

          // Accounts
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            child: ExpansionTile(
              collapsedIconColor: Colors.white,
              iconColor: Colors.white,
              leading: const Icon(Icons.account_balance_wallet, color: Colors.white),
              title: const Text("Accounts", style: TextStyle(color: Colors.white)),
              childrenPadding: const EdgeInsets.only(left: 30),
              children: [
                Container(
                  color: container == '9' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Doctor Collection", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/doctor_collection');
                    },
                  ),
                ),
                Container(
                  color: container == '10' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Agent Collection", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/agent_collection');
                    },
                  ),
                ),
                Container(
                  color: container == '11' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Staff Collection", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/');
                    },
                  ),
                ),
                Container(
                  color: container == '12' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Collection By Date", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/collection_between_date');
                    },
                  ),
                ),
                Container(
                  color: container == '13' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Monthly Collection", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/');
                    },
                  ),
                ),
                Container(
                  color: container == '14' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Yearly Collection", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/');
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: container == '15' ? Colors.green.shade300 : Colors.transparent,
            child: sidebarItem(Icons.money, "Daily Expenses", "/"),
          ),

          const Spacer(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text("Logout", style: TextStyle(color: Colors.white)),
            onTap: () async{

              bool? status = await UiHelper.showYesNoDialog(context, "Confirm", "are you confirm to logout ? ");

              if(status == true){
                GetStorage userBox = GetStorage();
                userBox.remove('newUser');
                Navigator.pushNamedAndRemoveUntil(context, '/login_page',(route) => false );
              }



            },
          ),
        ],
      ),
    );
  }



  static Widget sidebarItem(IconData icon, String title,String routename) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Get.toNamed(routename);
      },
    );
  }

  static Widget Custcard({
    required String title,
    Widget? trailing,
    required Widget child,
    double? width,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
                const Spacer(),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  static Widget CustTextField({required TextEditingController controller,required String label,Icon? icon,bool? enabled,bool? obscureText,Widget? suffixWidget}){

    return Expanded(
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText ?? false,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black45, width: 1.5),
          ),
          fillColor: Colors.grey.shade100,
          labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 11.sp),
          prefixIcon: icon ?? Icon(Icons.confirmation_number_outlined),
          suffixIcon: suffixWidget ?? Icon(Icons.error_outline,)
        ),
      ),
    );
  }

  static Widget CustDropDown({required String label,required String defaultValue,required List<DropdownMenuItem<String>> list,Icon? icon,required Function(String?) onChanged,}){
    return Expanded(
      child: DropdownButtonFormField(
        style: TextStyle(color: Colors.black),
        decoration:  InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black45, width: 1.5),
          ),
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 11.sp),
          prefixIcon: icon ?? Icon(Icons.local_hospital_outlined),
        ),
        items: list,
        onChanged: onChanged,
        value: defaultValue,
      ),
    );
  }

  static Widget infoCard(String title, String value, Color color, IconData icon) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  static Widget CustTopBar({required String title,Widget? widget}){
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.local_hospital, size: 32, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Text(title,
                  style: TextStyle(fontSize: 20,fontFamily: 'font-bold')),
            ],
          ),
          widget ?? Container()
        ],
      ),
    );
  }

  static CustEditableDropDown(BuildContext context, Function(String) onSelected,List<String> data) {
    List<String> list = [];

    DropDownState<String>(
      dropDown: DropDown<String>(
        data: data.map((city) => SelectedListItem<String>(data: city)).toList(),
        onSelected: (selectedItems) {
          for (var item in selectedItems) {
            list.add(item.data);
          }
          onSelected(list[0].toString()); // return data via callback
        },
      ),
    ).showModal(context);
  }

  static showErrorToste({required String message,String? heading}){
    return toastification.show(
      title: Text(heading ?? "Error Occurred",style: TextStyle(fontFamily: 'font-bold',fontSize: 12.sp),),
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 5),
      description: RichText(text: TextSpan(text: message)),
      alignment: Alignment.center,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
    );
  }
  static showSuccessToste({required String message,String? heading}){
    return toastification.show(
      title: Text(heading ?? "Success",style: TextStyle(fontFamily: 'font-bold',fontSize: 12.sp),),
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 5),
      description: RichText(text: TextSpan(text: message)),
      alignment: Alignment.center,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
    );
  }

  static pw.Widget PWcustomTextWithRow({required String text,
    Color? color,
    double? size,
    String? fontfamily,
    pw.FontWeight? fontweight,
    pw.MainAxisAlignment? mainaxisalignment,
    int? maxline}) {
    return pw.Row(
      mainAxisAlignment: mainaxisalignment ?? pw.MainAxisAlignment.start,
      children: [
        pw.Text(
          text,
          maxLines: maxline,
          style: pw.TextStyle(
            fontSize: size ?? 10.sp,
            letterSpacing: .6,
          ),
        ),
      ],
    );
  }

  static pw.Widget PWcustomText({required String text,
    Color? color,
    double? size,
    String? fontfamily,
    pw.FontWeight? fontweight,
    int? maxline}) {
    return pw.Text(
      text,
      maxLines: maxline,
      style: pw.TextStyle(
        fontSize: size ?? 10.sp,
        fontWeight: fontweight ?? pw.FontWeight.bold,
        letterSpacing: .6,
      ),
    );
  }

  static Widget CustText({required String text,
    Color? color,
    double? size,
    String? fontfamily,
    FontWeight? fontweight,
    int? maxline}) {
    return Text(
      text,
      maxLines: maxline,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: size ?? 10.sp,
        fontFamily: fontfamily ?? 'font-regular',
        fontWeight: fontweight ?? FontWeight.bold,
        letterSpacing: .6,
      ),
    );
  }

  static Future<bool?> showYesNoDialog(BuildContext context, String title, String message) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: UiHelper.CustText(text: title,size: 10.5.sp),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text("Yes"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }



}