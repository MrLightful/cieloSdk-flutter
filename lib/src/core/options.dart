/// Available selection of supported environments.
enum CieloEnvironment { sandbox, production }

/// Available selection of supported languages.
enum CieloLanguage { pt, en, es }

/// Available selection of supported providers.
enum CieloProvider { cielo, braspag }

/// Options to be used when initializing the Cielo SDK.
class CieloOptions {
  /// The provider to be used: cielo or braspag.
  final CieloProvider provider;

  /// The environment to be used: production or sandbox.
  final CieloEnvironment environment;

  /// The language to be used: pt, en or es.
  final CieloLanguage language;

  const CieloOptions({
    this.provider = CieloProvider.cielo,
    this.environment = CieloEnvironment.sandbox,
    this.language = CieloLanguage.pt,
  });
}
