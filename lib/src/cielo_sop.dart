import 'package:cielo_sop_flutter/cielo_sop_flutter.dart';
import 'package:cielo_sop_flutter/src/cielo_api.dart';
import 'package:cielo_sop_flutter/src/util/validators.dart';

class CieloSOP {

  CieloSOP._();
  static final CieloSOP _instance = CieloSOP._();
  static CieloSOP get instance => _instance;

  /// Options for the Cielo SOP API.
  CieloSOPOptions? _options;

  /// Sets the environment options for the Cielo SOP API.
  static set options(CieloSOPOptions options) {
    instance._options = options;
  }

  /// Returns the environment options for the Cielo SOP API.
  /// If the options are not set, it will return the default options.
  static CieloSOPOptions get options {
    instance._options ??= const CieloSOPOptions();
    return instance._options!;
  }

  /// Sends a card to Cielo SOP API.
  /// [accessToken] is the access token needed to complete the request. It must be obtained by your backend application via OAuth2.
  /// [options] is optional. If not set, it will fallback to initialized options.
  /// Throws [CieloAPIException] if Cielo returns failure.
  /// Learn more: https://developercielo.github.io/en/manual/cielo-ecommerce#integration193
  static void sendCard({
    required String accessToken,
    required CieloSOPCard card,
    CieloSOPOptions? options,
  }) async {

    options ??= CieloSOP.options;

    CieloSOPValidators.validateAccessToken(accessToken, language: options.language);
    CieloSOPValidators.validateHolderName(card.holderName, language: options.language);
    CieloSOPValidators.validateCardNumber(card.rawNumber, language: options.language, validateMod10: options.mod10Required);
    CieloSOPValidators.validateExpirationDate(card.expirationDate, language: options.language);
    CieloSOPValidators.validateSecurityCode(card.securityCode, language: options.language);

    CieloApi.sendRequest(
      accessToken: accessToken,
      card: card,
      options: options,
      onSuccess: (response) => print(response),
    );

  }

}