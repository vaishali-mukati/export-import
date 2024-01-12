import 'package:agro_worlds/modules/remark/AddRemarkViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'AddRemarkViewModel.dart';

class AddRemark extends StatelessWidget {
  static final String ROUTE_NAME = "/AddRemark";

  final remarkInputController = TextEditingController();

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

    return ChangeNotifierProvider<AddRemarkViewModel>(
      create: (context) => AddRemarkViewModel(context, matForms),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Add a remark",
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
                builder: (context, AddRemarkViewModel model, child) =>
                    SingleChildScrollView(
                  child: Column(
                    children: [
                      clientInfoWidget(context, model.clientDisplayData, model),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Remark",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                color: Color(0xff9a9b9f)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          child: TextField(
                            controller: remarkInputController,
                            keyboardType: TextInputType.name,
                            maxLines: 5,
                            style: TextStyle(
                                fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                color: Color(0xff313136)),
                            cursorColor: Theme.of(context).accentColor,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffebecec),
                              hintText: "Type here ..",
                              hintStyle: TextStyle(
                                  fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                  color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            obscureText: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: matForms.elevatedBtn(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          displayText: "Submit",
                          player: () {
                            if (remarkInputController.text.isNotEmpty) {
                              model.submit(remarkInputController.text);
                            } else {
                              model.showToast("Fill up all valid data");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, AddRemarkViewModel model, child) =>
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
      AddRemarkViewModel model) {
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
}
