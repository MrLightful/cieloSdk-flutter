/// Validates the card number using the Luhn algorithm (MOD10).
bool validateCardNumberMod10(String cardNumber) {
  cardNumber = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');

  if (cardNumber.isEmpty ||
      cardNumber.length < 2 ||
      cardNumber.contains(RegExp(r'[^0-9]'))) {
    return false;
  }

  int sum = 0;
  bool isEven = false;

  for (int i = cardNumber.length - 1; i >= 0; i--) {
    int digit = int.parse(cardNumber[i]);

    if (isEven) {
      digit *= 2;
      if (digit > 9) {
        digit -= 9;
      }
    }

    sum += digit;
    isEven = !isEven;
  }

  return sum % 10 == 0;
}
