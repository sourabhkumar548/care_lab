class CaseNoModel{

  int case_no;

  CaseNoModel({required this.case_no});

  factory CaseNoModel.fromMap(Map<String, dynamic> map) {
    return CaseNoModel(
      case_no: map['case_no']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'case_no': case_no
    };
  }

}