import 'package:agro_worlds/modules/meeting/MeetingInfoViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'MeetingInfoViewModel.dart';

class MeetingInfo extends StatelessWidget {
  static final String ROUTE_NAME = "/MeetingInfo";

  final GlobalKey<FormBuilderState> dynamicFormKey =
      GlobalKey<FormBuilderState>();
  final Map<String, TextEditingController> mapper = Map();

  void saveVariable(String variable, String data) {
    mapper[variable]!.text = data;
  }

  late final MATForms matForms;

  @override
  Widget build(BuildContext context) {
    matForms = MATForms(
        context: context,
        dynamicFormKey: dynamicFormKey,
        mapper: mapper,
        saveController: saveVariable);

    return ChangeNotifierProvider<MeetingInfoViewModel>(
      create: (context) => MeetingInfoViewModel(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Meeting",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        endDrawer: AgroWorldsDrawer.drawer(context: context),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0),
              child: Consumer(
                builder: (context, MeetingInfoViewModel model, child) =>
                    SingleChildScrollView(
                  child: Column(
                    children: [
                      clientInfoWidget(context, model.clientDisplayData, model),
                      SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.meetingData["title"].toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: Constants.FONT_SIZE_BIG_TEXT,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Meeting agenda",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                              color: Color(0xff9a9b9f)),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.meetingData["agenda"].toString().isEmpty
                              ? "N/A"
                              : model.meetingData["agenda"].toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      meetingTimeAddress(
                          context,
                          Icons.calendar_today_outlined,
                          "${model.meetingData["date"].toString().substring(0, 10)} ${model.meetingData["time"].toString().substring(10, 16)}",
                          "(20 hours left)"),
                      meetingTimeAddress(
                          context,
                          Icons.location_on_outlined,
                          "V R Tower head office",
                          "30, business park, Airport Road"),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        height: 0.25,
                        color: Colors.black38,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Meeting status",
                            style: TextStyle(
                                fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      matForms.borderedDropDown(
                          borderColor: Theme.of(context).primaryColor,
                          items: ["-Select-"],
                          displayValue: "-Select-",
                          menuColor: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                          borderRadius: 8,
                          player: (val) {}),
                      SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: matForms.elevatedBtn(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          displayText: "Update status",
                          player: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, MeetingInfoViewModel model, child) =>
                  MATUtils.showLoader(
                context: context,
                isLoadingVar: model.busy,
                size: 20,
                opacity: 0.95,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clientInfoWidget(BuildContext context, Map<String, dynamic> data,
      MeetingInfoViewModel model) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.black,
                child: Text(
                  data["name"].toString().substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["name"].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Constants.FONT_SIZE_BIG_TEXT,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    data["address"].toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    data["clientStatus"].toString(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget meetingTimeAddress(BuildContext context, IconData iconData,
      String primaryText, String secondaryText) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Icon(
              iconData,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryText,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  secondaryText,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                      color: Color(0xff9a9b9f)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
