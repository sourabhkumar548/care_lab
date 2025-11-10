class DoctorCollectionModel {
  final String filterType;
  final FilterUsed filterUsed;
  final double totalCollection;
  final List<DoctorWise> doctorWise;

  DoctorCollectionModel({
    required this.filterType,
    required this.filterUsed,
    required this.totalCollection,
    required this.doctorWise,
  });

  factory DoctorCollectionModel.fromJson(Map<String, dynamic> json) {
    return DoctorCollectionModel(
      filterType: json['filter_type'] ?? "",
      filterUsed: FilterUsed.fromJson(json['filter_used']),
      totalCollection: (json['total_collection'] ?? 0).toDouble(),
      doctorWise: (json['doctor_wise'] as List)
          .map((e) => DoctorWise.fromJson(e))
          .toList(),
    );
  }
}

class FilterUsed {
  final String date;
  final String month;
  final String year;
  final String doctor;

  FilterUsed({
    required this.date,
    required this.month,
    required this.year,
    required this.doctor,
  });

  factory FilterUsed.fromJson(Map<String, dynamic> json) {
    return FilterUsed(
      date: json['date']?.toString() ?? "",
      month: json['month']?.toString() ?? "",
      year: json['year']?.toString() ?? "",
      doctor: json['doctor']?.toString() ?? "",
    );
  }
}

class DoctorWise {
  final String doctor;
  final int patientCount;
  final double totalCollection;

  DoctorWise({
    required this.doctor,
    required this.patientCount,
    required this.totalCollection,
  });

  factory DoctorWise.fromJson(Map<String, dynamic> json) {
    return DoctorWise(
      doctor: json['doctor']?.toString() ?? "Unknown",
      patientCount: json['patient_count'] ?? 0,
      totalCollection: (json['total_collection'] ?? 0).toDouble(),
    );
  }
}
