import 'package:agro_worlds/modules/addMeeting/AddMeeting.dart';
import 'package:agro_worlds/modules/remark/AddRemark.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ClientProfileViewModel.dart';

class ClientProfileActionsTab extends StatelessWidget {
  final ClientProfileViewModel model;

  ClientProfileActionsTab(this.model);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: model.asyncInit,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Container(
                  height: 0.25,
                  color: Colors.black38,
                ),
                SizedBox(
                  height: 10,
                ),
                belowClickWidgets(
                  context: context,
                  displayText: "Edit profile",
                  player: () {
                    DefaultTabController.of(context)!.animateTo(1);
                  },
                ),
                Offstage(
                  offstage: model.isPotential,
                  child: belowClickWidgets(
                    context: context,
                    displayText: "Convert to potential",
                    player: () {
                      model.convertToPotential();
                    },
                  ),
                ),
                belowClickWidgets(
                  context: context,
                  displayText: "Add a remark",
                  player: () {
                    Navigator.pushNamed(context, AddRemark.ROUTE_NAME);
                  },
                ),
                belowClickWidgets(
                  context: context,
                  displayText: "Add a meeting",
                  player: () {
                    model.flowDataProvider.currMeeting = {};
                    Navigator.pushNamed(context, AddMeeting.ROUTE_NAME);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget belowClickWidgets(
      {required BuildContext context,
      required String displayText,
      void Function()? player}) {
    return InkWell(
      onTap: player,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(24, 5, 24, 5),
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.right_chevron,
                color: Color(0xff946d20),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Color(0xffd6d6d6),
          ),
        ]),
      ),
    );
  }
}
