import 'package:agro_worlds/modules/ClientInfo/ClientProfileViewModel.dart';
import 'package:agro_worlds/modules/remark/AddRemark.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientProfileRemarksTab extends StatelessWidget {
  final ClientProfileViewModel model;

  ClientProfileRemarksTab(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: model.asyncInit,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 0.25,
                color: Colors.black38,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16, top: 16, bottom: 8, right: 16),
                child: MATUtils.elevatedBtn(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    displayText: "Add a remark",
                    player: () {
                      Navigator.pushNamed(context, AddRemark.ROUTE_NAME);
                    }),
              ),
              ListView.builder(
                itemCount: model.remarksList.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, int index) {
                  return remarkListItem(context, model.remarksList[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget remarkListItem(BuildContext context, Map<String, dynamic> data) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data["remark"],
              style: TextStyle(
                fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              data["date_time"],
              style: TextStyle(
                  fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                  color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 0.25,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
