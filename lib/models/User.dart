/// id : "2"
/// first_name : "Dilip"
/// last_name : "Hingwe"
/// email : "dilip.h1190@gmail.com"
/// phone : "9009193663"
/// profile_pic : null
/// status : "1"
/// admin_approved : "1"
/// created : "2021-06-19 16:04:04"
/// reporting_person_id : "1"
/// reporting_person_first_name : "Admin"
/// reporting_person_last_name : "AgroWorlds"
/// User_role : "Manager"
/// business_name : null
/// address_line1 : null
/// address_line2 : null
/// city : null
/// client_status : null
/// client_bde : null
/// client_bdm : null
/// client_trader : null
/// products : null

class User {
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  dynamic? _profilePic;
  String? _status;
  String? _adminApproved;
  String? _created;
  String? _reportingPersonId;
  String? _reportingPersonFirstName;
  String? _reportingPersonLastName;
  String? _userRole;
  dynamic? _businessName;
  dynamic? _addressLine1;
  dynamic? _addressLine2;
  dynamic? _city;
  dynamic? _clientStatus;
  dynamic? _clientBde;
  dynamic? _clientBdm;
  dynamic? _clientTrader;
  dynamic? _products;

  bool _error = false;

  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phone => _phone;
  dynamic? get profilePic => _profilePic;
  String? get status => _status;
  String? get adminApproved => _adminApproved;
  String? get created => _created;
  String? get reportingPersonId => _reportingPersonId;
  String? get reportingPersonFirstName => _reportingPersonFirstName;
  String? get reportingPersonLastName => _reportingPersonLastName;
  String? get userRole => _userRole;
  dynamic? get businessName => _businessName;
  dynamic? get addressLine1 => _addressLine1;
  dynamic? get addressLine2 => _addressLine2;
  dynamic? get city => _city;
  dynamic? get clientStatus => _clientStatus;
  dynamic? get clientBde => _clientBde;
  dynamic? get clientBdm => _clientBdm;
  dynamic? get clientTrader => _clientTrader;
  dynamic? get products => _products;
  bool get isError => _error;

  User({
      String? id, 
      String? firstName, 
      String? lastName, 
      String? email, 
      String? phone, 
      dynamic? profilePic, 
      String? status, 
      String? adminApproved, 
      String? created, 
      String? reportingPersonId, 
      String? reportingPersonFirstName, 
      String? reportingPersonLastName, 
      String? UserRole, 
      dynamic? businessName, 
      dynamic? addressLine1, 
      dynamic? addressLine2, 
      dynamic? city, 
      dynamic? clientStatus, 
      dynamic? clientBde, 
      dynamic? clientBdm, 
      dynamic? clientTrader, 
      dynamic? products,
      bool error = false
  }){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phone = phone;
    _profilePic = profilePic;
    _status = status;
    _adminApproved = adminApproved;
    _created = created;
    _reportingPersonId = reportingPersonId;
    _reportingPersonFirstName = reportingPersonFirstName;
    _reportingPersonLastName = reportingPersonLastName;
    _userRole = UserRole;
    _businessName = businessName;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _city = city;
    _clientStatus = clientStatus;
    _clientBde = clientBde;
    _clientBdm = clientBdm;
    _clientTrader = clientTrader;
    _products = products;
    _error = error;
}

  User.fromJson(dynamic json) {
    _id = json["id"];
    _firstName = json["first_name"];
    _lastName = json["last_name"];
    _email = json["email"];
    _phone = json["phone"];
    _profilePic = json["profile_pic"];
    _status = json["status"];
    _adminApproved = json["admin_approved"];
    _created = json["created"];
    _reportingPersonId = json["reporting_person_id"];
    _reportingPersonFirstName = json["reporting_person_first_name"];
    _reportingPersonLastName = json["reporting_person_last_name"];
    _userRole = json["user_role"];
    _businessName = json["business_name"];
    _addressLine1 = json["address_line1"];
    _addressLine2 = json["address_line2"];
    _city = json["city"];
    _clientStatus = json["client_status"];
    _clientBde = json["client_bde"];
    _clientBdm = json["client_bdm"];
    _clientTrader = json["client_trader"];
    _products = json["products"];
    _error = false;
  }


  User.error() {
    _error = true;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["first_name"] = _firstName;
    map["last_name"] = _lastName;
    map["email"] = _email;
    map["phone"] = _phone;
    map["profile_pic"] = _profilePic;
    map["status"] = _status;
    map["admin_approved"] = _adminApproved;
    map["created"] = _created;
    map["reporting_person_id"] = _reportingPersonId;
    map["reporting_person_first_name"] = _reportingPersonFirstName;
    map["reporting_person_last_name"] = _reportingPersonLastName;
    map["user_role"] = _userRole;
    map["business_name"] = _businessName;
    map["address_line1"] = _addressLine1;
    map["address_line2"] = _addressLine2;
    map["city"] = _city;
    map["client_status"] = _clientStatus;
    map["client_bde"] = _clientBde;
    map["client_bdm"] = _clientBdm;
    map["client_trader"] = _clientTrader;
    map["products"] = _products;
    return map;
  }

}