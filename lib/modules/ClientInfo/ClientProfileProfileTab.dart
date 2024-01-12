import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'ClientProfileViewModel.dart';

class ClientProfileProfileTab extends StatelessWidget {
  final ClientProfileViewModel model;

  ClientProfileProfileTab(this.model);

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
                color: Colors.black12,
              ),
              Offstage(
                offstage: model.isPotential,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 16, top: 16, bottom: 8, right: 16),
                  child: MATUtils.elevatedBtn(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      displayText: "Convert to Potential",
                      player: () {
                        model.convertToPotential();
                      }),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
                child: ExpansionPanelList(
                    animationDuration: Duration(seconds: 1),
                    elevation: 0,
                    dividerColor: Colors.black12,
                    expansionCallback: (int index, bool isExpanded) {
                      model.setExpandedTile(index, !isExpanded);
                    },
                    children: [
                      createExpansionTile(
                        model.data[0],
                        FormBuilder(
                          key: model.data[0].matForms.dynamicFormKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(children: [
                            model.data[0].matForms.matEditable(
                              variable:
                                  ClientProfileViewModel.COMPANY_DETAIL_EMAIL,
                              displayText: "Email Address",
                              textInputType: TextInputType.emailAddress,
                              player: (val) {},
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.email(context)]),
                            ),
                            model.data[0].matForms.matEditable(
                              variable:
                                  ClientProfileViewModel.COMPANY_DETAIL_CONTACT,
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
                            model.data[0].matForms.matEditable(
                              variable: ClientProfileViewModel
                                  .COMPANY_DETAIL_ADD_LINE_1,
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
                            model.data[0].matForms.borderedDropDown(
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
                            model.data[0].matForms.borderedDropDown(
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
                            model.data[0].matForms.borderedDropDown(
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
                            model.data[0].matForms.matEditable(
                              variable:
                                  ClientProfileViewModel.COMPANY_DETAIL_PINCODE,
                              displayText: "Pin code",
                              textInputType: TextInputType.name,
                              player: (val) {},
                              validator: FormBuilderValidators.compose([]),
                            ),
                            model.data[0].matForms.matEditable(
                              variable: ClientProfileViewModel
                                  .COMPANY_DETAIL_LANDLINE_NUMBER,
                              displayText: "Landline Number",
                              textInputType: TextInputType.name,
                              player: (val) {},
                              validator: FormBuilderValidators.compose([]),
                            ),
                            model.data[0].matForms.matEditable(
                              variable:
                                  ClientProfileViewModel.COMPANY_DETAIL_WEBSITE,
                              displayText: "Website",
                              textInputType: TextInputType.name,
                              player: (val) {},
                              validator: FormBuilderValidators.compose([]),
                            ),
                            model.data[0].matForms.matEditable(
                              variable: ClientProfileViewModel
                                  .COMPANY_DETAIL_SOCIAL_HANDLES,
                              displayText: "Social handles",
                              textInputType: TextInputType.name,
                              player: (val) {},
                              validator: FormBuilderValidators.compose([]),
                            ),
                            model.data[0].matForms.matEditable(
                              variable: ClientProfileViewModel
                                  .COMPANY_DETAIL_BUSINESS_EMAIL,
                              displayText: "Business email",
                              textInputType: TextInputType.name,
                              player: (val) {},
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.email(context),
                              ]),
                            ),
                            model.data[0].matForms.matEditable(
                              variable: ClientProfileViewModel
                                  .COMPANY_DETAIL_BUSINESS_POC_1,
                              displayText: "Business POC Name 1",
                              textInputType: TextInputType.name,
                              player: (val) {},
                              validator: FormBuilderValidators.compose([]),
                            ),
                            model.data[0].matForms.matEditable(
                              variable: ClientProfileViewModel
                                  .COMPANY_DETAIL_BUSINESS_POC_2,
                              displayText: "Business POC Name 2",
                              textInputType: TextInputType.name,
                              player: (val) {},
                              validator: FormBuilderValidators.compose([]),
                            ),
                            model.data[0].matForms.matEditable(
                              variable: ClientProfileViewModel
                                  .COMPANY_DETAIL_BUSINESS_NUMBER,
                              displayText: "POC business number",
                              textInputType: TextInputType.phone,
                              player: (val) {
                                if (val.toString().length >= 10 &&
                                    val.toString().length < 15) {
                                  model.isBusinessContactValid = true;
                                } else {
                                  model.isBusinessContactValid = false;
                                }
                              },
                              validator: FormBuilderValidators.compose([]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Client source type",
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
                            model.data[0].matForms.borderedDropDown(
                              borderColor: Theme.of(context).primaryColor,
                              items: model.clientSourceTypeNameList,
                              displayValue: model.selectedClientSourceType,
                              menuColor: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.normal,
                              fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                              borderRadius: 8,
                              player: model.setSelectedClientSourceType,
                            ),
                            model.data[0].matForms.matTextButton(
                              textColor: Theme.of(context).primaryColor,
                              displayText: "Save Company Details",
                              player: () {
                                if (model.data[0].matForms.dynamicFormKey
                                    .currentState!
                                    .saveAndValidate()) {
                                  model.saveCompanyDetails();
                                } else {
                                  model.showToast("Fill up all valid data");
                                }
                              },
                            )
                          ]),
                        ),
                      ),
                      createExpansionTile(
                        model.data[1],
                        FormBuilder(
                          key: model.data[1].matForms.dynamicFormKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            children: [
                              model.data[1].matForms.matEditable(
                                variable:
                                    ClientProfileViewModel.CONTACT_PERSON_NAME,
                                displayText: "Name",
                                textInputType: TextInputType.name,
                                player: (val) {},
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context),
                                ]),
                              ),
                              model.data[1].matForms.matEditable(
                                variable: ClientProfileViewModel
                                    .CONTACT_PERSON_DESIGNATION,
                                displayText: "Designation",
                                textInputType: TextInputType.name,
                                player: (val) {},
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context),
                                ]),
                              ),
                              model.data[1].matForms.matTextButton(
                                textColor: Theme.of(context).primaryColor,
                                displayText: "Save Person Details",
                                player: () {
                                  if (model.data[1].matForms.dynamicFormKey
                                      .currentState!
                                      .saveAndValidate()) {
                                    model.savePersonDetails();
                                  } else {
                                    model.showToast("Fill up all valid data");
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      createExpansionTile(
                        model.data[2],
                        Column(
                          children: [
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
                            model.data[2].matForms.borderedDropDown(
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
                                      if (val != null) {
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
                            model.data[2].matForms.matTextButton(
                                textColor: Theme.of(context).primaryColor,
                                displayText: "Save Product Details",
                                player: model.saveProductDetails)
                          ],
                        ),
                      ),
                      createExpansionTile(
                        model.data[3],
                        FormBuilder(
                          key: model.data[3].matForms.dynamicFormKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            children: [
                              model.data[3].matForms.matEditable(
                                variable: ClientProfileViewModel
                                    .CORPORATE_KEY_MANAGEMENT_PERSONAL,
                                displayText: "Key Management personnel",
                                textInputType: TextInputType.name,
                                player: (val) {},
                                validator: FormBuilderValidators.compose([]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Client Business Type",
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
                              model.data[3].matForms.borderedDropDown(
                                borderColor: Theme.of(context).primaryColor,
                                items: model.clientBusinessTypeNameList,
                                displayValue: model.selectedClientBusinessType,
                                menuColor: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                borderRadius: 8,
                                player: model.setSelectedBusinessType,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Business Size",
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
                              model.data[3].matForms.borderedDropDown(
                                borderColor: Theme.of(context).primaryColor,
                                items: model.businessSizeNameList,
                                displayValue: model.selectedBusinessSize,
                                menuColor: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                borderRadius: 8,
                                player: model.setSelectedBusinessSize,
                              ),
                              model.data[3].matForms.matEditable(
                                variable:
                                    ClientProfileViewModel.CORPORATE_TEAM_SIZE,
                                displayText: "Team Size",
                                textInputType: TextInputType.number,
                                player: (val) {},
                                validator: FormBuilderValidators.compose([]),
                              ),
                              model.data[3].matForms.matEditable(
                                variable: ClientProfileViewModel
                                    .CORPORATE_BUSINESS_TURNOVER_APX,
                                displayText: "Business Turnover Apprx",
                                textInputType: TextInputType.number,
                                player: (val) {},
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context),
                                ]),
                              ),
                              model.data[3].matForms.matEditable(
                                variable: ClientProfileViewModel
                                    .CORPORATE_COMPANY_INCORP_DETAILS,
                                displayText: "Company Incorporation Detail",
                                textInputType: TextInputType.name,
                                player: (val) {},
                                validator: FormBuilderValidators.compose([]),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Business Set up's /Demographic details",
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
                              model.data[3].matForms.borderedDropDown(
                                borderColor: Theme.of(context).primaryColor,
                                items: model.businessDemographicDetailsNameList,
                                displayValue:
                                    model.selectedBusinessDemographicDetails,
                                menuColor: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                borderRadius: 8,
                                player: model.setSelectedBusinessDemographic,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Business Interest (High, moderate, low)",
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
                              model.data[3].matForms.borderedDropDown(
                                borderColor: Theme.of(context).primaryColor,
                                items: model.businessInterestNameList,
                                displayValue: model.selectedBusinessInterest,
                                menuColor: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                borderRadius: 8,
                                player: model.setSelectedBusinessInterest,
                              ),
                              model.data[3].matForms.matEditable(
                                variable: ClientProfileViewModel
                                    .CORPORATE_BUSINESS_REF,
                                displayText: "Business References",
                                textInputType: TextInputType.name,
                                player: (val) {},
                                validator: FormBuilderValidators.compose([]),
                              ),
                              model.data[3].matForms.matEditable(
                                variable: ClientProfileViewModel
                                    .CORPORATE_ADDITIONAL_DETAILS,
                                displayText: "Additional details",
                                textInputType: TextInputType.name,
                                player: (val) {},
                                validator: FormBuilderValidators.compose([]),
                              ),
                              model.data[3].matForms.matTextButton(
                                textColor: Theme.of(context).primaryColor,
                                displayText: "Save Corporate Details",
                                player: () {
                                  if (model.data[3].matForms.dynamicFormKey
                                      .currentState!
                                      .saveAndValidate()) {
                                    model.saveCorporateDetails();
                                  } else {
                                    model.showToast("Fill up all valid data");
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ExpansionPanel createExpansionTile(Item item, Widget body) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(
            item.headerValue,
            style: TextStyle(color: Theme.of(model.context).primaryColor),
          ),
        );
      },
      body: body,
      isExpanded: item.isExpanded,
    );
  }
}
