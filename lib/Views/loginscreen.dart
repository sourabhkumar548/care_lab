import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/LoginScreenCtrl/Controller/loginCtrl.dart';
import '../Controllers/LoginScreenCtrl/LoginBloc/login_bloc.dart';
import '../Controllers/LoginScreenCtrl/UsernameCubit/username_cubit.dart';
import '../Helpers/uiHelper.dart';

class LabLoginScreen extends StatefulWidget {
  LabLoginScreen({super.key});

  @override
  State<LabLoginScreen> createState() => _LabLoginScreenState();
}

class _LabLoginScreenState extends State<LabLoginScreen> {

  TextEditingController passwordController = TextEditingController();

  var username = "None".obs;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Check if screen width is large (tablet/desktop)
            bool isWide = constraints.maxWidth > 700;

            if (isWide) {
              // --- Desktop/Tablet Layout: Two Columns ---
              return Row(
                children: [
                  // LEFT COLUMN (Lab Machines)
                  Expanded(child: _buildMachinesSection()),

                  // RIGHT COLUMN (Login Form)
                  Expanded(child: _buildLoginForm(context)),
                ],
              );
            }
            else {
              // --- Mobile Layout: One Column (Stacked) ---
              return SingleChildScrollView(
                child: _buildLoginForm(context),
              );
            }
          },
        ),
      ),
    );
  }

  /// LEFT SIDE: Machines Section
  /// LEFT SIDE: Full-Size Machines Image
  Widget _buildMachinesSection() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_pic.jpg"), // your full-size image
          fit: BoxFit.cover, // covers the full space
        ),
      ),
      child: Container(
        color: Colors.black.withValues(alpha: 0.3), // optional overlay for text visibility
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png",height: 150,width: 150,),
            const SizedBox(height: 10),
            Text(
              "Care Diagnostic Centre",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Naya Bazar, Near Gaya Pul, Dhanbad (826001)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// RIGHT SIDE: Login Form
  Widget _buildLoginForm(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            Image.asset("assets/images/logo.png",height: 150,width: 150,),
            const SizedBox(height: 20),

            // Title
            Text(
              "Care Diagnostic Centre",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Login to manage your reports",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 40),

            // Email

            BlocBuilder<UsernameCubit, UsernameState>(
              builder: (context, state) {
                if(state is UsernameLoadingState){
                  return Center(child: CircularProgressIndicator());
                }
                if(state is UsernameErrorState){
                  return Text(state.error);
                }
                if(state is UsernameLoadedState){
                  List<DropdownMenuItem<String>> staffList = [
                    const DropdownMenuItem(value: "None", child: Text("None")),
                    ...state.usernameModel.username!.map((val)=>DropdownMenuItem(value: val, child: Text(val))).toList()
                  ];
                  return Row(children: [
                    UiHelper.CustDropDown(label: "Select User", defaultValue: "None", list: staffList,icon: Icon(Icons.person),
                        onChanged: (val){
                          username.value = val!;
                        }
                    )
                  ],);
                }
                return Container();
              },
            ),


            const SizedBox(height: 16),
            // Password
            Row(
              children: [
                UiHelper.CustTextField(controller: passwordController, label: "Enter Password",obscureText: true,icon: Icon(Icons.password)),
              ],
            ),

            const SizedBox(height: 35),

            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if(state is LoginErrorState){
                    UiHelper.showErrorToste(message: state.error, heading: "Error");
                  }
                  if(state is LoginLoadedState){
                    GetStorage userBox = GetStorage();
                    userBox.write("newUser", username.value);
                    Get.toNamed('/dashboard',arguments: {"code" : "/dashboard"});
                  }
                },
                builder: (context, state) {
                  if(state is LoginLoadingState){
                    return Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: ()=>LoginCtrl.Login(username: username.value, password: passwordController.text, context: context),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade700, Colors.blue.shade400],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),

            ),

          ],
        ),
      ),
    );
  }
}





