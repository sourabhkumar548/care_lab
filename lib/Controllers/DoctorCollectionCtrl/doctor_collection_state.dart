part of 'doctor_collection_cubit.dart';

@immutable
sealed class DoctorCollectionState {}

final class DoctorCollectionInitialState extends DoctorCollectionState {}
final class DoctorCollectionLoadingState extends DoctorCollectionState {}
final class DoctorCollectionLoadedState extends DoctorCollectionState {
  final DoctorCollectionModel doctorCollectionModel;
  DoctorCollectionLoadedState({required this.doctorCollectionModel});
}
final class DoctorCollectionErrorState extends DoctorCollectionState {
  final String errorMsg;
  DoctorCollectionErrorState({required this.errorMsg});
}
