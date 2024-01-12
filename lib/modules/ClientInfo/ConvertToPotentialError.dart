import 'package:agro_worlds/modules/addProspect/AddProspect.dart';
import 'package:agro_worlds/modules/allClients/AllClients.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/providers/FlowDataProvider.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ConvertToPotentialError extends StatelessWidget {
  static final String ROUTE_NAME = "/ConvertToPotentialError";

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

    FlowDataProvider provider = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Failure",
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
            padding: EdgeInsets.only(left: 32, right: 32, top: 8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 48,
                  ),
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: CircleAvatar(
                      child: Icon(Icons.clear, size: 56, color: Colors.white),
                      backgroundColor: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Request to convert\nprospect into potential\ncannot been sent",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffebecec),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.convertTopPotentialFailures.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: 8, bottom: 8, left: 16, right: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Colors.black,
                                  size: 8,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  provider.convertTopPotentialFailures[index]
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 48,
                      child: matForms.elevatedBtn(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        displayText: "Back to profile",
                        padding: EdgeInsets.only(left: 20, right: 20),
                        player: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
