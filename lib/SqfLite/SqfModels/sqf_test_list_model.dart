class SqfTestListModel{

  int? id;
  String test_name;
  String rate;
  String delivery_after;
  String department;
  String test_file;

  SqfTestListModel({
    this.id,
    required this.test_name,
    required this.rate,
    required this.delivery_after,
    required this.department,
    required this.test_file,
  });

  factory SqfTestListModel.fromMap(Map<String, dynamic> map) {
    return SqfTestListModel(
      id: map['id'],
      test_name: map['test_name'],
      rate: map['rate'],
      delivery_after: map['delivery_after'],
      department: map['department'],
      test_file: map['test_file'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'test_name': test_name,
      'rate': rate,
      'delivery_after': delivery_after,
      'department': department,
      'test_file': test_file,
    };
  }



}