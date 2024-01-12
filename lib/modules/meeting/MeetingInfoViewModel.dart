import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class MeetingInfoViewModel extends BaseViewModel {

  Map<String, dynamic> clientDisplayData = {};
  Map<String, dynamic> meetingData = {};
  String displayTime = "";


  MeetingInfoViewModel(BuildContext context) : super(context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    if (flowDataProvider.currClientId == Constants.NA ||
        flowDataProvider.currClientId.isEmpty || flowDataProvider.currMeeting.isEmpty) {
      MATUtils.showAlertDialog(
          "Something went wrong with this meeting, please try again!",
          context,
              () => Navigator.pop(context));
    } else {
      clientDisplayData =
          MATUtils.getClientDisplayInfo(flowDataProvider.currClient);
      meetingData = flowDataProvider.currMeeting;

    }
  }
}
