import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<dynamic>> loadJsonData(String assetPath) async {
  final String response = await rootBundle.loadString(assetPath);
  final data = json.decode(response);
  return data;
}
