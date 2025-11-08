class DocModel {
  String? _url;

  DocModel({String? url}) {
    if (url != null) {
      this._url = url;
    }
  }

  String? get url => _url;
  set url(String? url) => _url = url;

  DocModel.fromJson(Map<String, dynamic> json) {
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this._url;
    return data;
  }
}
