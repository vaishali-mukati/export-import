import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/modules/register/RegisterViewModel.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static final String ROUTE_NAME = "/register";

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
    return ChangeNotifierProvider<RegisterViewModel>(
      create: (context) => RegisterViewModel(context, matForms),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Register",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 32, right: 32, top: 8),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: dynamicFormKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Consumer(
                    builder: (context, RegisterViewModel model, child) =>
                        Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Offstage(
                          offstage: model.isNameEntered,
                          child: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 56,
                              ),
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: !model.isNameEntered,
                          child: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                model.name.isNotEmpty
                                    ? model.name[0].toUpperCase()
                                    : "A".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 56),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Role",
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
                            items: model.roleNames,
                            displayValue: model.selectedRole,
                            menuColor: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            borderRadius: 8,
                            player: model.updateSelectedDepartment),
                        SizedBox(
                          height: 16,
                        ),
                        matForms.matEditable(
                          variable: "firstName",
                          displayText: "First Name",
                          textInputType: TextInputType.name,
                          player: (val) {
                            model.setName(val);
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.max(context, 80),
                          ]),
                        ),
                        matForms.matEditable(
                          variable: "lastName",
                          displayText: "Last Name",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                        ),
                        matForms.matEditable(
                          variable: "email",
                          displayText: "Email Address",
                          textInputType: TextInputType.emailAddress,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.email(context)
                          ]),
                        ),
                        matForms.matEditable(
                          variable: "contact",
                          displayText: "Contact",
                          maxLength: 15,
                          textInputType: TextInputType.phone,
                          player: (val) {
                            if(val.toString().length >=10 && val.toString().length < 15) {
                              model.isContactValid = true;
                            } else {
                              model.isContactValid = false;
                            }
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 64.0,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: matForms.elevatedBtn(
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                                displayText: "Submit",
                                player: () {
                                  if (dynamicFormKey.currentState!
                                      .saveAndValidate()) {
                                    model.submit();
                                  } else {
                                    model.showToast("Fill up all valid data");
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, RegisterViewModel model, child) =>
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
}
