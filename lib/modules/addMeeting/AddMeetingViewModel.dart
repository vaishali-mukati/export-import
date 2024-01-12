import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddMeetingViewModel extends BaseViewModel {
  MATForms matForms;

  Map<String, dynamic> clientDisplayData = {};

  List<String> meetingModeNameList;
  String selectedMeetingMode;
  String title = "Add a meeting";

  List<String> meetingStatusNameList = [
    "Scheduled",
    "Delayed",
    "Cancelled",
    "Completed"
  ];
  String selectedMeetingStatus = "Scheduled";
  bool showMeetingStatus = false;

  AddMeetingViewModel(BuildContext context, this.matForms)
      : meetingModeNameList = [
          Constants.DROPDOWN_NON_SELECT,
          "Voice call",
          "Video call",
          "Physical"
        ],
        selectedMeetingMode = Constants.DROPDOWN_NON_SELECT,
        super(context) {
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
      if (flowDataProvider.currMeeting.containsKey("id")) {
        title = "Update meeting";
      }
      clientDisplayData =
          MATUtils.getClientDisplayInfo(flowDataProvider.currClient);
      showMeetingStatus = false;
      if (flowDataProvider.currMeeting.isNotEmpty) {
        await Future.delayed(Duration(milliseconds: 300));
        print(flowDataProvider.currMeeting);
        matForms.setVariableData(
            "title", flowDataProvider.currMeeting["title"]);
        matForms.setVariableData(
            "agenda", flowDataProvider.currMeeting["agenda"]);
        matForms.setVariableData(
            "address", flowDataProvider.currMeeting["address"]);
        matForms.setVariableData(
            "place", flowDataProvider.currMeeting["place"]);
        try {
          var parse = DateTime.parse(flowDataProvider.currMeeting["date"]);
          var formatter = DateFormat("yyyy-MM-dd hh:mm aaa");

          matForms.setVariableData("date", formatter.format(parse));
        } catch (e) {}
        selectedMeetingStatus = flowDataProvider.currMeeting["status"];
        print("selectedMeetingStatus $selectedMeetingStatus");
        selectedMeetingMode = flowDataProvider.currMeeting["mode"];
        showMeetingStatus = true;
        notifyListeners();
      }
    }
  }

  void setSelectedMode(dynamic val) {
    selectedMeetingMode = val;
    notifyListeners();
  }

  void setSelectedStatus(dynamic val) {
    selectedMeetingStatus = val;
    notifyListeners();
  }

  Future<void> submit() async {
    print("Submit CALLED");
    if (selectedMeetingMode == Constants.DROPDOWN_NON_SELECT) {
      showToast("Select meeting mode");
      return;
    }
    if (matForms.dynamicFormKey.currentState != null) {
      print("in");
      try {
        setBusy(true);
        var formData = matForms.dynamicFormKey.currentState!.value;
        var reqData = Map<String, dynamic>();
        formData.forEach((key, value) {
          reqData[key] = value;
        });
        String? id = await SharedPrefUtils.getUserId();

        reqData.putIfAbsent("userId", () => id);
        reqData.putIfAbsent(
            "clientId", () => flowDataProvider.currClient["id"]);
        reqData.putIfAbsent("mode", () => selectedMeetingMode);
        reqData.putIfAbsent("status", () => selectedMeetingStatus);

        reqData.putIfAbsent("time", () => " ");

        if (!flowDataProvider.currMeeting.containsKey("id")) {
          await addMeetingApiCall(reqData);
        } else {
          reqData.putIfAbsent(
              "meetingId", () => flowDataProvider.currMeeting["id"]);

          if (!reqData.containsKey("date") || reqData["date"] == null) {
            reqData["date"] = flowDataProvider.currMeeting["date"];
          }
          await updateMeetingApiCall(reqData);
        }
        setBusy(false);
      } catch (e) {
        showToast("Something went Wrong!");
        setBusy(false);
      }
    }
  }

  Future<void> addMeetingApiCall(Map<String, dynamic> formData) async {
    var response = await ApiService.dio
        .post("meetings/add_meeting", queryParameters: formData);

    if (response.statusCode == 200) {
      var result = json.decode(response.data);
      if (result["code"] == "300")
        showToast(result["message"]);
      else if (result["code"] == "200")
        MATUtils.showAlertDialog(
            "Added meeting with ${clientDisplayData["name"]}", context, () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      else
        showToast("Something went Wrong!");
    } else {
      showToast("Something went Wrong!");
    }
  }

  Future<void> updateMeetingApiCall(Map<String, dynamic> formData) async {
    var response = await ApiService.dio
        .post("meetings/update_meeting", queryParameters: formData);

    if (response.statusCode == 200) {
      var result = json.decode(response.data);
      if (result["code"] == "300")
        showToast(result["message"]);
      else if (result["code"] == "200")
        MATUtils.showAlertDialog(
            "Updated meeting with ${clientDisplayData["name"]}", context, () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      else
        showToast("Something went Wrong!");
    } else {
      showToast("Something went Wrong!");
    }
  }
}
