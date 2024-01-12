import 'package:agro_worlds/modules/addProspect/AddProspect.dart';
import 'package:agro_worlds/modules/allClients/AllClients.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddProspectSuccess extends StatelessWidget {
  static final String ROUTE_NAME = "/AddProspectSuccess";

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Success",
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
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 48,),
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: CircleAvatar(
                      child: Icon(Icons.check, size: 56, color: Colors.white),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Propect has been\nadded successfully",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 32,

                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 48,
                      child: matForms.elevatedBtn(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        displayText: "View profile",
                        padding: EdgeInsets.only(left: 20, right: 20),
                        player: () {
                          Navigator.pushNamed(context, AllClients.ROUTE_NAME);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      child: matForms.matOutlineButton(
                        textColor: Colors.black,
                        alignment: Alignment.center,
                        displayText: "Add more",
                        borderWidth: 1.5,
                        borderColor: Colors.black87,
                        displayTextSize: 20,
                        padding: EdgeInsets.only(
                            left: 28, right: 28, top: 4, bottom: 4),
                        player: () {
                          Navigator.pushReplacementNamed(context, AddProspect.ROUTE_NAME);
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
