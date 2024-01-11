/// Options to be used when initializing the Cielo SOP SDK.
class CieloSOPOptions {

  final bool cvvRequired;
  final bool mod10Required;
  final bool enableBinQuery;
  final bool enableVerifyCard;
  final bool enableTokenize;


  const CieloSOPOptions({
    this.cvvRequired = true,
    this.mod10Required = true,
    this.enableBinQuery = false,
    this.enableVerifyCard = false,
    this.enableTokenize = false,
  });

}