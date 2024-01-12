import 'dart:convert';

import 'package:agro_worlds/models/Role.dart';
import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegisterViewModel extends BaseViewModel {

  MATForms matForms;

  bool isNameEntered = false;
  late String name;

  List<ListItem> roles = [];
  List<String> roleNames = [];
  String selectedRole = "-select";
  bool isContactValid = false;

  RegisterViewModel(BuildContext context, this.matForms) : super(context) {
    name = "";
    asyncInit();
  }


  void asyncInit() async {
    setBusy(true);
    try {
      roles = await ApiService.rolesList();
      print("length ${roles.length}");

      roles.forEach((element) {
        roleNames.add(element.name);
      });
      selectedRole = roleNames[0];

      setBusy(false);
    } catch (e) {
      print("catch $e");
      setBusy(false);
    }
  }


  void updateSelectedDepartment(val) {
    selectedRole = val.toString();
    notifyListeners();
  }


  void submit() async {
    if(!isContactValid) {
      showToast("Enter valid Contact");
      return;
    }
    if (matForms.dynamicFormKey.currentState != null) {
      var formData = matForms.dynamicFormKey.currentState!.value;
      Map<String, dynamic> reqData = Map();
      formData.forEach((key, value) {
        reqData[key] = value;
      });
      reqData.putIfAbsent("image", () => "");
      reqData.putIfAbsent("department", ()
      {
        ListItem r = roles.firstWhere((element) => element.name == selectedRole);
        return r.id;
      });
      try {
        setBusy(true);
        var response = await registerApi(reqData);
        setBusy(false);
        Map<String, dynamic> result = json.decode(response);
        if (result["code"] == "400" || result["code"] == "300")
          MATUtils.showAlertDialog(result["message"], context, () => Navigator.pop(context));
        else if (result["code"] == "200") {
          MATUtils.showAlertDialog(result["message"], context, () { Navigator.pop(context); Navigator.pop(context);});
        } else
          showToast("Something went Wrong!");
      } catch (e) {
        print("error => $e");
        showToast("Something went Wrong!");
      }
    }
  }

  void setName(String name) {
    bool shouldNotify = false;
    if ((this.name.isEmpty && name.isNotEmpty) ||
        (this.name.isNotEmpty && name.isEmpty))
      shouldNotify = true;

    this.name = name;

    if (name.isNotEmpty)
      isNameEntered = true;
    else if (name.isEmpty)
      isNameEntered = false;
    if (shouldNotify)
      notifyListeners();
  }


  dynamic registerApi(Map<String, dynamic> formData) async {
    var response = await ApiService.dio.get(
        "profile/register", queryParameters: formData);
    if (response.statusCode == 200)
      return response.data;
    else
      return {"error": "Failure", "data": response.data};
  }

}