/// Options to be used when initializing the Cielo SOP SDK.
class CieloSOPOptions {

  /// Whether the CVV is required or not.
  final bool cvvRequired;

  /// Whether the mod10 (Luhn) validation is required or not.
  final bool mod10Required;

  /// Whether BIN query check is enabled or not.
  final bool enableBinQuery;

  /// Whether Verify Card (Zero Auth) check is enabled or not.
  final bool enableVerifyCard;

  /// Whether tokenization is enabled or not.
  final bool enableTokenize;

  const CieloSOPOptions({
    this.cvvRequired = true,
    this.mod10Required = true,
    this.enableBinQuery = false,
    this.enableVerifyCard = false,
    this.enableTokenize = false,
  });
}
