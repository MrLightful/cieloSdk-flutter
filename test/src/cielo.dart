import 'package:cielo_flutter/cielo_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  setUp(Cielo.dispose);

  test('successful basic sdk initialization', () {
    const options = CieloOptions();
    Cielo.init(options);
  });
  
  test('successful sdk initialization with non-default options', () {
    const options = CieloOptions(
      environment: CieloEnvironment.production,
      language: CieloLanguage.en,
      provider: CieloProvider.braspag,
    );
    Cielo.init(options);
    expect(Cielo.options.environment, options.environment);
    expect(Cielo.options.language, options.language);
    expect(Cielo.options.provider, options.provider);
  });

  test('failure to initSOP without core init', () {
    // Requires Cielo.init() prior.
    expect(() => Cielo.initSOP(), throwsException);
  });

  test('failure to get SOP app without core init', () {
    // Requires Cielo.init() and Cielo.initSOP() prior.
    expect(() => Cielo.sop, throwsException);
  });

  test('failure to get SOP app without SOP init', () {
    const options = CieloOptions();
    Cielo.init(options);
    // Requires Cielo.initSOP() prior.
    expect(() => Cielo.sop, throwsException);
  });

  test('successful SOP initialization', () {
    const options = CieloOptions();
    Cielo.init(options);
    Cielo.initSOP();
    expect(Cielo.sop, isNotNull);
  });

  test('successful SOP initialization with non-default options', () {
    const options = CieloOptions();
    const sopOptions = CieloSOPOptions(
      cvvRequired: false,
      mod10Required: false,
      enableBinQuery: true,
      enableTokenize: true,
      enableVerifyCard: true,
    );
    Cielo.init(options);
    Cielo.initSOP(sopOptions);
    expect(Cielo.sop.options.cvvRequired, sopOptions.cvvRequired);
    expect(Cielo.sop.options.mod10Required, sopOptions.mod10Required);
    expect(Cielo.sop.options.enableBinQuery, sopOptions.enableBinQuery);
    expect(Cielo.sop.options.enableTokenize, sopOptions.enableTokenize);
    expect(Cielo.sop.options.enableVerifyCard, sopOptions.enableVerifyCard);
  });

}
