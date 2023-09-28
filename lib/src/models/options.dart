/// Available selection of environments supported by Cielo SOP.
enum CieloEnvironment { sandbox, production }

/// Available selection of languages supported by Cielo SOP.
enum CieloLanguage { pt, en, es }

/// Available selection of providers supported by Cielo SOP.
enum CieloProvider { cielo, braspag }

/// Options to be used when initializing the Cielo SOP SDK.
class CieloSOPOptions {

  final CieloEnvironment environment;
  final CieloLanguage language;
  final CieloProvider provider;
  final bool cvvRequired;
  final bool mod10Required;
  final bool enableBinQuery;
  final bool enableVerifyCard;
  final bool enableTokenize;


  const CieloSOPOptions({
    this.environment = CieloEnvironment.sandbox,
    this.language = CieloLanguage.pt,
    this.provider = CieloProvider.braspag,
    this.cvvRequired = true,
    this.mod10Required = true,
    this.enableBinQuery = false,
    this.enableVerifyCard = false,
    this.enableTokenize = false,
  });

  /// Returns the base URL of Cielo API for the selected provider and environment.
  String get _baseUrl {
    if (provider == CieloProvider.braspag) {
      switch (environment) {
        case CieloEnvironment.sandbox:
          return "https://transactionsandbox.pagador.com.br";
        case CieloEnvironment.production:
        default:
          return "https://www.pagador.com.br";
      }
    }
    switch (environment) {
      case CieloEnvironment.sandbox:
        return "https://transactionsandbox.cieloecommerce.cielo.com.br";
      case CieloEnvironment.production:
      default:
        return "https://transaction.cieloecommerce.cielo.com.br";
    }
  }

  /// Returns the URL for Cielo SOP endpoint.
  String get apiUrl => '$_baseUrl/post/api/public/v1/card';


}