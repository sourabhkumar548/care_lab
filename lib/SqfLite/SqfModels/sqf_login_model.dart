class SQFUserModel {
  final int? id;
  final String name;
  final String username;
  final String password;
  final String post;

  SQFUserModel({
    this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.post,
  });

  factory SQFUserModel.fromMap(Map<String, dynamic> map) {
    return SQFUserModel(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      password: map['password'],
      post: map['post'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'post': post,
    };
  }
}
