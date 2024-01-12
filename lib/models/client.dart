/// businessName : "xyz"
/// firstName : "asd"
/// lastName : "qwe"
/// email : "zxc@g.com"
/// contact : "98765643421"
/// addressLine1 : "lin1"
/// clientType : "Prospect"
/// id : "2"

class Client {
  String? _businessName;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _contact;
  String? _addressLine1;
  String? _clientType;
  String? _id;

  String? get businessName => _businessName;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get contact => _contact;
  String? get addressLine1 => _addressLine1;
  String? get clientType => _clientType;
  String? get id => _id;

  Client({
      String? businessName, 
      String? firstName, 
      String? lastName, 
      String? email, 
      String? contact, 
      String? addressLine1, 
      String? clientType, 
      String? id}){
    _businessName = businessName;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _contact = contact;
    _addressLine1 = addressLine1;
    _clientType = clientType;
    _id = id;
}

  Client.fromJson(dynamic json) {
    _businessName = json["businessName"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _email = json["email"];
    _contact = json["contact"];
    _addressLine1 = json["addressLine1"];
    _clientType = json["clientType"];
    _id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["businessName"] = _businessName;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["email"] = _email;
    map["contact"] = _contact;
    map["addressLine1"] = _addressLine1;
    map["clientType"] = _clientType;
    map["id"] = _id;
    return map;
  }

}