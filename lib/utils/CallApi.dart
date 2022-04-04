import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:classes_app/components/CustomLoader.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:classes_app/config/BaseURL.dart';
import 'package:classes_app/config/globals.dart' as globles;
import 'package:connectivity/connectivity.dart';

class CallApi {
  Future<String> post(BuildContext context, String url, Map<String, String> map,
      bool showLoader) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      if (showLoader && !globles.isDialogVisible) {
        _showLoading(context);
      }

      var dio = Dio();
      dio.options.headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-type": "application/json",
        "X-APP-VERSION": "1.0",
        "X_APP_LANGUAGE": (globles.lang == "ar")
            ? "arabic"
            : (globles.lang == "fr") ? "french" : "english",
        "X_APP_DEVICE": "android",
        "X-API-KEY": BaseURL.ITEM_PURCHASE_CODE
      };
      FormData formData = new FormData.fromMap(map);
      final response = await dio.post(url, data: formData);
      print("Request url: $url");
      print("Request post: $map");
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON.
        print(response.data.toString());
        Map responseData = response.data;

        if (responseData.containsKey(BaseURL.RESPONSE_STATUS)) {
          if (responseData[BaseURL.RESPONSE_STATUS]) {
            var dataString = jsonEncode(responseData[BaseURL.DATA]).toString();
            print("Request response: $dataString");
            if (showLoader && globles.isDialogVisible) {
              _showLoading(context);
            }
            return dataString;
          } else {
            if (showLoader && globles.isDialogVisible) {
              _showLoading(context);
            }
            var errorString =
                jsonEncode(responseData[BaseURL.MESSAGE]).toString();
            throw errorString;
          }
        }
      } else {
        if (showLoader && globles.isDialogVisible) {
          _showLoading(context);
        }
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    }
  }

  Future<String> postFile(BuildContext context, String url, FormData formData,
      bool showLoader) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      if (showLoader && !globles.isDialogVisible) {
        _showLoading(context);
      }

      var dio = Dio();
      dio.options.headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-type": "application/json",
        "X-APP-VERSION": "1.0",
        "X_APP_LANGUAGE": (globles.lang == "ar")
            ? "arabic"
            : (globles.lang == "fr") ? "french" : "english",
        "X_APP_DEVICE": "android",
        "X-API-KEY": BaseURL.ITEM_PURCHASE_CODE
      };
      final response = await dio.post(url, data: formData);
      print("Request url: $url");
      print("Request post: ${formData.fields.toString()}");
      print("Request postFile: ${formData.files.toString()}");
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON.
        print(response.data.toString());
        Map responseData = response.data;

        if (responseData.containsKey(BaseURL.RESPONSE_STATUS)) {
          if (responseData[BaseURL.RESPONSE_STATUS]) {
            var dataString = jsonEncode(responseData[BaseURL.DATA]).toString();
            print("Request response: $dataString");
            if (showLoader && globles.isDialogVisible) {
              _showLoading(context);
            }
            return dataString;
          } else {
            if (showLoader && globles.isDialogVisible) {
              _showLoading(context);
            }
            var errorString =
                jsonEncode(responseData[BaseURL.MESSAGE]).toString();
            throw errorString;
          }
        }
      } else {
        if (showLoader && globles.isDialogVisible) {
          _showLoading(context);
        }
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    }
  }

  _showLoading(BuildContext context) {
    if (!globles.isDialogVisible) {
      globles.isDialogVisible = true;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new CustomLoader();
          }).then((val) {
        globles.isDialogVisible = false;
      });
    } else {
      if (globles.isDialogVisible) {
        Navigator.of(context).pop();
      }
    }
  }

  displaySnackBar(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: new Text(message ?? ""),
      ),
    );
  }
}
