import 'dart:convert';

import 'package:cielo_flutter/cielo_flutter.dart';
import 'package:http/http.dart' as http;


class CieloSOPApi {

  final CieloOptions options;
  final CieloSOPOptions sopOptions;

  const CieloSOPApi({
    required this.options,
    required this.sopOptions
  });

  /// Returns the base URL of Cielo API for the selected provider and environment.
  String get _baseUrl {
    if (options.provider == CieloProvider.braspag) {
      switch (options.environment) {
        case CieloEnvironment.production:
          return "https://transaction.com.br";
        case CieloEnvironment.sandbox:
        default:
          return "https://transactionsandbox.pagador.com.br";
      }
    }
    switch (options.environment) {
      case CieloEnvironment.production:
        return "https://transaction.cieloecommerce.cielo.com.br";
      case CieloEnvironment.sandbox:
      default:
        return "https://transactionsandbox.cieloecommerce.cielo.com.br";
    }
  }

  /// Sends a request to the Cielo Silent Order Post API.
  /// [accessToken] is the access token needed to complete the request. It must be obtained by your backend application via OAuth2.
  /// [options] is optional. If not set, it will fallback to initialized options.
  /// Throws [CieloAPIException] if Cielo returns failure.
  /// Learn more: https://developercielo.github.io/en/manual/cielo-ecommerce#integration193
  Future<dynamic> sendRequest({
    required String accessToken,
    required CieloCard card,
    required CieloSOPOptions options,
  }) async {

    final apiUrl = '$_baseUrl/post/api/public/v1/card';
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

    var response = await http.post(Uri.parse(apiUrl), headers: headers, body: r);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw CieloAPIException(code: response.statusCode, message: response.reasonPhrase);
    }

  }

}