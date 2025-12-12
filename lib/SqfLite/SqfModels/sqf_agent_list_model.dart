class SqfAgentListModel{

  int? id;
  String agent_name;
  String mobile;
  String address;
  String shop_name;

  SqfAgentListModel({this.id,required this.agent_name,required this.mobile,required this.address,required this.shop_name});

  factory SqfAgentListModel.fromMap(Map<String, dynamic> map) {
    return SqfAgentListModel(
      id: map['id'],
      agent_name: map['agent_name'],
      mobile: map['mobile'],
      address: map['address'],
      shop_name: map['shop_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'agent_name': agent_name,
      'mobile': mobile,
      'address': address,
      'shop_name': shop_name,
    };
  }

}