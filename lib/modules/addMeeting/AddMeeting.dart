import 'package:agro_worlds/modules/addMeeting/AddMeetingViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class AddMeeting extends StatelessWidget {
  static final String ROUTE_NAME = "/AddMeeting";

  final GlobalKey<FormBuilderState> dynamicFormKey =
      GlobalKey<FormBuilderState>();
  final Map<String, TextEditingController> mapper = Map();

  void saveVariable(String variable, String data) {
    mapper[variable]!.text = data;
  }

  late final MATForms matForms;
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    if(!isInitialized) {
      matForms = MATForms(
          context: context,
          dynamicFormKey: dynamicFormKey,
          mapper: mapper,
          saveController: saveVariable);
      isInitialized = true;
    }

    return ChangeNotifierProvider<AddMeetingViewModel>(
      create: (context) => AddMeetingViewModel(context, matForms),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Consumer(
              builder: (context, AddMeetingViewModel model, child) => Text(
                   model.title,
                    style: TextStyle(color: Colors.black),
                  )),
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
              child: SingleChildScrollView(
                child: Consumer(
                  builder: (context, AddMeetingViewModel model, child) =>
                      FormBuilder(
                    key: dynamicFormKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        clientInfoWidget(
                            context, model.clientDisplayData, model),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Meeting Mode",
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
                            items: model.meetingModeNameList,
                            displayValue: model.selectedMeetingMode,
                            menuColor: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                            borderRadius: 8,
                            player: model.setSelectedMode),
                        SizedBox(
                          height: 8,
                        ),
                        matForms.matEditable(
                          variable: "title",
                          displayText: "Meeting title",
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                        ),
                        matForms.matDateTimePicker(
                          variable: "date",
                          displayText: "Meeting date time",
                          startDate: DateTime.now(),
                          player: (val) {},
                          validator: FormBuilderValidators.compose([]),
                        ),
                        matForms.matEditable(
                          variable: "place",
                          displayText: "Meeting place",
                          validator: FormBuilderValidators.compose([]),
                        ),
                        matForms.matEditable(
                          variable: "address",
                          displayText: "Meeting address",
                          validator: FormBuilderValidators.compose([]),
                        ),
                        matForms.matEditable(
                          variable: "agenda",
                          displayText: "Meeting agenda",
                          validator: FormBuilderValidators.compose([]),
                        ),
                        Offstage(
                          offstage: !model.showMeetingStatus,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Meeting status",
                                    style: TextStyle(
                                        fontSize:
                                            Constants.FONT_SIZE_NORMAL_TEXT,
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
                                  items: model.meetingStatusNameList,
                                  displayValue: model.selectedMeetingStatus,
                                  menuColor: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                  borderRadius: 8,
                                  player: model.setSelectedStatus),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: matForms.elevatedBtn(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            displayText: "Submit",
                            player: () {
                              print("submit");
                              if (dynamicFormKey.currentState!
                                  .saveAndValidate()) {
                                model.submit();
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
            ),
            Consumer(
              builder: (context, AddMeetingViewModel model, child) =>
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
      AddMeetingViewModel model) {
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
