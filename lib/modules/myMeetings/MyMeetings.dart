import 'package:agro_worlds/modules/addMeeting/AddMeetingViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyMeetingsViewModel.dart';

class MyMeetings extends StatelessWidget {
  static final String ROUTE_NAME = "/MyMeetings";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyMeetingsViewModel>(
      create: (context) => MyMeetingsViewModel(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Consumer(
            builder: (context, MyMeetingsViewModel model, child) => Text(
              model.title,
              style: TextStyle(color: Colors.black),
            ),
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
                builder: (context, MyMeetingsViewModel model, child) =>
                    RefreshIndicator(
                  onRefresh: model.asyncInit,
                  child: ListView.builder(
                    itemCount: model.meetingsList.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, int index) {
                      return meetingListItem(
                          context, model.meetingsList[index], model, index);
                    },
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, MyMeetingsViewModel model, child) =>
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

  Widget meetingListItem(BuildContext context, Map<String, dynamic> data,
      MyMeetingsViewModel model, int index) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: data["color"],
              radius: 5,
              child: Text(" "),
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
                    data["companyName"],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                        fontWeight: FontWeight.normal),
                  ),
                  Text(
                    data["title"],
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                        fontWeight: FontWeight.normal),
                  ),
                  Row(
                    children: [
                      Text(
                        data["status"],
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        data["date"].toString().length > 10
                            ? data["date"].toString().substring(0, 10)
                            : data["date"],
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  )
                ],
              ),
            ),
            InkWell(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.chevron_right, color: Colors.white),
              ),
              onTap: () {
                model.viewMeetingData(index);
              },
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          width: double.infinity,
          height: .25,
          color: Colors.black54,
        )
      ],
    );
  }
}
