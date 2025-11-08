class AgentModel {
  String? _error;
  String? _message;
  List<Agent>? _agent;

  AgentModel({String? error, String? message, List<Agent>? agent}) {
    if (error != null) {
      this._error = error;
    }
    if (message != null) {
      this._message = message;
    }
    if (agent != null) {
      this._agent = agent;
    }
  }

  String? get error => _error;
  set error(String? error) => _error = error;
  String? get message => _message;
  set message(String? message) => _message = message;
  List<Agent>? get agent => _agent;
  set agent(List<Agent>? agent) => _agent = agent;

  AgentModel.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    _message = json['message'];
    if (json['Agent'] != null) {
      _agent = <Agent>[];
      json['Agent'].forEach((v) {
        _agent!.add(new Agent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    data['message'] = this._message;
    if (this._agent != null) {
      data['Agent'] = this._agent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Agent {
  int? _id;
  String? _agentName;
  String? _mobile;
  String? _address;
  String? _shopName;
  String? _status;
  String? _updatedAt;
  String? _createdAt;

  Agent(
      {int? id,
        String? agentName,
        String? mobile,
        String? address,
        String? shopName,
        String? status,
        String? updatedAt,
        String? createdAt}) {
    if (id != null) {
      this._id = id;
    }
    if (agentName != null) {
      this._agentName = agentName;
    }
    if (mobile != null) {
      this._mobile = mobile;
    }
    if (address != null) {
      this._address = address;
    }
    if (shopName != null) {
      this._shopName = shopName;
    }
    if (status != null) {
      this._status = status;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get agentName => _agentName;
  set agentName(String? agentName) => _agentName = agentName;
  String? get mobile => _mobile;
  set mobile(String? mobile) => _mobile = mobile;
  String? get address => _address;
  set address(String? address) => _address = address;
  String? get shopName => _shopName;
  set shopName(String? shopName) => _shopName = shopName;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;

  Agent.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _agentName = json['agent_name'];
    _mobile = json['mobile'];
    _address = json['address'];
    _shopName = json['shop_name'];
    _status = json['status'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['agent_name'] = this._agentName;
    data['mobile'] = this._mobile;
    data['address'] = this._address;
    data['shop_name'] = this._shopName;
    data['status'] = this._status;
    data['updated_at'] = this._updatedAt;
    data['created_at'] = this._createdAt;
    return data;
  }
}
