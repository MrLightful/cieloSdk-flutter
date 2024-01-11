
/// The model of the credit/debit card data to be sent to the Cielo API.
class CieloCard {

  final String holderName;
  final String rawNumber;
  final String expirationDate;
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