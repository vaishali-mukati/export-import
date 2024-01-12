import 'dart:convert';

import 'package:agro_worlds/models/Role.dart';
import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:categorized_dropdown/categorized_dropdown.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/src/widgets/framework.dart';

class AllClientsViewModel extends BaseViewModel {
  static const String ORDER_BY_ASC = "asc";
  static const String ORDER_BY_DESC = "desc";
  static const String ORDER_BY_TIME = "time";
  static const String ORDER_BY_NAME = "name";

  String currentOrderedBy = ORDER_BY_TIME;
  String currentOrderDirection = ORDER_BY_DESC;

  MATForms matForms;
  List<Map<String, dynamic>> clientsList = [];
  List<ListItem> allProductsList = [];
  List<String> allProductsNameList = [];
  String selectedProduct = "";
  List<String> stageNameList = [
    Constants.DROPDOWN_NON_SELECT,
    "Prospect",
    "Potential",
    "Client"
  ];
  String selectedStage = Constants.DROPDOWN_NON_SELECT;
  bool isFilterApplied = false;

  List<CategorizedDropdownItem<String>> productsMap = [];

  AllClientsViewModel(BuildContext context, this.matForms) : super(context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    setBusy(true);
    await loadClients();
    await loadProducts();
    setBusy(false);
  }

  Future<void> loadClients() async {
    try {
      var response = await ApiService.dio.post("/profile/user_clients",
          queryParameters: {"id": await SharedPrefUtils.getUserId()});

      handleResponse(response);
    } catch (e) {
      showToast("Something went wrong!");
    }
  }

  void handleResponse(Response<dynamic> response) {
    if (response.statusCode == 200) {
      var result = json.decode(response.data);
      if (result["code"] == "200") {
        clientsList.clear();
        List list = result["data"];
        list.forEach((element) {
          clientsList
              .add(MATUtils.getClientDisplayInfo(element));
        });
      } else if (result["code"] == "300")
        showToast(result["message"]);
      else
        showToast("Something went wrong!");
    } else
      showToast("Something went wrong!");
  }

  Future<void> loadProducts() async {
    try {
      List<ListItem> productCategories = await ApiService.productCategories();
      List<ListItem> allProducts = [];
      await Future.forEach(productCategories, (ListItem element) async {

        List<ListItem> products = await ApiService.productsList(element.id);
        allProducts.addAll(products);
        List<SubCategorizedDropdownItem<String>> temp = [];

        String AllProductsOfCategory = "";

        products.forEach((element) {
          if(selectedProduct.isEmpty) {
            selectedProduct = element.id;
          }
          if(AllProductsOfCategory.isEmpty)
            AllProductsOfCategory = "PC${element.id}";
          else
            AllProductsOfCategory += ",${element.id}";

          temp.add(SubCategorizedDropdownItem(value: element.id, text: element.name));
        });

        productsMap.add(CategorizedDropdownItem(text: element.name, subItems: temp, value: AllProductsOfCategory));
      });


      allProductsList = allProducts;
      allProductsNameList = [Constants.DROPDOWN_NON_SELECT];
      allProductsList.forEach((element) {
        allProductsNameList.add(element.name);
      });
    } catch (e) {}
  }

  void setSelectedProduct(dynamic val) {
    if(val != null) {
      selectedProduct = val;
      notifyListeners();
    } else {
      showToast("Cannot select product category!");
    }
  }

  void setSelectedStage(dynamic val) {
    selectedStage = val;
    notifyListeners();
  }

  Future<void> filterList(String name) async {
    setBusy(true);
    try {
      Map<String, String> map = {};
      map["companyName"] = name;

      if (selectedProduct != Constants.DROPDOWN_NON_SELECT) {
        var temp = selectedProduct;
        if(selectedProduct.contains("PC")) {
          temp = temp.substring(2);
        }
        print(" =====> prod $temp");
        map["product"] = temp;
      }
      else
        map["product"] = "";

      if (selectedStage != Constants.DROPDOWN_NON_SELECT)
        map["clientStatus"] = selectedStage;
      else
        map["clientStatus"] = "";

      String? userId = await SharedPrefUtils.getUserId();
      map["userId"] = userId!;

      print(" ========> map ${map}");
      var response = await ApiService.dio
          .request("/profile/filter_user_clients", queryParameters: map);

      handleResponse(response);
    } catch (e) {
      showToast("Failed to apply filters");
    }
    setBusy(false);
  }

  Future<void> sortClients(String sortBy) async {
    setBusy(true);
    try {
      Map<String, String> map = {};

      String? userId = await SharedPrefUtils.getUserId();
      map["id"] = userId!;
      map["sortBy"] = sortBy;

      if (currentOrderedBy == sortBy) {
        if (currentOrderDirection == ORDER_BY_ASC)
          currentOrderDirection = ORDER_BY_DESC;
        else if (currentOrderDirection == ORDER_BY_DESC)
          currentOrderDirection = ORDER_BY_ASC;
      } else if (sortBy == ORDER_BY_NAME)
        currentOrderDirection = ORDER_BY_ASC;
      else
        currentOrderDirection = ORDER_BY_DESC;

      currentOrderedBy = sortBy;
      map["sortTo"] = currentOrderDirection;

      var response = await ApiService.dio
          .post("profile/user_clients", queryParameters: map);

      handleResponse(response);
    } catch (e) {
      showToast("Failed while sorting");
    }
    setBusy(false);
    currentOrderedBy = sortBy;
  }
}
