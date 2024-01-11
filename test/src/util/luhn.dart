import 'package:cielo_flutter/src/core/utils/luhn.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('accepts a valid card number', () {
    const validCard = '4111111111111111';
    expect(validateCardNumberMod10(validCard), true);
  });

  test('rejects an invalid card number', () {
    const invalidCard = '4111111111111211';
    expect(validateCardNumberMod10(invalidCard), false);
  });

}
