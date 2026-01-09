import 'package:care_lab_software/Controllers/AgentCtrl/cubit/add_agent_cubit.dart';
import 'package:care_lab_software/Controllers/AgentCtrl/cubit/agent_cubit.dart';
import 'package:care_lab_software/Controllers/DoctorCtrl/cibit/add_doctor_cubit.dart';
import 'package:care_lab_software/Controllers/DoctorCtrl/cibit/doctor_cubit.dart';
import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

void addDoctor({required BuildContext context}) {
  final TextEditingController _controller = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title:  UiHelper.CustText(text: "Add Doctor",fontweight: FontWeight.bold,size: 13.sp),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: _controller,
            decoration:  InputDecoration(
              hintText: "Enter doctor name...",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          BlocConsumer<AddDoctorCubit, AddDoctorState>(
            listener: (context, state) {
              if(state is AddDoctorErrorState){
                UiHelper.showErrorToste(message: state.errorMsg);
              }
              if(state is AddDoctorLoadedState){
                context.read<DoctorCubit>().GetDoctor();
                UiHelper.showSuccessToste(message: state.sussessMsg);
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if(state is AddDoctorLoadingState){
                return Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                onPressed: () {
                  String value = _controller.text;
                  print(value);
                  context.read<AddDoctorCubit>().addDoc(doctorName: value);
                },
                child: const Text("Add Doctor"),
              );
            },
          )

        ],
      );
    },
  );
}

void addAgent({required BuildContext context}) {
  final TextEditingController _controller = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title:  UiHelper.CustText(text: "Add Agent",fontweight: FontWeight.bold,size: 13.sp),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: _controller,
            decoration:  InputDecoration(
              hintText: "Enter agent name...",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          BlocConsumer<AddAgentCubit, AddAgentState>(
            listener: (context, state) {
              if(state is AddAgentErrorState){
                UiHelper.showErrorToste(message: state.errorMsg);
              }
              if(state is AddAgentLoadedState){
                context.read<AgentCubit>().GetAgent();
                UiHelper.showSuccessToste(message: state.successMsg);
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if(state is AddAgentLoadingState){
                return Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                onPressed: () {
                  String value = _controller.text;
                  context.read<AddAgentCubit>().addAgent(agentName: value);
                },
                child: const Text("Add Agent"),
              );
            },
          )
        ],
      );
    },
  );
}

