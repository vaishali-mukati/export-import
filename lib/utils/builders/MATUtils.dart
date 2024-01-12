import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Constants.dart';

class MATUtils {
  static Widget showLoader(
      {required BuildContext context,
      double size = 30.0,
      double opacity = 0.7,
      required bool isLoadingVar}) {
    return Visibility(
      visible: isLoadingVar,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Colors.white.withOpacity(opacity),
        child: SpinKitThreeBounce(
          color: Theme.of(context).accentColor,
          size: size,
        ),
      ),
    );
  }

  static void showAlertDialog(
      String message, BuildContext context, Function()? callback) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: null,
          child: AlertDialog(
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                  textColor: Theme.of(context).copyWith().accentColor,
                  child: Text("Ok"),
                  onPressed: callback),
            ],
          ),
        );
      },
    );
  }

  static List<DropdownMenuItem> simpleDropdownCovertor(List<String> options) {
    List<DropdownMenuItem> items = [];
    for (String option in options) {
      items.add(DropdownMenuItem(
        value: option,
        child: Text(option),
      ));
    }
    return items;
  }

  static Widget elevatedBtn(
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

  static Map<String, dynamic> getClientDisplayInfo(
      Map<String, dynamic> element) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("name", () {
      if (element["companyName"] != null) {
        return element["companyName"];
      } else {
        return "N/A";
      }
    });
    map.putIfAbsent("address", () {
      String address = "";
      if (element["address_line1"] != null) address = element["address_line1"];
      if (element["city"] != null) {
        if (address.isNotEmpty)
          address += ", ${element["city"]}";
        else
          address = element["city"];
      }
      if (element["state"] != null) {
        if (address.isNotEmpty)
          address += ", ${element["state"]}";
        else
          address = element["state"];
      }
      if (element["country"] != null) {
        if (address.isNotEmpty)
          address += ", ${element["country"]}";
        else
          address = element["country"];
      }
      return address;
    });

    map.putIfAbsent("clientStatus", () {
      if (element.containsKey("client_status") &&
          element["client_status"] != null) {
        return element["client_status"];
      } else if (element.containsKey("clientStatus") &&
          element["clientStatus"] != null) {
        return element["clientStatus"];
      } else {
        return "N/A";
      }
    });

    map.putIfAbsent("contact", () {
      if (element["contact"] != null) {
        return element["contact"];
      } else {
        return "N/A";
      }
    });

    map.putIfAbsent("id", () {
      if (element["id"] != null) {
        return element["id"];
      } else {
        return "N/A";
      }
    });

    return map;
  }
}
