import 'package:agro_worlds/models/ListBuilder.dart';

class ListItem {
  late String id;
  late String name;

  ListItem({required this.id, required this.name});

  ListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}