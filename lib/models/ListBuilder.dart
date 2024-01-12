import 'Role.dart';

const LIST_TYPE_ROLE = "LIST_TYPE_ROLE";

class ListBuilder {

  List<ListItem> roleList = [];

  ListBuilder();

  ListBuilder.fromJson(Map<String, dynamic> json, String type) {
    if(json["data"] != null) {
      feedList(json["data"], type);
    }
  }

  void feedList(List<dynamic> data, String type) {
    data.forEach((element) {
      if(type == LIST_TYPE_ROLE) {
        roleList.add(ListItem.fromJson(element));
      }
    });
  }
}