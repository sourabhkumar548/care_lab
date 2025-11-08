import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Controllers/CaseNumberCtrl/Cubit/case_number_cubit.dart';

class GetCaseNumber {
  static String getNumber(BuildContext context) {
        final state = context.read<CaseNumberCubit>().state;

        if (state is CaseNumberLoadedState) {
          return state.CaseNumber;
        }
        return "0";
  }
}
