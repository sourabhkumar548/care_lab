part of 'doctor_collection_cubit.dart';

@immutable
sealed class DoctorCollectionState {}

final class DoctorCollectionInitialState extends DoctorCollectionState {}
final class DoctorCollectionLoadingState extends DoctorCollectionState {}
final class DoctorCollectionLoadedState extends DoctorCollectionState {
  final SaleModel saleModel;
  DoctorCollectionLoadedState({required this.saleModel});
}
final class DoctorCollectionErrorState extends DoctorCollectionState {
  final String errorMsg;
  DoctorCollectionErrorState({required this.errorMsg});
}
