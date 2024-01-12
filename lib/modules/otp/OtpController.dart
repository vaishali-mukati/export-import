import 'package:agro_worlds/network/ApiService.dart';

class OtpController {
  dynamic loginCheck(String otp, String id) async {
    var response = await ApiService.dio.get("profile/logincheck", queryParameters: {
      "otp" : otp,
      "id" : id
    });
    if (response.statusCode == 200)
      return response.data;
    else
      return {"error": "Failure", "data": response.data};
  }
}