class SqfDoctorListModel{

  int? id;
  String doctor_name;
  String post;
  String mobile;

  SqfDoctorListModel({this.id,required this.doctor_name,required this.post,required this.mobile});

  factory SqfDoctorListModel.fromMap(Map<String, dynamic> map) {
    return SqfDoctorListModel(
        id: map['id'],
        doctor_name: map['doctor_name'],
        post: map['post'],
        mobile: map['mobile'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctor_name': doctor_name,
      'post': post,
      'mobile': mobile,
    };
  }

}