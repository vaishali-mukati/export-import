import 'package:agro_worlds/models/User.dart';
import 'package:agro_worlds/modules/myMeetings/MyMeetingsViewModel.dart';

class FlowDataProvider {
  final String NA = "N/A";
  late String otp;
  late String phone;
  late String id;
  late User user;
  late String currClientId;
  String apkVersion = "N/A";
  late Map<String, dynamic> currClient = {};
  late Map<String, dynamic> currMeeting = {};
  late List<dynamic> convertTopPotentialFailures = [];
  late String showMeetingsListOf = MyMeetingsViewModel.MEETINGS_LIST_OF_ALL;

  FlowDataProvider() {
    id = NA;
    otp = NA;
    phone = NA;
    currClientId = NA;
    user = User.error();
  }
}