import 'package:agro_worlds/modules/addProspect/AddProspect.dart';
import 'package:agro_worlds/modules/allClients/AllClients.dart';
import 'package:agro_worlds/modules/dashboard/DashboardViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/modules/myMeetings/MyMeetings.dart';
import 'package:agro_worlds/modules/myMeetings/MyMeetingsViewModel.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  static final String ROUTE_NAME = "/dashboard";

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

    return ChangeNotifierProvider<DashboardViewModel>(
      create: (context) => DashboardViewModel(context, matForms),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Dashboard",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
            onPressed: () => SystemNavigator.pop(),
          ),
        ),
        endDrawer: Consumer(
          builder: (context, DashboardViewModel model, child) =>
              AgroWorldsDrawer.drawer(context: context),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Consumer(
                builder: (context, DashboardViewModel model, child) =>
                    RefreshIndicator(
                  onRefresh: model.asyncInit,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            infoWidget(
                                context: context,
                                largeText: model.totalLeads,
                                smallText: "Total Leads",
                                bgColor: const Color(0xffaf8b46),
                                player: () {
                                  Navigator.pushNamed(
                                      context, AllClients.ROUTE_NAME);
                                }),
                            infoWidget(
                                context: context,
                                largeText: model.meetingsInline,
                                smallText: "Meetings inline",
                                bgColor: const Color(0xffbd9b5b),
                                player: () {
                                  model.flowDataProvider.showMeetingsListOf =
                                      MyMeetingsViewModel
                                          .MEETINGS_LIST_OF_INLINE;
                                  Navigator.pushNamed(
                                      context, MyMeetings.ROUTE_NAME);
                                })
                          ],
                        ),
                        Row(
                          children: [
                            infoWidget(
                                context: context,
                                largeText: model.meetingsDone,
                                smallText: "Meetings done",
                                bgColor: const Color(0xffbd9b5b),
                                player: () {
                                  model.flowDataProvider.showMeetingsListOf =
                                      MyMeetingsViewModel.MEETINGS_LIST_OF_DONE;
                                  Navigator.pushNamed(
                                      context, MyMeetings.ROUTE_NAME);
                                }),
                            infoWidget(
                                context: context,
                                largeText: model.followUpMeetings,
                                smallText: "Follow up meetings",
                                bgColor: const Color(0xffaf8b46),
                                player: () {
                                  model.flowDataProvider.showMeetingsListOf =
                                      MyMeetingsViewModel
                                          .MEETINGS_LIST_OF_FOLLOW_UP;
                                  Navigator.pushNamed(
                                      context, MyMeetings.ROUTE_NAME);
                                })
                          ],
                        ),
                        Row(
                          children: [
                            infoWidget(
                                context: context,
                                largeText: model.conversionRate,
                                smallText: "Conversion rate",
                                bgColor: const Color(0xffa07a30),
                                player: () {}),
                            infoWidget(
                                context: context,
                                largeText: model.dealsOfTheMonth,
                                smallText: "Deals this month",
                                bgColor: const Color(0xff91691a),
                                player: () {})
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, AddProspect.ROUTE_NAME),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Add a prospect",
                                    style: TextStyle(
                                        fontSize: Constants.FONT_SIZE_BIG_TEXT,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                IconButton(
                                  iconSize: 24.0,
                                  icon: Icon(Icons.person_add,
                                      color: Colors.white),
                                  onPressed: () => Navigator.pushNamed(
                                      context, AddProspect.ROUTE_NAME),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        belowClickWidgets(
                            context: context,
                            icon: CupertinoIcons.clock,
                            displayText: "View clients",
                            player: () {
                              Navigator.pushNamed(
                                  context, AllClients.ROUTE_NAME);
                            }),
                        belowClickWidgets(
                            context: context,
                            icon: CupertinoIcons.rectangle_stack_person_crop,
                            displayText: "My Meetings",
                            player: () {
                              model.flowDataProvider.showMeetingsListOf =
                                  MyMeetingsViewModel.MEETINGS_LIST_OF_ALL;
                              Navigator.pushNamed(
                                  context, MyMeetings.ROUTE_NAME);
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, DashboardViewModel model, child) =>
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

  Widget belowClickWidgets(
      {required BuildContext context,
      required IconData icon,
      required String displayText,
      void Function()? player}) {
    return InkWell(
      onTap: player,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                icon,
                color: Color(0xff946d20),
                size: 24,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
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

  Widget infoWidget(
      {required BuildContext context,
      required String largeText,
      required String smallText,
      required Color bgColor,
      void Function()? player}) {
    return Expanded(
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(25, 20, 20, 20),
        decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: bgColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
          onTap: player,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                largeText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                smallText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
