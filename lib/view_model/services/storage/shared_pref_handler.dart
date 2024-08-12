import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHandler {
  Future<bool> isExists(String inputString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var check = prefs.getString(inputString);
    return check == null ? false : true;
  }

  deleteUser(String inputString) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = prefs.getString('currentUser') ?? '';
    // print(jsonDecode(response));
    // print(
    //   User().fromMap(jsonDecode(response)).toString() + "+++++++++++");
    return jsonDecode(response);
  }

  setCurrentUser(Map<String, dynamic> myData) async {
    debugPrint(myData.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var data = User().  toLocalMap(myData);
    String rawJson = jsonEncode(myData);
    debugPrint(rawJson);
    final result = await prefs.setString('currentUser', rawJson);
    debugPrint("List is saved $result");
  }

  setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final result = await prefs.setString('token', token);
    debugPrint("token saved$result");
  }

  setDisPopUp(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final result = await prefs.setString('popUp', token);
    debugPrint("popUp saved$result");
  }

  getDisPopUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final result = prefs.getString('popUp');
    return result ?? "";
  }

  removeDisPopUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('popUp');
  }

  setCart(int cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final result = await prefs.setInt('cart', cart);
    debugPrint("token saved$result");
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = prefs.getString('token') ?? '';
    // print(jsonDecode(response));
    // print(
    //   User().fromMap(jsonDecode(response)).toString() + "+++++++++++");
    return response;
  }

  getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = prefs.getInt('cart') ?? 0;
    // print(jsonDecode(response));
    // print(
    //   User().fromMap(jsonDecode(response)).toString() + "+++++++++++");
    return response;
  }
}
