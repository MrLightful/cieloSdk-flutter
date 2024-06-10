import 'package:cielo_flutter/cielo_flutter.dart';
import 'package:cielo_flutter/src/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validate access tokens', () {
    group('accepts valid access tokens', () {
      test(
          'valid token #1',
          () => expect(
              CieloValidators.validateAccessToken('SGVsbG8gd29ybGQh'), true));
      test(
          'valid token #2',
          () => expect(
              CieloValidators.validateAccessToken('MTIzNDU2Nzg5MA=='), true));
      test(
          'valid token #3',
          () => expect(
              CieloValidators.validateAccessToken('aW52YWxpZCBpbnN0YW5jZQ=='),
              true));
    });

    group('rejects invalid access tokens', () {
      test('reject empty', () {
        expect(() => CieloValidators.validateAccessToken(''),
            throwsA(isA<CieloException>()));
      });
      test('reject missing padding characters', () {
        expect(() => CieloValidators.validateAccessToken('SGVsbG8gd29ybGQ'),
            throwsA(isA<CieloException>()));
      });
      test('incorrect number of padding characters', () {
        expect(() => CieloValidators.validateAccessToken('SGVsbG8gd29ybGQ=='),
            throwsA(isA<CieloException>()));
      });
      test('contains non-base64 characters', () {
        expect(() => CieloValidators.validateAccessToken('SGVsbG8gd29ybGQh!'),
            throwsA(isA<CieloException>()));
      });
    });
  });

  group('validate card holder names', () {
    group('accepts valid card holder names', () {
      test(
          'valid name #1',
          () => expect(
              CieloValidators.validateHolderName('Andrew Peterson'), true));
      test(
          'valid name #2',
          () => expect(
              CieloValidators.validateHolderName('Andrew Peterson II'), true));
      test('valid name #3',
          () => expect(CieloValidators.validateHolderName('Chan Li'), true));
    });

    group('rejects invalid card holder names', () {
      test('reject empty', () {
        expect(() => CieloValidators.validateHolderName(''),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject too short', () {
        expect(() => CieloValidators.validateHolderName('An'),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject too long', () {
        expect(() => CieloValidators.validateHolderName('A' * 65),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject disallowed character', () {
        expect(() => CieloValidators.validateHolderName('Anrew 1'),
            throwsA(isA<CieloCardValidationException>()));
      });
    });
  });

  group('validate card numbers', () {
    group('accepts valid card numbers', () {
      test(
          'valid number #1',
          () => expect(
              CieloValidators.validateCardNumber('4111111111111111'), true));
      test(
          'valid number #2',
          () => expect(
              CieloValidators.validateCardNumber('5500000000000004'), true));
      test(
          'valid test card number in sandbox',
          () => expect(
              CieloValidators.validateCardNumber('0000000000000002', isSandbox: true), true));
      test(
          'bypass MOD10 check',
          () => expect(
              CieloValidators.validateCardNumber('5500000000000011',
                  validateMod10: false),
              true));
    });

    group('rejects invalid card numbers', () {
      test('reject empty', () {
        expect(() => CieloValidators.validateCardNumber(''),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject too short', () {
        expect(() => CieloValidators.validateCardNumber('411111111111111'),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject too long', () {
        expect(() => CieloValidators.validateCardNumber('41111111111111111'),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject disallowed character', () {
        expect(() => CieloValidators.validateCardNumber('411111111111111a'),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject invalid number', () {
        expect(() => CieloValidators.validateCardNumber('4111111111111112'),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject test number in prod', () {
        expect(() => CieloValidators.validateCardNumber('0000000000000002'),
            throwsA(isA<CieloCardValidationException>()));
      });
    });
  });

  group('validate card expiration dates', () {
    group('accepts valid card expiration dates', () {
      test(
          'valid date #1',
          () => expect(
              CieloValidators.validateExpirationDate('12/2020',
                  checkForExpiredDate: false),
              true));
      test(
          'valid date #2',
          () => expect(
              CieloValidators.validateExpirationDate('01/2021',
                  checkForExpiredDate: false),
              true));
      test(
          'valid date #3',
          () => expect(
              CieloValidators.validateExpirationDate('12/2022',
                  checkForExpiredDate: false),
              true));
    });

    group('rejects invalid card expiration dates', () {
      test('reject empty', () {
        expect(
            () => CieloValidators.validateExpirationDate('',
                checkForExpiredDate: false),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject year too short', () {
        expect(
            () => CieloValidators.validateExpirationDate('12/20',
                checkForExpiredDate: false),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject month too short', () {
        expect(
            () => CieloValidators.validateExpirationDate('1/20',
                checkForExpiredDate: false),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject year too long', () {
        expect(
            () => CieloValidators.validateExpirationDate('12/20200',
                checkForExpiredDate: false),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject month too long', () {
        expect(
            () => CieloValidators.validateExpirationDate('123/2020',
                checkForExpiredDate: false),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject disallowed character', () {
        expect(
            () => CieloValidators.validateExpirationDate('12/202a',
                checkForExpiredDate: false),
            throwsA(isA<CieloCardValidationException>()));
      });
    });

    group('validate actual expiration status of the dates', () {
      final now = DateTime.now();
      final curMonth = '${now.month < 10 ? '0' : ''}${now.month}';
      final expiredDate = '12/${now.year - 1}';
      final currentMonthDate = '$curMonth/${now.year}';
      final futureDate = '12/${now.year + 1}';
      test('reject expired date', () {
        expect(() => CieloValidators.validateExpirationDate(expiredDate),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject current month', () {
        expect(() => CieloValidators.validateExpirationDate(currentMonthDate),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('accept future date', () {
        expect(CieloValidators.validateExpirationDate(futureDate), true);
      });
    });
  });

  group('validate security code', () {
    group('accepts valid security codes', () {
      test('valid code #1',
          () => expect(CieloValidators.validateSecurityCode('123'), true));
      test('valid code #2',
          () => expect(CieloValidators.validateSecurityCode('1534'), true));
    });
    group('rejects invalid security codes', () {
      test('reject empty', () {
        expect(() => CieloValidators.validateSecurityCode(''),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject too short', () {
        expect(() => CieloValidators.validateSecurityCode('12'),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject too long', () {
        expect(() => CieloValidators.validateSecurityCode('12345'),
            throwsA(isA<CieloCardValidationException>()));
      });
      test('reject disallowed character', () {
        expect(() => CieloValidators.validateSecurityCode('12a'),
            throwsA(isA<CieloCardValidationException>()));
      });
    });
  });
}
