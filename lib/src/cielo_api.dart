import 'dart:convert';

import 'package:cielo_sop_flutter/cielo_sop_flutter.dart';
import 'package:http/http.dart' as http;


typedef CieloApiCallback = void Function(dynamic response);

class CieloApi {

  const CieloApi._();

  /// Sends a request to the Cielo Silent Order Post API.
  /// [accessToken] is the access token needed to complete the request. It must be obtained by your backend application via OAuth2.
  /// [options] is optional. If not set, it will fallback to initialized options.
  /// Throws [CieloAPIException] if Cielo returns failure.
  /// Learn more: https://developercielo.github.io/en/manual/cielo-ecommerce#integration193
  static dynamic sendRequest({
    required String accessToken,
    required CieloSOPCard card,
    required CieloSOPOptions options,
    CieloApiCallback? onSuccess,
  }) async {

    var headers = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    var data = card.toJson();
    data['EnableBinQuery'] = options.enableBinQuery;
    data['EnableVerifyCard'] = options.enableVerifyCard;
    data['EnableTokenize'] = options.enableTokenize;
    data['AccessToken'] = accessToken;

    final r = data.entries.map((entry) {
      final key = Uri.encodeQueryComponent(entry.key);
      final value = Uri.encodeQueryComponent(entry.value.toString());
      return '$key=$value';
    }).join('&');

    var response = await http.post(Uri.parse(options.apiUrl), headers: headers, body: r);

    if (response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      onSuccess?.call(responseBody);
    } else {
      throw CieloAPIException(code: response.statusCode, message: response.reasonPhrase);
    }

  }

}