/// The model of the credit/debit card data to be sent to the Cielo API.
class CieloCard {
  /// The card holder name.
  final String holderName;

  /// The card number.
  final String rawNumber;

  /// The card expiration date in the format `MM/YYYY`.
  final String expirationDate;

  /// The card security code.
  final String? securityCode;

  CieloCard({
    required this.holderName,
    required this.rawNumber,
    required this.expirationDate,
    this.securityCode,
  });

  Map<String, dynamic> toJson() => {
        "HolderName": holderName,
        "RawNumber": rawNumber,
        "Expiration": expirationDate,
        "SecurityCode": securityCode,
      };
}
