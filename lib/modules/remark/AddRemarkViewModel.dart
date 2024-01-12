import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddRemarkViewModel extends BaseViewModel {
  MATForms matForms;

  Map<String, dynamic> clientDisplayData = {};

  AddRemarkViewModel(BuildContext context, this.matForms) : super(context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    if (flowDataProvider.currClientId == Constants.NA ||
        flowDataProvider.currClientId.isEmpty) {
      MATUtils.showAlertDialog(
          "Something went wrong with this client, please try again!",
          context,
          () => Navigator.pop(context));
    } else {
      clientDisplayData =
          MATUtils.getClientDisplayInfo(flowDataProvider.currClient);
    }
  }

  Future<void> submit(String remark) async {
    print(remark);
    try {
      setBusy(true);
      var response =
          await ApiService.dio.post("profile/add_remark", queryParameters: {
        "userId": await SharedPrefUtils.getUserId(),
        "clientId": clientDisplayData["id"],
        "remark": remark
      });
      setBusy(false);
      if (response.statusCode == 200) {
        var result = json.decode(response.data);
        print(result);
        if (result["code"] == "300")
          showToast(result["message"]);
        else if (result["code"] == "200")
          MATUtils.showAlertDialog(
              "Added remark for ${clientDisplayData["name"]}", context, () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        else
          showToast("Something went Wrong!");
      } else {
        showToast("Something went Wrong!");
      }
    } catch (e) {
      showToast("Something went Wrong!");
      setBusy(false);
    }
  }
}
