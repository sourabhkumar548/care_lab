import 'package:care_lab_software/Service/urls.dart';
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
import 'package:http/http.dart' as http;

class UiHelper{



  static Widget custHorixontalTab({
    required String container,
    required BuildContext context,
}){
    GlobalKey managementKey = GlobalKey();
    GlobalKey accountKey = GlobalKey();

    return Container(

      color: Colors.blue.shade500,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Center(child: UiHelper.CustText(text: "Care Diagnostics Centre",size: 18.sp,color: Colors.white)),
          Divider(color: Colors.blue.shade900,),
          GridView(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10,),
            children: [
              InkWell(
                onTap: ()=>Get.toNamed('/dashboard',arguments: {"code" : "/dashboard"}),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  color: container == "1" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(children: [
                    Icon(Icons.dashboard,color: Colors.white,size: 25,),
                    const SizedBox(height: 5,),
                    UiHelper.CustText(text: "Dashboard",size: 12.sp,color: Colors.white)
                  ],),
                ),
              ),
              InkWell(
                onTap: ()=>Get.toNamed('/case_entry_page',arguments: {"code" : "/case_entry_page"}),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  color: container == "2" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(children: [
                    Icon(Icons.person_add,color: Colors.white,size: 25,),
                    const SizedBox(height: 5,),
                    UiHelper.CustText(text: "Case Entry",size: 12.sp,color: Colors.white)
                  ],),
                ),
              ),
              InkWell(
                onTap: ()=>Get.toNamed('/case_entry_list',arguments: {"code" : "/case_entry_list"}),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  color: container == "3" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(children: [
                    Icon(Icons.list_alt,color: Colors.white,size: 25,),
                    const SizedBox(height: 5,),
                    UiHelper.CustText(text: "Case List",size: 12.sp,color: Colors.white)
                  ],),
                ),
              ),
              InkWell(
                onTap: ()=>Get.toNamed('/reporting_page',arguments: {"code" : "/reporting_page"}),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  color: container == "4" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(children: [
                    Icon(Icons.search,color: Colors.white,size: 25,),
                    const SizedBox(height: 5,),
                    UiHelper.CustText(text: "Reporting",size: 12.sp,color: Colors.white)
                  ],),
                ),
              ),

              InkWell(
                onTap: ()=>Get.toNamed('/upload_report',arguments: {"code" : "/upload_report"}),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  color: container == "20" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(children: [
                    Icon(Icons.upload,color: Colors.white,size: 25,),
                    const SizedBox(height: 5,),
                    UiHelper.CustText(text: "Upload Report",size: 12.sp,color: Colors.white)
                  ],),
                ),
              ),
              InkWell(
                onTap: ()=>Get.toNamed('/search_report',arguments: {"code" : "/search_report"}),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  color: container == "22" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(children: [
                    Icon(Icons.search,color: Colors.white,size: 25,),
                    const SizedBox(height: 5,),
                    UiHelper.CustText(text: "Search Report",size: 12.sp,color: Colors.white)
                  ],),
                ),
              ),

              //MANAGEMENT
              InkWell(
                onTap: () {
                  final RenderBox renderBox =
                  managementKey.currentContext!.findRenderObject() as RenderBox;

                  final position = renderBox.localToGlobal(Offset.zero);
                  final size = renderBox.size;

                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      60, // 👉 bottom of widget
                      position.dx + size.width,
                      0,
                    ),
                    items: [
                      PopupMenuItem(value: "doctor", child: Text("Doctor Management")),
                      PopupMenuItem(value: "agent", child: Text("Agent Management")),
                      PopupMenuItem(value: "staff", child: Text("Staff Management")),
                      PopupMenuItem(value: "rate", child: Text("Rate List Management")),
                    ],
                  ).then((value) {
                    if (value != null){
                      if(value == "doctor"){
                        Get.toNamed('/doctor_list_management',arguments: {"code" : "/doctor_list_management"});
                      }
                      if(value == "agent"){
                        Get.toNamed('/agent_list_management',arguments: {"code" : "/agent_list_management"});
                      }
                      if(value == "staff"){
                        Get.toNamed('/staff_list_management',arguments: {"code" : "/staff_list_management"});
                      }
                      if(value == "rate"){
                        Get.toNamed('/rate_list_management',arguments: {"code" : "/rate_list_management"});
                      }
                    }
                  });
                },

                child: Container(
                  key: managementKey,
                  padding: EdgeInsets.only(top: 5),
                  color: container == "5" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(
                    children: [
                      Icon(Icons.settings, color: Colors.white, size: 25),
                      const SizedBox(height: 5),
                      UiHelper.CustText(
                        text: "Management",
                        size: 12.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              //ACCOUNT
              InkWell(
                onTap: () {
                  final RenderBox renderBox =
                  accountKey.currentContext!.findRenderObject() as RenderBox;

                  final position = renderBox.localToGlobal(Offset.zero);
                  final size = renderBox.size;

                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      60, // 👉 bottom of widget
                      position.dx + size.width,
                      0,
                    ),
                    items: [
                      PopupMenuItem(value: "doctor", child: Text("Doctor Collection")),
                      PopupMenuItem(value: "agent", child: Text("Agent Collection")),
                      PopupMenuItem(value: "date", child: Text("Collection By Date")),
                    ],
                  ).then((value) {
                    if (value != null){
                      if(value == "doctor"){
                        Get.toNamed('/doctor_collection',arguments: {"code" : "/doctor_collection"});
                      }
                      if(value == "agent"){
                        Get.toNamed('/agent_collection',arguments: {"code" : "/agent_collection"});
                      }
                      if(value == "date"){
                        Get.toNamed('/collection_between_date',arguments: {"code" : "/collection_between_date"});
                      }

                    }
                  });
                },

                child: Container(
                  key: accountKey,
                  padding: EdgeInsets.only(top: 5),
                  color: container == "6" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.white, size: 25),
                      const SizedBox(height: 5),
                      UiHelper.CustText(
                        text: "Accounts",
                        size: 12.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              //DAILY EXPENSE
              InkWell(
                onTap: ()=>Get.toNamed('/expanses',arguments: {"code" :"/expanses"}),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  color: container == "7" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(children: [
                    Icon(Icons.money,color: Colors.white,size: 25,),
                    const SizedBox(height: 5,),
                    UiHelper.CustText(text: "Daily Expense",size: 12.sp,color: Colors.white)
                  ],),
                ),
              ),

              InkWell(
                onTap: ()async{
                  final response = await http.get(Uri.parse("${Urls.BackupDb}"));
                  if(response.statusCode == 200) {
                    UiHelper.showSuccessToste(message: "DB Backup Successfully");
                  }
                  else{
                    UiHelper.showErrorToste(message: "DB Backup Failed");
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  color: container == "21" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(children: [
                    Icon(Icons.backup,color: Colors.white,size: 25,),
                    const SizedBox(height: 5,),
                    UiHelper.CustText(text: "Backup",size: 12.sp,color: Colors.white)
                  ],),
                ),
              ),

              //LOGOUT
              InkWell(
                onTap: ()async{
                  bool? status = await UiHelper.showYesNoDialog(context, "Confirm", "are you confirm to logout ? ");

                  if(status == true){
                    GetStorage userBox = GetStorage();
                    userBox.remove('newUser');
                    Navigator.pushNamedAndRemoveUntil(context, '/login_page',(route) => false );
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  color: container == "8" ? Colors.green.shade300 : Colors.transparent,
                  child: Column(children: [
                    Icon(Icons.logout,color: Colors.white,size: 25,),
                    const SizedBox(height: 5,),
                    UiHelper.CustText(text: "Logout",size: 12.sp,color: Colors.white)
                  ],),
                ),
              ),



            ],),
        ],
      ),
    );
  }

  static Widget custsidebar({
    required String container,
    required BuildContext context,
  }) {
    return Container(
      width: Adaptive.w(15),
      height: Adaptive.h(100),
      color: Colors.blue.shade500,
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Text("Care Diagnostics Centre",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Device.width < 1100 ? 15.sp :13.sp,
                  fontFamily: 'font-bold',
                ),
              ),
            ),
          ),
          const Divider(color: Colors.white24),

          // Dashboard
          Container(
            color: container == '1' ? Colors.green.shade300 : Colors.transparent,
            child: sidebarItem(Icons.dashboard, "Dashboard", "/dashboard"),
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

          Container(
            color: container == '4' ? Colors.green.shade300 : Colors.transparent,
            child: sidebarItem(Icons.event_repeat_outlined, "Reporting", "/reporting_page"),

          ),

          // Reporting
          Container(
            color: container == '20' ? Colors.green.shade300 : Colors.transparent,
            child: sidebarItem(Icons.upload, "Upload Report", "/upload_report"),

          ),

          Container(
            color: container == '22' ? Colors.green.shade300 : Colors.transparent,
            child: sidebarItem(Icons.search, "Search Report", "/search_report"),

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
              leading: Tooltip(
                  message: "Management",
                  child: const Icon(Icons.settings, color: Colors.white)),
              title: Tooltip(
                  message: "Management",
                  child: Text("Management", style: TextStyle(color: Colors.white))),
              childrenPadding: const EdgeInsets.only(left: 30),
              children: [
                Container(
                  color: container == '5' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Doctor Management", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/doctor_list_management',arguments: {"code" : "/doctor_list_management"});
                    },
                  ),
                ),
                Container(
                  color: container == '6' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Agent Management", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/agent_list_management',arguments: {"code" : "/agent_list_management"});
                    },
                  ),
                ),
                Container(
                  color: container == '7' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Staff Management", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/staff_list_management',arguments: {"code" : "/staff_list_management"});
                    },
                  ),
                ),
                Container(
                  color: container == '8' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Rate List Management", style: TextStyle(color: Colors.white)),
                    onTap: () {
                        Get.toNamed('/rate_list_management',arguments: {"code" : "/rate_list_management"});
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
              leading: Tooltip(
                  message: "Accounts",
                  child: const Icon(Icons.account_balance_wallet, color: Colors.white)),
              title: Tooltip(
                  message: "Accounts",
                  child: Text("Accounts", style: TextStyle(color: Colors.white))),
              childrenPadding: const EdgeInsets.only(left: 20),
              children: [
                Container(
                  color: container == '9' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Doctor Collection", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/doctor_collection',arguments: {"code" : "/doctor_collection"});
                    },
                  ),
                ),
                Container(
                  color: container == '10' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Agent Collection", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/agent_collection',arguments: {"code" : "/agent_collection"});
                    },
                  ),
                ),
                Container(
                  color: container == '12' ? Colors.green.shade300 : Colors.transparent,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined,color: Colors.black,),
                    title: const Text("Collection By Date", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Get.toNamed('/collection_between_date',arguments: {"code" : "/collection_between_date"});
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: container == '15' ? Colors.green.shade300 : Colors.transparent,
            child: sidebarItem(Icons.money, "Daily Expenses", "/expanses"),
          ),

          Container(
            color: container == '21' ? Colors.green.shade300 : Colors.transparent,
            child: ListTile(
              leading: Icon(Icons.backup, color: Colors.white),
              title: Text("DB Backup", style: const TextStyle(color: Colors.white)),
              onTap: ()async{
                final response = await http.get(Uri.parse("${Urls.BackupDb}"));
                if(response.statusCode == 200) {
                  UiHelper.showSuccessToste(message: "DB Backup Successfully");
                }
                else{
                  UiHelper.showErrorToste(message: "DB Backup Failed");
                }
              },
            ),
          ),

          const Divider(color: Colors.white24),


          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: Text("Logout", style: TextStyle(color: Colors.white)),
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



  static Widget sidebarItem(IconData icon, String title,String routename,) {
    return Tooltip(
      message: title,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () {
          Get.toNamed(routename,arguments: {"code" : routename});
        },
      ),
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
            borderSide: BorderSide(color: Colors.red, width: 2),
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
            borderSide: BorderSide(color: Colors.red, width: 2),
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
              Image.asset("assets/images/logo.png",height: 80,width: 80,),
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
            fontWeight: pw.FontWeight.bold
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