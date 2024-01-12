import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/addMeeting/AddMeeting.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyMeetingsViewModel extends BaseViewModel {
  static const MEETINGS_LIST_OF_ALL = "all";
  static const MEETINGS_LIST_OF_INLINE = "inline";
  static const MEETINGS_LIST_OF_DONE = "done";
  static const MEETINGS_LIST_OF_FOLLOW_UP = "followUp";

  static const USER_ID_KEY = "userId";

  String title = "My meetings";
  var userId;

  List<Map<String, dynamic>> meetingsList = [];

  MyMeetingsViewModel(BuildContext context) : super(context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    try {
      setBusy(true);

      userId = await SharedPrefUtils.getUserId();
      if (flowDataProvider.showMeetingsListOf == MEETINGS_LIST_OF_ALL) {
        title = "My meetings";
        await getUserAllMeetings();
      } else if (flowDataProvider.showMeetingsListOf == MEETINGS_LIST_OF_DONE) {
        title = "Meetings done";
        await getUserDoneMeetings();
      } else if (flowDataProvider.showMeetingsListOf ==
          MEETINGS_LIST_OF_INLINE) {
        title = "Meetings inline";
        await getUserInlineMeetings();
      } else if (flowDataProvider.showMeetingsListOf ==
          MEETINGS_LIST_OF_FOLLOW_UP) {
        title = "Follow up meetings";
        await getUserFollowUpMeetings();
      } else {
        title = "My meetings";
        await getUserAllMeetings();
      }

      if (meetingsList.isEmpty) showToast("No Meetings found");
      setBusy(false);
    } catch (e) {
      setBusy(false);
      showToast("Something went Wrong!");
    }
  }

  void viewMeetingData(int index) async {
    flowDataProvider.currMeeting = meetingsList[index];
    flowDataProvider.currClientId = meetingsList[index]["client_id"];
    try {
      setBusy(true);
      Map<String, dynamic> client =
          await ApiService.getClient(flowDataProvider.currClientId);
      flowDataProvider.currClient = client["data"];
      Navigator.pushNamed(context, AddMeeting.ROUTE_NAME);
      setBusy(false);
    } catch (e) {
      showToast("Something went wrong!");
      setBusy(false);
    }
  }

  Future<void> getUserAllMeetings() async {
    await getUserMeetings({USER_ID_KEY: userId!});
  }

  Future<void> getUserDoneMeetings() async {
    await getUserMeetings({USER_ID_KEY: userId!, "status": "Completed"});
  }

  Future<void> getUserInlineMeetings() async {
    await getUserMeetings({USER_ID_KEY: userId!, "status": "Scheduled"});
  }

  Future<void> getUserFollowUpMeetings() async {
    await getUserMeetings(
        {USER_ID_KEY: userId!, "meetingType": "First Meeting"});
  }

  Future<void> getUserMeetings(Map<String, String> map) async {
    var response = await ApiService.dio
        .post("meetings/get_user_meetings", queryParameters: map);
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      if (data["code"] == "200") {
        List<dynamic> list = data["data"];
        meetingsList.clear();
        list.forEach((element) {
          element["color"] = getColor(element);
          meetingsList.add(element);
        });
      } else if (data["code"] == "300") {
        showToast(data["message"]);
      } else
        showToast("Something went wrong!");
    } else
      showToast("Something went wrong!");

  }

  Color getColor(element) {
    print(element);
    if(element["status"] == "Completed" || element["status"] == "Cancelled") {
      return const Color(0xff999999);
    }
    String date = element["date"];
    var mDate = DateTime.parse(date);
    var currDate = DateTime.now();

    var mDifference = mDate.difference(currDate);

    var hours = mDifference.inHours;
    print(hours);
    if(hours >= 48) {
      return const Color(0xff029302);
    } else if (hours >= 0) {
      return const Color(0xffff923d);
    }
    return const Color(0xffdd0000);
  }
}
