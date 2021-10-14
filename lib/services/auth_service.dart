import 'package:concept_maps/constants/general.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AuthService {
  static String get _api => '$hostUrl/api';

  static Future<String> authorize(String login, String password) async {
    assert(login?.isNotEmpty ?? false);
    assert(password?.isNotEmpty ?? false);

    final uri = Uri.parse('$_api/user/check/$login/$password');
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result[kId];
    }
    return '';
  }
}
