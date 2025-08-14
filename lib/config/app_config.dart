import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApiConfig {
  static const String appName = "Ahmedia Delivery";
  // static const String baseUrl = "http://34.27.182.244:5000";
  // static const String baseUrl = "http://192.168.1.6:9000";
  // static const String baseUrl = "http://34.93.245.25:8080";
  static const String baseUrl = "http://10.243.146.183:4075";
  // static const String baseUrl = "http://192.168.29.118:4075";
  static const String loginAPI = "/delivery-agents/login";

  static List<DropdownMenuItem<String>>? yearPicker = List.generate(
    200,
    (index) => DropdownMenuItem<String>(
      value: (1900 + index).toString(),
      child: Text(
        (1900 + index).toString(),
        style: const TextStyle(fontSize: 15),
      ),
    ),
  );
}

String validateAndSave(actualDate) {
  DateTime parseDate = DateFormat(
    "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
  ).parse(actualDate!);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}
