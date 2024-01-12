import 'package:categorized_dropdown/categorized_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../Constants.dart';
import 'MATUtils.dart';
import 'ModifiedLengthLimitingTextInputFormatter.dart';

class MATForms {
  BuildContext context;
  Map<String, TextEditingController> mapper;
  GlobalKey<FormBuilderState> dynamicFormKey;
  Function saveController;

  MATForms(
      {required this.context,
      required this.dynamicFormKey,
      required this.mapper,
      required this.saveController});

  GlobalKey<FormBuilderState> getDynamicKey() {
    return dynamicFormKey;
  }

  void resetData() {
    dynamicFormKey.currentState!.reset();
    mapper.forEach((k, v) {
      setVariableData(k, "");
    });
  }

  dynamic getMapper() {
    return mapper;
  }

  dynamic getVariableData(String variable) {
    if (mapper[variable] != null) {
      return mapper[variable]!.text;
    } else {
      return dynamicFormKey.currentState!.fields[variable]!.value;
    }
  }

  void setVariableData(String variable, dynamic data) {
    if (mapper[variable] != null) {
      saveController(variable, data);
    }
    try {
      RegExp dateExp = RegExp(r'^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$');
      RegExp timeExp = RegExp(r'^[0-9]{2}:[0-9]{2}\s[A|P][M]$');

      if (data is String && dateExp.hasMatch(data)) {
        DateFormat inputFormat = DateFormat("dd/MM/yyyy");
        DateTime dateTime = inputFormat.parse(data);
        if (dynamicFormKey.currentState!.fields.containsKey(variable))
          dynamicFormKey.currentState!.fields[variable]!.didChange(dateTime);
      } else if (data is String && timeExp.hasMatch(data)) {
        DateFormat inputFormat = DateFormat("hh:mm a");
        DateTime dateTime = inputFormat.parse(data);
        if (dynamicFormKey.currentState!.fields.containsKey(variable))
          dynamicFormKey.currentState!.fields[variable]!.didChange(dateTime);
      } else {
        if (dynamicFormKey.currentState!.fields.containsKey(variable))
          dynamicFormKey.currentState!.fields[variable]!.didChange(data);
      }
    } catch (e) {
      print("Some wierd thing happened, $e");
    }
  }

  Widget matCombiDropEdit({
    required String dropdownVariable,
    required bool isDropDisabled,
    required List<String> items,
    required String variable,
    required String displayText,
    required String hint,
    bool disabled = false,
    int maxLength = 1,
    TextInputType textInputType = TextInputType.text,
    FormFieldValidator? validator,
    FormFieldValidator? dropValidators,
    required void Function(dynamic)? player,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(top: 11, right: 10),
            child: Container(
              color: Color.fromARGB(225, 245, 245, 245),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: FormBuilderDropdown<dynamic>(
                  initialValue: dropdownVariable,
                  hint: Text(hint),
                  name: variable,
                  validator: dropValidators != null ? dropValidators : null,
                  items: MATUtils.simpleDropdownCovertor(items),
                  // initialValue: items.length != 0 ? items[0] : null,
                  enabled: !isDropDisabled,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: matEditable(
              variable: variable,
              displayText: displayText,
              textInputType: textInputType,
              player: player,
              disabled: disabled,
              validator: validator!,
              maxLength: maxLength),
        ),
      ],
    );
  }

  Widget matEditable({
    required String variable,
    required String displayText,
    String value = "",
    TextInputType textInputType = TextInputType.text,
    void Function(dynamic)? player,
    bool obfuscate = false,
    bool allCaps = false,
    bool disabled = false,
    bool needController = true,
    bool autocorrect = false,
    int maxLength = 80,
    int maxLine = 1,
    required FormFieldValidator<String> validator,
  }) {
    if (needController)
      mapper.putIfAbsent(variable, () => TextEditingController(text: value));
    return FormBuilderTextField(
        name: variable,
        keyboardType: textInputType,
        textCapitalization:
            allCaps ? TextCapitalization.characters : TextCapitalization.none,
        obscureText: obfuscate,
        maxLines: maxLine,
        autocorrect: autocorrect,
        decoration: InputDecoration(labelText: displayText),
        controller: needController ? mapper[variable] : null,
        readOnly: disabled,
        maxLength: maxLength,
        inputFormatters: [ModifiedLengthLimitingTextInputFormatter(maxLength)],
        validator: validator,
        onChanged: player);
  }

  Widget matAsyncDropdown({
    required String variable,
    required Future<dynamic> future,
    required Function convertor,
    required Function player,
    required String hint,
    required String displayText,
    required FormFieldValidator validator,
  }) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return FormBuilderDropdown(
          name: variable,
          items: convertor(snapshot.data),
          hint: Text(hint),
          validator: validator,
          onChanged: (val) {
            if (player != null) {
              player(val);
            }
          },
          decoration: InputDecoration(labelText: displayText),
        );
      },
    );
  }

  Widget matSimpleDropdown({
    required String variable,
    required String hint,
    required String displayText,
    required Function player,
    bool disabled = false,
    required List<String> items,
    bool isSetInitialData = false,
    required FormFieldValidator validator,
  }) {
    return FormBuilderDropdown<dynamic>(
      name: variable,
      items: MATUtils.simpleDropdownCovertor(items),
      hint: Text(hint),
      enabled: !disabled,
      initialValue: isSetInitialData
          ? items.length != 0
              ? items[0]
              : null
          : null,
      validator: validator,
      onChanged: (val) {
        if (player != null) {
          player(val);
        }
      },
      decoration: InputDecoration(labelText: displayText),
    );
  }

  Widget matSimpleColorDropdown({
    required String variable,
    required String hint,
    required String displayText,
    required Color color,
    required Function player,
    bool disabled = false,
    bool isSetInitialData = false,
    required List<String> items,
    required FormFieldValidator validator,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      color: color,
      child: FormBuilderDropdown<dynamic>(
        name: variable,
        decoration: InputDecoration(
          labelText: displayText,
          border: InputBorder.none,
        ),
        initialValue: isSetInitialData
            ? items.length != 0
                ? items[0]
                : null
            : null,
        items: MATUtils.simpleDropdownCovertor(items),
        hint: Text(hint),
        enabled: !disabled,
        validator: validator,
        onChanged: disabled
            ? null
            : (val) {
                if (player != null) {
                  player(val);
                }
              },
      ),
    );
  }

  Widget matCheckBox({
    required String variable,
    required String displayText,
    bool leadingInput = false,
    bool initialInput = false,
    bool readOnly = false,
    required Function player,
    required FormFieldValidator validators,
  }) {
    return FormBuilderCheckbox(
      initialValue: initialInput,
      name: variable,
      title: Text(
        displayText,
        style: TextStyle(fontSize: 16),
      ),
      enabled: !readOnly,
      selected: leadingInput,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      validator: validators,
      onChanged: (val) {
        if (player != null) {
          player(val);
        }
      },
    );
  }

  Widget matDatePicker({
    required String variable,
    required String displayText,
    required Function player,
    InputType inputType = InputType.date,
    String dateFormat = "dd/MM/yyyy",
    bool disabled = false,
    DateTime? lastDate,
    DateTime? startDate,
    required FormFieldValidator validator,
  }) {
    mapper.putIfAbsent(variable, () => TextEditingController());
    return FormBuilderDateTimePicker(
      name: variable,
      inputType: inputType,
      controller: mapper[variable],
      enabled: !disabled,
      firstDate: startDate,
      lastDate: lastDate,
      validator: validator,
      format: inputType == InputType.time
          ? DateFormat("hh:mm a")
          : DateFormat(dateFormat),
      decoration: InputDecoration(labelText: displayText),
      onChanged: (val) {
        if (player != null) {
          player(val);
        }
      },
    );
  }

  Widget matDateTimePicker({
    required String variable,
    required String displayText,
    required Function player,
    InputType inputType = InputType.both,
    bool disabled = false,
    DateTime? lastDate,
    DateTime? startDate,
    required FormFieldValidator validator,
  }) {
    mapper.putIfAbsent(variable, () => TextEditingController());
    return FormBuilderDateTimePicker(
      name: variable,
      inputType: inputType,
      controller: mapper[variable],
      enabled: !disabled,
      firstDate: startDate,
      lastDate: lastDate,
      validator: validator,
      format: DateFormat("yyyy-MM-dd hh:mm aaa"),
      decoration: InputDecoration(labelText: displayText),
      onChanged: (val) {
        if (player != null) {
          player(val);
        }
      },
    );
  }

  Widget matPlainText({
    required String displayText,
    String? fontWeight,
    double fontSize = 16,
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: Text(
        displayText,
        style: TextStyle(
            fontWeight:
                fontWeight == "bold" ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize),
      ),
    );
  }

  Widget matTextButton(
      {required Color textColor,
      required String displayText,
      required Function player,
      bool enable = true,
      double? width,
      Alignment alignment = Alignment.centerRight,
      FontWeight fontWeight = FontWeight.normal,
      double displayTextSize = 16,
      EdgeInsets padding = const EdgeInsets.all(8)}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Align(
        alignment: alignment,
        child: Container(
          width: width,
          child: TextButton(
            child: Padding(
              padding: padding,
              child: Text(
                displayText,
                style: TextStyle(
                    fontSize: displayTextSize,
                    color: textColor,
                    fontWeight: fontWeight),
              ),
            ),
            onPressed: enable
                ? () {
                    player();
                  }
                : null,
          ),
        ),
      ),
    );
  }

  Widget matMaterialButton({
    required Color color,
    required Color textColor,
    required String displayText,
    required Function player,
    double? width,
    Alignment alignment = Alignment.centerRight,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Align(
        alignment: alignment,
        child: Container(
          width: width,
          child: MaterialButton(
            color: color,
            child: Text(
              displayText,
              style: TextStyle(
                color: textColor,
              ),
            ),
            onPressed: () {
              player();
            },
          ),
        ),
      ),
    );
  }

  Widget matOutlineButton(
      {required Color textColor,
      required String displayText,
      required Function player,
      bool enable = true,
      Alignment alignment = Alignment.centerRight,
      FontWeight fontWeight = FontWeight.normal,
      double displayTextSize = 16,
      double borderWidth = 1,
      Color borderColor = Colors.black,
      Icon? leading,
      EdgeInsets padding = const EdgeInsets.all(0)}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Align(
        alignment: alignment,
        child: Container(
          child: TextButton(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                  TextStyle(color: textColor, fontSize: displayTextSize)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(width: borderWidth, color: borderColor)),
              ),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Offstage(
                offstage: leading == null,
                child: Padding(
                  padding: padding,
                  child: leading,
                ),
              ),
              Padding(
                padding: padding,
                child: Text(
                  displayText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: displayTextSize,
                  ),
                ),
              ),
            ]),
            onPressed: enable
                ? () {
                    player();
                  }
                : null,
          ),
        ),
      ),
    );
  }

  Widget matDivider({
    required Color color,
    required double height,
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      width: double.infinity,
      height: height,
      color: color,
    );
  }

  Widget elevatedBtn(
      {required Color color,
      required Color textColor,
      required String displayText,
      required Function player,
      double fontSize = Constants.FONT_SIZE_NORMAL_TEXT,
      EdgeInsets padding = const EdgeInsets.all(8)}) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
        ),
        child: Padding(
          padding: padding,
          child: Text(displayText),
        ),
        onPressed: () {
          player();
        });
  }

  Widget borderedDropDown(
      {required Color borderColor,
      required List<String> items,
      required String displayValue,
      Function(dynamic)? player,
      Color menuColor = Colors.black,
      FontWeight fontWeight = FontWeight.bold,
      double borderRadius = 16,
      double fontSize = Constants.FONT_SIZE_NORMAL_TEXT}) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.0,
            style: BorderStyle.solid,
            color: borderColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: DropdownButton(
            icon: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: borderColor,
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    value,
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: menuColor),
                  ),
                ),
              );
            }).toList(),
            value: displayValue,
            onChanged: player,
          ),
        ),
      ),
    );
  }

  Widget categorizedBorderedDropDown(
      {required Color borderColor,
      required List<CategorizedDropdownItem<String>> items,
      required String displayValue,
      Function(dynamic)? player,
      Color menuColor = Colors.black,
      FontWeight fontWeight = FontWeight.bold,
      double borderRadius = 16,
      double fontSize = Constants.FONT_SIZE_NORMAL_TEXT}) {
    return Container(
      height: 48,
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.0,
            style: BorderStyle.solid,
            color: borderColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 8),
        child: CategorizedDropdown(
          items: items,
          value: displayValue,
          onChanged: player,
          style: TextStyle(
              fontSize: fontSize, fontWeight: fontWeight, color: menuColor),
        ),
      ),
    );
  }
}
