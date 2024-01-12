import 'package:agro_worlds/modules/register/RegisterScreen.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'LoginViewModel.dart';

class LoginScreen extends StatelessWidget {     
  static final String ROUTE_NAME = "/login";

  final phoneNumberController = TextEditingController();
  late final BuildContext _ctx;

  Future<void> _login(LoginViewModel model) async {
    //phoneNumberController.text = "9009193666"; // for testing purpose
    if (phoneNumberController.text.isEmpty) {
      showToast('Enter Number Please');
      return;
    }
    if (phoneNumberController.text.length < 10 ||
        phoneNumberController.text.length > 15) {
      showToast('Invalid Number');
      return;
    }
    model.login(phoneNumberController.text);
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return ChangeNotifierProvider<LoginViewModel>(
      create: (context) => LoginViewModel(context),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                Image.asset(
                  Constants.AGRO_HEADER_LOGO,
                  colorBlendMode: BlendMode.color,
                ),
                Spacer(
                  flex: 1,
                ),
                Container(
                  width: double.infinity,
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        buildTextField(
                            "text", "Phone number", phoneNumberController),
                        SizedBox(
                          width: double.infinity,
                          height: 64.0,
                          child: Consumer(
                            builder: (context, LoginViewModel model, child) =>
                                Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).accentColor),
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(
                                            color: Colors.black38,
                                            fontSize: Constants
                                                .FONT_SIZE_NORMAL_TEXT)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)))),
                                child: progressButton(model.busy),
                                onPressed: () {
                                  if (!model.busy) {
                                    _login(model);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegisterScreen.ROUTE_NAME);
                            },
                            child: Text(
                              "Register here",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Constants.FONT_SIZE_BIG_TEXT),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
            Consumer(
              builder: (context, LoginViewModel model, child) =>
                  MATUtils.showLoader(
                context: context,
                isLoadingVar: false,
                size: 20,
                opacity: 0.95,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String type, String labelText, TextEditingController listener) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Consumer(
        builder: (context, LoginViewModel model, child) => TextField(
          keyboardType: TextInputType.phone,
          controller: listener,
          style: TextStyle(fontSize: 20.0, color: Color(0xff313136)),
          cursorColor: Theme.of(context).accentColor,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: labelText,
            hintStyle: TextStyle(fontSize: Constants.FONT_SIZE_NORMAL_TEXT, color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  Widget progressButton(bool busy) {
    if (busy) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Text("LOGIN");
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(_ctx).accentColor,
        textColor: Colors.white);
  }
}
