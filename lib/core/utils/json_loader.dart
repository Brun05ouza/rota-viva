import 'dart:convert';

import 'package:flutter/services.dart';

class JsonLoader {
  static Future<List<dynamic>> loadList(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is List<dynamic>) {
      return decoded;
    }
    throw FormatException('Expected a JSON list in $assetPath');
  }
}
