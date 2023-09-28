import 'package:cielo_sop_flutter/cielo_sop_flutter.dart';
import 'package:cielo_sop_flutter/src/util/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('validate access tokens', () {

    group('accepts valid access tokens', () {
      test('valid token #1', () => expect(CieloSOPValidators.validateAccessToken('SGVsbG8gd29ybGQh'), true));
      test('valid token #2', () => expect(CieloSOPValidators.validateAccessToken('MTIzNDU2Nzg5MA=='), true));
      test('valid token #3', () => expect(CieloSOPValidators.validateAccessToken('aW52YWxpZCBpbnN0YW5jZQ=='), true));
    });

    group('rejects invalid access tokens', () {
      test('reject null', () {
        expect(() => CieloSOPValidators.validateAccessToken(null), throwsA(isA<CieloValidationException>()));
      });
      test('reject empty', () {
        expect(() => CieloSOPValidators.validateAccessToken(''), throwsA(isA<CieloValidationException>()));
      });
      test('reject missing padding characters', () {
        expect(() => CieloSOPValidators.validateAccessToken('SGVsbG8gd29ybGQ'), throwsA(isA<CieloValidationException>()));
      });
      test('incorrect number of padding characters', () {
        expect(() => CieloSOPValidators.validateAccessToken('SGVsbG8gd29ybGQ=='), throwsA(isA<CieloValidationException>()));
      });
      test('contains non-base64 characters', () {
        expect(() => CieloSOPValidators.validateAccessToken('SGVsbG8gd29ybGQh!'), throwsA(isA<CieloValidationException>()));
      });
    });

  });

  group('validate card holder names', () {


    group('accepts valid card holder names', () {
      test('valid name #1', () => expect(CieloSOPValidators.validateHolderName('Andrew Peterson'), true));
      test('valid name #2', () => expect(CieloSOPValidators.validateHolderName('Andrew Peterson II'), true));
      test('valid name #3', () => expect(CieloSOPValidators.validateHolderName('Chan Li'), true));
    });

    group('rejects invalid card holder names', () {
      test('reject null', () {
        expect(() => CieloSOPValidators.validateHolderName(null), throwsA(isA<CieloValidationException>()));
      });
      test('reject empty', () {
        expect(() => CieloSOPValidators.validateHolderName(''), throwsA(isA<CieloValidationException>()));
      });
      test('reject too short', () {
        expect(() => CieloSOPValidators.validateHolderName('An'), throwsA(isA<CieloValidationException>()));
      });
      test('reject too long', () {
        expect(() => CieloSOPValidators.validateHolderName('A' * 65), throwsA(isA<CieloValidationException>()));
      });
      test('reject disallowed character', () {
        expect(() => CieloSOPValidators.validateHolderName('Anrew 1'), throwsA(isA<CieloValidationException>()));
      });
    });

  });

  group('validate card numbers', () {

    group('accepts valid card numbers', () {
      test('valid number #1', () => expect(CieloSOPValidators.validateCardNumber('4111111111111111'), true));
      test('valid number #2', () => expect(CieloSOPValidators.validateCardNumber('5500000000000004'), true));
      test('bypass MOD10 check', () => expect(CieloSOPValidators.validateCardNumber('3400000000000009', validateMod10: false), true));
    });

    group('rejects invalid card numbers', () {
      test('reject null', () {
        expect(() => CieloSOPValidators.validateCardNumber(null), throwsA(isA<CieloValidationException>()));
      });
      test('reject empty', () {
        expect(() => CieloSOPValidators.validateCardNumber(''), throwsA(isA<CieloValidationException>()));
      });
      test('reject too short', () {
        expect(() => CieloSOPValidators.validateCardNumber('411111111111111'), throwsA(isA<CieloValidationException>()));
      });
      test('reject too long', () {
        expect(() => CieloSOPValidators.validateCardNumber('41111111111111111'), throwsA(isA<CieloValidationException>()));
      });
      test('reject disallowed character', () {
        expect(() => CieloSOPValidators.validateCardNumber('411111111111111a'), throwsA(isA<CieloValidationException>()));
      });
      test('reject invalid number', () {
        expect(() => CieloSOPValidators.validateCardNumber('4111111111111112'), throwsA(isA<CieloValidationException>()));
      });
    });

  });

  group('validate card expiration dates', () {

    group('accepts valid card expiration dates', () {
      test('valid date #1', () => expect(CieloSOPValidators.validateExpirationDate('12/2020'), true));
      test('valid date #2', () => expect(CieloSOPValidators.validateExpirationDate('01/2021'), true));
      test('valid date #3', () => expect(CieloSOPValidators.validateExpirationDate('12/2022'), true));
    });

    group('rejects invalid card expiration dates', () {
      test('reject null', () {
        expect(() => CieloSOPValidators.validateExpirationDate(null), throwsA(isA<CieloValidationException>()));
      });
      test('reject empty', () {
        expect(() => CieloSOPValidators.validateExpirationDate(''), throwsA(isA<CieloValidationException>()));
      });
      test('reject year too short', () {
        expect(() => CieloSOPValidators.validateExpirationDate('12/20'), throwsA(isA<CieloValidationException>()));
      });
      test('reject month too short', () {
        expect(() => CieloSOPValidators.validateExpirationDate('1/20'), throwsA(isA<CieloValidationException>()));
      });
      test('reject year too long', () {
        expect(() => CieloSOPValidators.validateExpirationDate('12/20200'), throwsA(isA<CieloValidationException>()));
      });
      test('reject month too long', () {
        expect(() => CieloSOPValidators.validateExpirationDate('123/2020'), throwsA(isA<CieloValidationException>()));
      });
      test('reject disallowed character', () {
        expect(() => CieloSOPValidators.validateExpirationDate('12/202a'), throwsA(isA<CieloValidationException>()));
      });
    });

  });

  group('validate security code', () {
    group('accepts valid security codes', () {
      test('valid code #1', () => expect(CieloSOPValidators.validateSecurityCode('123'), true));
      test('valid code #2', () => expect(CieloSOPValidators.validateSecurityCode('1534'), true));
    });
    group('rejects invalid security codes', () {
      test('reject null', () {
        expect(() => CieloSOPValidators.validateSecurityCode(null), throwsA(isA<CieloValidationException>()));
      });
      test('reject empty', () {
        expect(() => CieloSOPValidators.validateSecurityCode(''), throwsA(isA<CieloValidationException>()));
      });
      test('reject too short', () {
        expect(() => CieloSOPValidators.validateSecurityCode('12'), throwsA(isA<CieloValidationException>()));
      });
      test('reject too long', () {
        expect(() => CieloSOPValidators.validateSecurityCode('12345'), throwsA(isA<CieloValidationException>()));
      });
      test('reject disallowed character', () {
        expect(() => CieloSOPValidators.validateSecurityCode('12a'), throwsA(isA<CieloValidationException>()));
      });
    });
  });

}
