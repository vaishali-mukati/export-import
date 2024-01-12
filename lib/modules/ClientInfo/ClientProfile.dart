import 'package:agro_worlds/modules/ClientInfo/ClientProfileActionsTab.dart';
import 'package:agro_worlds/modules/ClientInfo/ClientProfileProfileTab.dart';
import 'package:agro_worlds/modules/ClientInfo/ClientProfileMeetigsTab.dart';
import 'package:agro_worlds/modules/ClientInfo/ClientProfileRemarksTab.dart';
import 'package:agro_worlds/modules/ClientInfo/ClientProfileViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientProfile extends StatelessWidget {
  static final String ROUTE_NAME = "/ClientProfile";

  @override
  Widget build(BuildContext context) {

    final title = 'Client profile';
    return ChangeNotifierProvider<ClientProfileViewModel>(
      create: (context) => ClientProfileViewModel(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        endDrawer: AgroWorldsDrawer.drawer(context: context),
        body: SafeArea(
          child: Stack(
            children: [
              DefaultTabController(
                length: 4,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        elevation: 0,
                        title: Text(
                          title,
                          style: TextStyle(color: Colors.black),
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Theme.of(context).accentColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                        iconTheme:
                            IconThemeData(color: Theme.of(context).accentColor),
                        floating: true,
                        expandedHeight: 156,
                        backgroundColor: Colors.white,
                        flexibleSpace: Padding(
                          padding: EdgeInsets.only(
                              top: 64, left: 16, right: 16, bottom: 16),
                          child: Consumer(
                            builder: (context, ClientProfileViewModel model,
                                    child) =>
                        RefreshIndicator(
                        onRefresh: model.asyncInit,
                        child: SingleChildScrollView(
                              child: Container(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 36,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: CircleAvatar(
                                        radius: 32,
                                        backgroundColor: Colors.black,
                                        child: Text(
                                          model.clientDisplayData.isNotEmpty
                                              ? model.clientDisplayData["name"]
                                                  .toString()
                                                  .substring(0, 1)
                                                  .toUpperCase()
                                              : "",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model.clientDisplayData.isNotEmpty
                                                ? model
                                                    .clientDisplayData["name"]
                                                : "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  Constants.FONT_SIZE_BIG_TEXT,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            model.clientDisplayData.isNotEmpty
                                                ? model.clientDisplayData[
                                                    "address"]
                                                : "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: Constants
                                                  .FONT_SIZE_NORMAL_TEXT,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            model.clientDisplayData.isNotEmpty
                                                ? model.clientDisplayData[
                                                    "clientStatus"]
                                                : "",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: Constants
                                                    .FONT_SIZE_SMALL_TEXT,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Icon(
                                          Icons.call,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () async {
                                        if (await canLaunch(
                                            'tel:${model.clientDisplayData["contact"]}'))
                                          await launch(
                                              'tel:${model.clientDisplayData["contact"]}');
                                        else
                                          model.showToast(
                                              "Failed to call ${model.clientDisplayData["contact"]}");
                                      },
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),),
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            labelStyle:
                                TextStyle(fontWeight: FontWeight.normal),
                            overlayColor:
                                MaterialStateProperty.all(Colors.white),
                            indicatorColor: Theme.of(context).primaryColor,
                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Tab(
                                text: "Actions",
                              ),
                              Tab(
                                text: "Profile",
                              ),
                              Tab(
                                text: "Remarks",
                              ),
                              Tab(
                                text: "Meetings",
                              ),
                            ],
                          ),
                        ),
                        pinned: true,
                      ),
                    ];
                  },
                  body: Consumer(
                    builder: (context, ClientProfileViewModel model, child) =>
                        TabBarView(
                      children: [
                        ClientProfileActionsTab(model),
                        ClientProfileProfileTab(model),
                        ClientProfileRemarksTab(model),
                        ClientProfileMeetingsTab(model),
                      ],
                    ),
                  ),
                ),
              ),
              Consumer(
                builder: (context, ClientProfileViewModel model, child) =>
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
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
