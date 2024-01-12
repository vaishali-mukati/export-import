import 'package:agro_worlds/network/ApiService.dart';

class LoginController {
  dynamic login(String phone) async {
    var response =
        await ApiService.dio.post("profile/login", queryParameters: {"phone": phone});
    if (response.statusCode == 200)
      return response.data;
    else
      return {"error": "Failure", "data": response.data};
  }
}
