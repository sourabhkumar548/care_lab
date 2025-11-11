class AgentCollectionModel {
  final String filterType;
  final FilterUsed filterUsed;
  final double totalCollection;
  final List<AgentWise> agentWise;

  AgentCollectionModel({
    required this.filterType,
    required this.filterUsed,
    required this.totalCollection,
    required this.agentWise,
  });

  factory AgentCollectionModel.fromJson(Map<String, dynamic> json) {
    return AgentCollectionModel(
      filterType: json['filter_type'] ?? "",
      filterUsed: FilterUsed.fromJson(json['filter_used']),
      totalCollection: (json['total_collection'] ?? 0).toDouble(),
      agentWise: (json['agent_wise'] as List)
          .map((e) => AgentWise.fromJson(e))
          .toList(),
    );
  }
}

class FilterUsed {
  final String date;
  final String month;
  final String year;
  final String agent;

  FilterUsed({
    required this.date,
    required this.month,
    required this.year,
    required this.agent,
  });

  factory FilterUsed.fromJson(Map<String, dynamic> json) {
    return FilterUsed(
      date: json['date']?.toString() ?? "",
      month: json['month']?.toString() ?? "",
      year: json['year']?.toString() ?? "",
      agent: json['agent']?.toString() ?? "",
    );
  }
}

class AgentWise {
  final String agent;
  final int patientCount;
  final double totalCollection;

  AgentWise({
    required this.agent,
    required this.patientCount,
    required this.totalCollection,
  });

  factory AgentWise.fromJson(Map<String, dynamic> json) {
    return AgentWise(
      agent: json['agent']?.toString() ?? "Unknown",
      patientCount: json['patient_count'] ?? 0,
      totalCollection: (json['total_collection'] ?? 0).toDouble(),
    );
  }
}
