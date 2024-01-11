import 'package:cielo_flutter/cielo_flutter.dart';
import 'package:cielo_flutter/src/apps/sop/cielo_sop_api.dart';
import 'package:cielo_flutter/src/core/utils/validators.dart';

/// Silent Order Post app that allows you to send card data to Cielo/Braspag directly,
/// so your backend doesn't need to process PCI sensitive card data.
/// Learn more:
///   - Cielo: https://developercielo.github.io/en/manual/cielo-ecommerce#silent-order-post
///   - Braspag: https://braspag.github.io//manualp/braspag-silent-order-post
class CieloSOP {

  /// The options used in the core's sdk.
  final CieloOptions _coreOptions;

  /// The options used for Silent Order Post sdk.
  final CieloSOPOptions options;

  /// The API service for Silent Order Post product.
  final CieloSOPApi _api;

  CieloSOP({
    required this.options,
    required CieloOptions coreOptions,
  })  : _coreOptions = coreOptions,
        _api = CieloSOPApi(options: coreOptions, sopOptions: options);

  /// Sends a card to Cielo SOP API.
  /// [accessToken] is the access token needed to complete the request. It must be obtained by your backend application via OAuth2.
  /// Throws [CieloAPIException] if Cielo returns failure.
  Future<dynamic> sendCard(CieloCard card,
      {required String accessToken}) async {
    CieloValidators.validateAccessToken(accessToken,
        language: _coreOptions.language);
    CieloValidators.validateHolderName(card.holderName,
        language: _coreOptions.language);
    CieloValidators.validateCardNumber(card.rawNumber,
        validateMod10: options.mod10Required, language: _coreOptions.language);
    CieloValidators.validateExpirationDate(card.expirationDate,
        language: _coreOptions.language);
    CieloValidators.validateSecurityCode(card.securityCode,
        language: _coreOptions.language);

    return _api.sendRequest(
      accessToken: accessToken,
      card: card,
      options: options,
    );
  }
}
