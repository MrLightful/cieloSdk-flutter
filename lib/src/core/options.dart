/// Available selection of supported environments.
enum CieloEnvironment { sandbox, production }

/// Available selection of supported languages.
enum CieloLanguage { pt, en, es }

/// Available selection of supported providers.
enum CieloProvider { cielo, braspag }

/// Options to be used when initializing the Cielo SDK.
class CieloOptions {

  final CieloEnvironment environment;
  final CieloLanguage language;
  final CieloProvider provider;

  const CieloOptions({
    this.environment = CieloEnvironment.sandbox,
    this.language = CieloLanguage.pt,
    this.provider = CieloProvider.cielo,
  });

}