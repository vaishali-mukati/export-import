import 'dart:convert';

import 'package:agro_worlds/models/Role.dart';
import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/addProspect/AddProspectSuccess.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddProspectViewModel extends BaseViewModel {
  bool isNameEntered = false;
  String name;

  List<String> clientTypes;
  String selectedClientType;

  List<String> rolesNameList;
  List<ListItem> rolesList;
  String selectedRole;

  List<String> countriesNameList;
  List<ListItem> countriesList;
  String selectedCountry;

  List<String> statesNameList;
  List<ListItem> statesList;
  String selectedState;

  List<String> citiesNameList;
  List<ListItem> citiesList;
  String selectedCity;

  List<String> productsCategoryNameList;
  List<ListItem> productsCategoryList;
  String selectedProductCategory;

  List<String> productsNameList;
  List<ListItem> productsList;
  Map<String, bool> selectedProductIds = Map();

  MATForms matForms;
  bool isContactValid = false;
  bool isStateSelected = false;
  bool isCountrySelected = false;

  AddProspectViewModel(BuildContext context, this.matForms)
      : clientTypes = [],
        statesList = [],
        statesNameList = [Constants.DROPDOWN_NON_SELECT],
        countriesNameList = [Constants.DROPDOWN_NON_SELECT],
        countriesList = [],
        selectedCountry = Constants.DROPDOWN_NON_SELECT,
        citiesList = [],
        citiesNameList = [Constants.DROPDOWN_NON_SELECT],
        rolesList = [],
        productsCategoryList = [],
        productsCategoryNameList = [Constants.DROPDOWN_NON_SELECT],
        selectedProductCategory = Constants.DROPDOWN_NON_SELECT,
        productsList = [],
        productsNameList = [],
        rolesNameList = [Constants.DROPDOWN_NON_SELECT],
        selectedRole = Constants.DROPDOWN_NON_SELECT,
        selectedCity = Constants.DROPDOWN_NON_SELECT,
        selectedState = Constants.DROPDOWN_NON_SELECT,
        selectedClientType = 'Prospect',
        name = "",
        super(context) {
    if (flowDataProvider.user.userRole.toString().toLowerCase() ==
        Constants.ROLE_BDE) {
      clientTypes = ['Prospect'];
    } else if (flowDataProvider.user.userRole.toString().toLowerCase() ==
        Constants.ROLE_BDM) {
      clientTypes = ['Prospect', 'Potential'];
    }
    asyncInit();
  }

  Future<void> asyncInit() async {
    try {
      setBusy(true);

      countriesNameList.clear();
      countriesList = await ApiService.countriesList();
      countriesNameList.add(Constants.DROPDOWN_NON_SELECT);
      countriesList.forEach((element) {
        countriesNameList.add(element.name);
      });
      countriesNameList.sort();
      selectedCountry = countriesNameList[0];

      productsCategoryNameList.clear();
      productsCategoryList = await ApiService.productCategories();
      productsCategoryNameList.add(Constants.DROPDOWN_NON_SELECT);
      productsCategoryList.forEach((element) {
        productsCategoryNameList.add(element.name);
      });
      productsCategoryNameList.sort();
      selectedProductCategory = productsCategoryNameList[0];

      rolesList = await ApiService.rolesList();
      print(rolesList.length);
      rolesNameList.add(Constants.DROPDOWN_NON_SELECT);
      rolesList.forEach((element) {
        print(element.name);
        if (element.name.toString().toLowerCase().contains("importer") ||
            element.name.toString().toLowerCase().contains("exporter"))
          rolesNameList.add(element.name);
      });
      selectedRole = rolesNameList[0];

      setBusy(false);
    } catch (e) {
      setBusy(false);
    }
  }

  void setSelectedRole(dynamic role) async {
    selectedRole = role;
    notifyListeners();
  }

  void setSelectedCountry(dynamic country) async {
    selectedCountry = country;
    print("state $country");
    if (country.toString() == Constants.DROPDOWN_NON_SELECT) {
      isCountrySelected = false;
    } else {
      isCountrySelected = true;
      setBusy(true);
      await loadStates(country);
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> loadStates(String country) async {
    try {
      ListItem mCountry =
          countriesList.firstWhere((element) => element.name == country);
      statesList = await ApiService.statesList(mCountry.id);
      statesNameList.clear();
      statesNameList.add(Constants.DROPDOWN_NON_SELECT);
      statesList.forEach((element) {
        statesNameList.add(element.name);
      });
      statesNameList.sort();
      selectedState = statesNameList[0];
    } catch (e) {
      print("catch $e");
    }
  }

  void setSelectedState(dynamic state) async {
    selectedState = state;
    print("state $state");
    if (state.toString() == Constants.DROPDOWN_NON_SELECT) {
      isStateSelected = false;
    } else {
      isStateSelected = true;
      setBusy(true);
      await loadCities(state);
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> loadCities(String state) async {
    try {
      ListItem mState =
          statesList.firstWhere((element) => element.name == state);
      citiesList = await ApiService.citiesList(mState.id);
      citiesNameList.clear();
      citiesNameList.add(Constants.DROPDOWN_NON_SELECT);
      citiesList.forEach((element) {
        citiesNameList.add(element.name);
      });
      citiesNameList.sort();
      selectedCity = citiesNameList[0];
    } catch (e) {
      print("catch $e");
    }
  }

  void setSelectedCity(dynamic city) async {
    selectedCity = city;
    notifyListeners();
  }

  void setSelectedProductCategory(dynamic product) async {
    selectedProductCategory = product;
    if (product.toString() != Constants.DROPDOWN_NON_SELECT) {
      setBusy(true);
      await loadProducts(product);
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> loadProducts(String productType) async {
    try {
      ListItem mProduct = productsCategoryList
          .firstWhere((element) => element.name == productType);
      productsList = await ApiService.productsList(mProduct.id);
      productsNameList.clear();
      productsList.forEach((element) {
        productsNameList.add(element.name);
        selectedProductIds.putIfAbsent(element.name, () => false);
      });
      productsNameList.sort();

      print(productsNameList);
    } catch (e) {
      print("catch $e");
    }
  }

  void setSelectedProduct(int index, bool isSelected) {
    if (selectedProductIds.containsKey(productsNameList[index])) {
      selectedProductIds[productsNameList[index]] = isSelected;
      notifyListeners();
    }
  }

  void submit() async {
    if (!isContactValid) {
      showToast("Enter valid Contact");
      return;
    }
    if(selectedCountry == Constants.DROPDOWN_NON_SELECT) {
      showToast("Select a country");
      return;
    }
    if(selectedState == Constants.DROPDOWN_NON_SELECT) {
      showToast("Select a state");
      return;
    }
    if(selectedCity == Constants.DROPDOWN_NON_SELECT) {
      showToast("Select a city");
      return;
    }
    if(selectedProductCategory == Constants.DROPDOWN_NON_SELECT) {
      showToast("Select a product category");
      return;
    }
    if (matForms.dynamicFormKey.currentState != null) {
      try {
        setBusy(true);
        var formData = matForms.dynamicFormKey.currentState!.value;
        var reqData = Map<String, dynamic>();
        formData.forEach((key, value) {
          reqData[key] = value;
        });
        String? id = await SharedPrefUtils.getUserId();
        reqData.putIfAbsent("id", () => id);

        ListItem mCountry = countriesList.firstWhere((element) => element.name == selectedCountry);
        ListItem mState = statesList.firstWhere((element) => element.name == selectedState);
        ListItem mCity = citiesList.firstWhere((element) => element.name == selectedCity);
        ListItem mProductCategory = productsCategoryList.firstWhere((element) => element.name == selectedProductCategory);

        reqData.putIfAbsent("country", () => mCountry.id);
        reqData.putIfAbsent("state", () => mState.id);
        reqData.putIfAbsent("city", () => mCity.id);
        reqData.putIfAbsent("productCategory", () => mProductCategory.id);

        String mSelectedProductIds = "";
        selectedProductIds.forEach((key, value) {
          if(value) {
            var thisProduct = productsList.firstWhere((element) => key == element.name);
            if(mSelectedProductIds.isEmpty)
              mSelectedProductIds = thisProduct.id;
            else
              mSelectedProductIds += ","+thisProduct.id;
          }
        });

        if(mSelectedProductIds.isNotEmpty) {
          reqData.putIfAbsent("products", () => mSelectedProductIds);
        } else {
          showToast("Select at least one product");
          setBusy(false);
          return;
        }
        print(reqData);
        await addClientApiCall(reqData);

        setBusy(false);
      } catch (e) {
        showToast("Something went wrong!");
        print("error => $e");
        setBusy(false);
      }
    }
  }

  void setSelectedClientType(val) {
    selectedClientType = val;
    notifyListeners();
  }

  void setName(String name) {
    bool shouldNotify = false;
    if ((this.name.isEmpty && name.isNotEmpty) ||
        (this.name.isNotEmpty && name.isEmpty)) shouldNotify = true;

    this.name = name;

    if (name.isNotEmpty)
      isNameEntered = true;
    else if (name.isEmpty) isNameEntered = false;
    if (shouldNotify) notifyListeners();
  }

  Future<void> addClientApiCall(Map<String, dynamic> formData) async {
    var response =
        await ApiService.dio.post("profile/add_prospect", queryParameters: {
      "companyName": formData["companyName"],
      "email": formData["email"],
      "contact": formData["contact"],
      "addressLine1": formData["addressLine1"],
      "pincode": formData["pincode"],
      "landLineNumber": formData["landLineNumber"],
      "website": formData["website"],
      "socialHandles": formData["socialHandles"],
      "contactPersonName": formData["contactPersonName"],
      "contactPersonDesignation": formData["contactPersonDesignation"],
      "id": "" + formData["id"],
      "country": formData["country"],
      "state": formData["state"],
      "city": formData["city"],
      "productCategory": formData["productCategory"],
      "products": formData["products"]
    });

    print(response.requestOptions.uri);
    if (response.statusCode == 200) {
      var result = json.decode(response.data);
      if (result["code"] == "300")
        showToast(result["message"]);
      else if (result["code"] == "200")
        Navigator.pushReplacementNamed(context, AddProspectSuccess.ROUTE_NAME);
      else
        showToast("Something went Wrong!");
    } else {
      showToast("Something went Wrong!");
    }
  }
}
