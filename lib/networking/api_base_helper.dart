// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:foodie_delivery/networking/shared_service.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
// import 'shared_service.dart';

class ApiBaseHelper {
  final String _baseUrl = ApiConfig.baseUrl;
  Future<dynamic> get(String url) async {
    print('Api Get, url  $_baseUrl$url');
    var token = await SharedService.getToken();
    Map<String, String> requestHeader = {'Authorization': 'Bearer ${token!}'};
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
      );

      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> postjson(String url, dynamic body) async {
    print('Api Post, url $url');
    Map<String, String> requestHeader = {'Content-type': 'application/json'};
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
        body: jsonEncode(body),
      );
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> post(String url, dynamic body) async {
    print('Api Post, url $url');
    var token = await SharedService.getToken();
    Map<String, String> requestHeader = {'Authorization': 'Bearer ${token!}'};

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
        body: body,
        encoding: Encoding.getByName("utf-8"),
      );
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> postJsonWithToken(String url, dynamic body) async {
    print('Api Post, url $url');
    var token = await SharedService.getToken();
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer ${token!}',
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
        body: body,
        encoding: Encoding.getByName("utf-8"),
      );
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> getWithoutToken(String url) async {
    print('Api Get, url  $_baseUrl$url');
    try {
      final response = await http.get(Uri.parse('$_baseUrl$url'));
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> postMultipart(
    String url,
    dynamic body,
    List<http.MultipartFile> multiparts,
  ) async {
    print('Api Post, url $url');
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$url'));
      print('body ::::: $body');
      Map<String, String> data = Map<String, String>.from(body);
      print(data);
      request.fields.addAll(data);
      request.files.addAll(multiparts);

      var streamedResponse = await request.send();
      print("response : ${streamedResponse.statusCode}");
      var response = await http.Response.fromStream(streamedResponse);
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> putjsonStatus(String url) async {
    print('Api Put, url $url');
    var token = await SharedService.getToken();
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer ${token!}',
      'Content-type': 'application/json',
    };
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
      );
      // print(response);
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> putMultipart(
    String url,
    dynamic body,
    List<http.MultipartFile> multiparts,
  ) async {
    print('Api Post, url $url');
    var token = await SharedService.getToken();
    Map<String, String> requestHeader = {'Authorization': 'Bearer ${token!}'};
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$_baseUrl$url'));

      request.headers.addAll(requestHeader);
      Map<String, String> data = Map<String, String>.from(body);
      request.fields.addAll(data);
      request.files.addAll(multiparts);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> put(String url, dynamic body) async {
    print('Api Put, url $url');
    var token = await SharedService.getToken();
    Map<String, String> requestHeader = {'Authorization': 'Bearer ${token!}'};
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
        body: body,
      );
      print('api put.');
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> putjson(String url, dynamic body) async {
    print('Api Put, url $url');
    var token = await SharedService.getToken();
    print("token $token");
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer ${token!}',
      "Content-Type": "application/json",
    };
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
        body: body,
      );
      print('api put.');
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> putJsonEncode(String url, dynamic body) async {
    print('Api Put, url $url');
    var token = await SharedService.getToken();
    print(token);
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer ${token!}',
      "Content-Type": "application/json",
    };

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
        body: jsonEncode(body),
      );
      print('api put.');
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> delete(String url) async {
    print('Api delete, url $url');
    var token = await SharedService.getToken();
    Map<String, String> requestHeader = {'Authorization': 'Bearer ${token!}'};

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
      );
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> putjsonwithjsonEncode(String url, dynamic body) async {
    print('Api Put, url $url');
    var token = await SharedService.getToken();
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer ${token!}',
      'Content-type': 'application/json',
    };

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
        body: jsonEncode(body),
      );
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }

  Future<dynamic> putJsonWithoutToken(String url, dynamic body) async {
    print('Api Put, url $url');
    Map<String, String> requestHeader = {'Content-type': 'application/json'};
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$url'),
        headers: requestHeader,
        body: jsonEncode(body),
      );
      return responseStatuscode(response);
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: $e');
    }
  }
}

dynamic responseStatuscode(http.Response response) {
  switch (response.statusCode) {
    case 200:
      print(
        "statusCode : ${response.statusCode} OK - the request was successful and the server has returned data as requested.",
      );
      return response;
    case 201:
      print(
        "statusCode : ${response.statusCode} Created - the request was successful and a new resource has been created.",
      );
      return response;
    case 400:
      print(
        " statusCode : ${response.statusCode} Bad Request - the request was malformed or invalid.",
      );
      return response;
    case 401:
      print(
        "statusCode : ${response.statusCode} Unauthorized - the request requires authentication or authorization.",
      );
      return response;
    case 404:
      print(
        "statusCode : ${response.statusCode} Not Found - the requested resource could not be found on the server.",
      );
      return response;
    case 500:
      print("statusCode : ${response.statusCode} Internal Server Error");
      return response;
  }
}
