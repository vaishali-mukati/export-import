import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/dashboard/DashboardScreen.dart';
import 'package:agro_worlds/modules/login/LoginController.dart';
import 'package:agro_worlds/providers/FlowDataProvider.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import 'OtpController.dart';

class OtpViewModel extends BaseViewModel {
  late final MATForms matForms;
  bool enableResendOtp = true;
  late Color resendOtpTextColor = Theme.of(context).accentColor;

  late final LoginController _loginController;
  late final OtpController _otpController;

  OtpViewModel(BuildContext context, this.matForms) : super(context) {
    _loginController = LoginController();
    _otpController = OtpController();
  }

  void resendOtp() {
    showToast("Sending OTP Again");
    enableResendOtp = false;
    resendOtpTextColor = Colors.grey;
    notifyListeners();
    reLogin();
  }

  void reLogin() async{
    try {
      var response = await _loginController.login(flowDataProvider.phone);
      Map<String, dynamic> result = json.decode(response);
      if (result["code"] == "200") {
        flowDataProvider.otp = result["data"]["OTP"];
      } else {
        showToast("Something went Wrong while resending OTP!");
      }
    } catch (e) {
      showToast("Something went Wrong while resending OTP!");
    }
  }


  void submit(String otp) async {
    if(otp == flowDataProvider.otp) {
      try {
        setBusy(true);
        var response = await _otpController.loginCheck(otp, flowDataProvider.id);
        setBusy(false);
        var data = json.decode(response) as Map<String, dynamic>;
        if (data.containsKey("error")) {
          showToast("Network Error");
          return;
        }
        if (data["code"] == "200") {
          String id = data["data"]["id"];
          await SharedPrefUtils.saveUserId(id);
          Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.ROUTE_NAME, (route) => false);
        } else {
          showToast("Something went Wrong!");
        }
      } catch(e) {
        showToast("Something went Wrong!");
      }
    } else {
      showToast("Invalid OTP");
    }
  }
}