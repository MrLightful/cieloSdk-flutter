import 'package:cielo_flutter/cielo_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  // These tests run with real sandbox environment of the provider.
  // For this, the sandbox credentials are needed.
  // By default, the tests are skipped.
  const provider = CieloProvider.braspag;
  const sopAccessToken = ''; // it's short-lived, 20 minutes or so.

  // Initialize sdk once.
  const options = CieloOptions(
    provider: provider,
    environment: CieloEnvironment.sandbox,
  );
  Cielo.init(options);

  test('failing Silent Order Post request due to invalid access token', () async {

    // The format is correct, just "expired".
    const invalidAccessToken = 'Abcdefghijklmnopqrstuvwxyz1234567890sdfghjkllSDFGHJKLssdfghjkl==';

    const sopOptions = CieloSOPOptions(enableTokenize: true);
    Cielo.initSOP(sopOptions);

    final card = CieloCard(
      holderName: 'John Doe',
      rawNumber: '4000000000001091',
      expirationDate: '12/2030',
      securityCode: '123'
    );
    expect(
      () async => await Cielo.sop.sendCard(accessToken: invalidAccessToken, card: card),
      throwsA(isA<CieloAPIException>()),
    );
  });

  test('successful Silent Order Post request', () async {
    const sopOptions = CieloSOPOptions(enableTokenize: true);
    Cielo.initSOP(sopOptions);

    final card = CieloCard(
      holderName: 'John Doe',
      rawNumber: '4000000000001091',
      expirationDate: '12/2030',
      securityCode: '123'
    );

    await Cielo.sop.sendCard(accessToken: sopAccessToken, card: card);
  }, skip: sopAccessToken.isEmpty);

}
