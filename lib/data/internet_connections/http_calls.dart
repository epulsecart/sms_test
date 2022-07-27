import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../helpers/shared_pref.dart';
import 'api_helper.dart';
import 'api_settings.dart';

class HttpConnections {
  static Future postCall(var data, String subUrl) async {
    ApiFunNames apiFunNames = ApiFunNames();
    var uri = Uri.parse("${apiFunNames.url}$subUrl");
    String? token = await SharedPrefHelper.getString('token');
    Map<String, String>? header = {"": ""};
    if (token != null) {
      header = ApiHelper.getHeader(token);
    } else {
      header = ApiHelper.noUserHeader();
    }
    try {
      print("calling $uri with $data");
      var body = json.encode(data);
      print("calling $uri with $body");
      final response = await http.post(uri, body: body, headers: header);
      print("decoded reponse is ${response.body}");
      final decodedData = json.decode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        Map returnData = {
          "codedData": response.body,
          "decodedData": decodedData
        };
        return returnData;
      } else {
        return {"decodedData": decodedData};
      }
    } catch (e) {
      print("post in sub URl $subUrl got an issue $e");
    }
  }

  static Future patchCalls(var data, String subUrl) async {
    ApiFunNames apiFunNames = ApiFunNames();
    var uri = Uri.parse("${apiFunNames.url}$subUrl");
    String? token = await SharedPrefHelper.getString('token');
    Map<String, String>? header = {"": ""};
    if (token != null) {
      header = ApiHelper.getHeader(token);
    }
    try {
      var body = json.encode(data);
      final response = await http.patch(uri, body: body, headers: header);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        Map returnData = {
          "codedData": response.body,
          "decodedData": decodedData
        };
        return returnData;
      }
    } catch (e) {
      print("patch in sub URl $subUrl got an issue $e");
    }
  }

  static Future getCall(Map<String, dynamic> subUrl, String sUrl,
      {BuildContext? context, String? urll}) async {
    try {
      // ApiFunNames apiFunNames = ApiFunNames();

      String url = '';
      if (urll != null) {
        url = urll;
      }
      if (context != null) {
        url = Provider.of<ApiFunNames>(context, listen: false).url;
      }
      var uri = Uri.http(url, sUrl, subUrl);
      String? token = await SharedPrefHelper.getString('token');
      Map<String, String>? header = {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive'
      };
      if (token != null || token == null) {
        header = ApiHelper.getHeader(token);
      }
      print("calling now this uri $uri");
      final response = await http.get(uri);
      print(
          "get from $uri code is ${response.statusCode} response is ${response.body} ");
      if (response.statusCode == 201 || response.statusCode == 200) {
        List body = json.decode(response.body);
        Map returnData = {"decodedData": body, "encodedData": response.body};
        return returnData;
      } else {
        print(
            "there is a problem getting data from $uri statuc code is ${response.body}");
      }
    } catch (e) {
      print("get in sub URl $subUrl got an issue $e");
    }
  }
}
