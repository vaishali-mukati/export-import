import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/login/LoginScreen.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class DashboardViewModel extends BaseViewModel {
  late final MATForms matForms;

  DashboardViewModel(BuildContext context, this.matForms) : super(context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    setBusy(true);
    String? userId = await SharedPrefUtils.getUserId();
    if (userId == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
    }
    await getCardsValue();
    await getUserData(userId!);
    setBusy(false);
  }

  Future<void> getUserData(String uId) async {
    try {

      var user = await ApiService.getUser();
      if (user.isError) {
        sendToLogin();
        return;
      }
      if (user.userRole == null) {
        showToast("Can not find your Role!");
        sendToLogin();
        return;
      }
      flowDataProvider.user = user;

    } catch (e) {
      sendToLogin();
    }

     try{
       PackageInfo packageInfo = await PackageInfo.fromPlatform();
       print(1);
       flowDataProvider.apkVersion = packageInfo.version;
       print(flowDataProvider.apkVersion);
     } catch(e) {
      print(e);
     }
  }

  void sendToLogin() {
    SharedPrefUtils.deleteUserId();
    Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
  }

  String totalLeads = "N/A";
  String meetingsDone = "N/A";
  String meetingsInline = "N/A";
  String followUpMeetings = "N/A";
  String conversionRate = "N/A";
  String dealsOfTheMonth = "N/A";

  Future<void> getCardsValue() async {
    await getTotalLeads();
    await getMeetingsDone();
    await getMeetingsInline();
    await getFollowUpMeetings();
    await getConversionRate();
    await getDealsOfMonth();
  }

  Future<void> getMeetingsInline() async {
    try {
      var res = await ApiService.dio.post("dashboard/meetings_inline",
          queryParameters: {"user_id": await SharedPrefUtils.getUserId()});
      if (res.statusCode == 200) {
        var decode = json.decode(res.data);
        meetingsInline = "${decode["meetings_inline"]}";
      }
    } catch (e) {
      print("error $e");
    }
  }

  Future<void> getMeetingsDone() async {
     try {
      var res = await ApiService.dio.post("dashboard/meetings_done",
          queryParameters: {"user_id": await SharedPrefUtils.getUserId()});
      if (res.statusCode == 200) {
        var decode = json.decode(res.data);
        meetingsDone = "${decode["meetings_done"]}";
      }
    } catch (e) {
       print("error $e");}
  }

  Future<void> getTotalLeads() async {
     try {
      var res = await ApiService.dio.post("dashboard/total_leads",
          queryParameters: {"user_id": await SharedPrefUtils.getUserId()});
      if (res.statusCode == 200) {
        var decode = json.decode(res.data);
        totalLeads = "${decode["total_leads"]}";
      }
    } catch (e) {
       print("error $e");}
  }

  Future<void> getFollowUpMeetings() async {
    try {
      var res = await ApiService.dio.post("dashboard/follow_up_meetings",
          queryParameters: {"user_id": await SharedPrefUtils.getUserId()});
      if (res.statusCode == 200) {
        var decode = json.decode(res.data);
        followUpMeetings = "${decode["follow_up_meetings"]}";
      }
    } catch (e) {
      print("error $e");}
  }
  Future<void> getConversionRate() async {
    try {
      var res = await ApiService.dio.post("dashboard/conversion_rate",
          queryParameters: {"user_id": await SharedPrefUtils.getUserId()});
      if (res.statusCode == 200) {
        var decode = json.decode(res.data);
        conversionRate = "${decode["conversion_rate"]}%";
      }
    } catch (e) {}
  }
  Future<void> getDealsOfMonth() async {
    try {
      var res = await ApiService.dio.post("dashboard/month_total_deals",
          queryParameters: {"user_id": await SharedPrefUtils.getUserId()});
      if (res.statusCode == 200) {
        var decode = json.decode(res.data);
        dealsOfTheMonth = "${decode["total_deals"]}";
      }
    } catch (e) {}
  }
}
