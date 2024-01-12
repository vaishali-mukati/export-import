import 'package:agro_worlds/providers/FlowDataProvider.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BaseViewModel extends ChangeNotifier {
  bool busy = false;
  BuildContext context;
  FlowDataProvider flowDataProvider;

  BaseViewModel(this.context) : flowDataProvider = Provider.of(context, listen: false);

  setBusy(bool isBusy) {
    busy = isBusy;
    notifyListeners();
  }

    void showToast(String msg) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.white);
    }
}