import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'AddProspectViewModel.dart';

class AddProspect extends StatelessWidget {
  static final String ROUTE_NAME = "/AddProspect";

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

    return ChangeNotifierProvider<AddProspectViewModel>(
      create: (context) => AddProspectViewModel(context, matForms),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Add a prospect",
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
              padding: EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Consumer(
                builder: (context, AddProspectViewModel model, child) =>
                    SingleChildScrollView(
                  child: FormBuilder(
                    key: dynamicFormKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
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
                          height: 32,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Text(
                              "Business details",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        matForms.matEditable(
                          variable: "companyName",
                          displayText: "Company name",
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
                          variable: "email",
                          displayText: "Email Address",
                          textInputType: TextInputType.emailAddress,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.email(context)
                          ]),
                        ),
                        matForms.matEditable(
                          variable: "contact",
                          displayText: "Contact number",
                          textInputType: TextInputType.phone,
                          maxLength: 14,
                          player: (val) {
                            if (val.toString().length >= 10 &&
                                val.toString().length < 15) {
                              model.isContactValid = true;
                            } else {
                              model.isContactValid = false;
                            }
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                        ),
                        matForms.matEditable(
                          variable: "addressLine1",
                          displayText: "Address (line 1)",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Country",
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
                            items: model.countriesNameList,
                            displayValue: model.selectedCountry,
                            menuColor: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                            borderRadius: 8,
                            player: model.setSelectedCountry),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "State",
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
                            items: model.statesNameList,
                            displayValue: model.selectedState,
                            menuColor: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                            borderRadius: 8,
                            player: model.setSelectedState),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "City",
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
                          items: model.citiesNameList,
                          displayValue: model.selectedCity,
                          menuColor: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                          borderRadius: 8,
                          player: model.setSelectedCity,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        matForms.matEditable(
                          variable: "pincode",
                          displayText: "Pin code",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                          ]),
                        ),
                        matForms.matEditable(
                          variable: "landLineNumber",
                          displayText: "Landline Number",
                          textInputType: TextInputType.phone ,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                          ]),
                        ),
                        matForms.matEditable(
                          variable: "website",
                          displayText: "Website",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                          ]),
                        ),
                        matForms.matEditable(
                          variable: "socialHandles",
                          displayText: "Social handles",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                          ]),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              "Contact Person",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        matForms.matEditable(
                          variable: "contactPersonName",
                          displayText: "Name",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                        ),
                        matForms.matEditable(
                          variable: "contactPersonDesignation",
                          displayText: "Designation",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              "Product details",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Product Category",
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
                          items: model.productsCategoryNameList,
                          displayValue: model.selectedProductCategory,
                          menuColor: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                          borderRadius: 8,
                          player: model.setSelectedProductCategory,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ListView.builder(
                          itemCount: model.productsNameList.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, int index) {
                            return Row(children: [
                              Checkbox(
                                value: model.selectedProductIds.containsKey(
                                        model.productsNameList[index])
                                    ? model.selectedProductIds[
                                        model.productsNameList[index]]
                                    : false,
                                onChanged: (val) {
                                  if(val != null) {
                                    model.setSelectedProduct(index, val);
                                  }
                                },
                              ),
                              Text(model.productsNameList[index])
                            ]);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: matForms.elevatedBtn(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            displayText: "Submit",
                            player: () {
                              if (dynamicFormKey.currentState!
                                  .saveAndValidate()) {
                                model.submit();
                              } else {
                                model.showToast("Fill up all valid data");
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, AddProspectViewModel model, child) =>
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
