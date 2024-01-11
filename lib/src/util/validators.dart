import 'package:cielo_flutter/cielo_flutter.dart';
import 'package:cielo_flutter/src/util/luhn.dart';

/// The set of validators for the card data validity.
class CieloSOPValidators {

  const CieloSOPValidators._();

  /// Validate the format of [accessToken] field.
  /// Throws a localised [CieloValidationException] if the field is invalid.
  static bool validateAccessToken(String? accessToken, {CieloLanguage language = CieloLanguage.pt}) {
    if (accessToken == null || accessToken.isEmpty) {
      throw CieloValidationException(field: 'accessToken', message: _CieloSOPValidatorsMessages.mandatoryFieldMessage(language: language));
    }
    RegExp regExp = RegExp(r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');
    if (!regExp.hasMatch(accessToken)) {
      throw CieloValidationException(field: 'accessToken', message: _CieloSOPValidatorsMessages.invalidFormatFieldMessage(language: language));
    }
    return true;
  }

  /// Validate the format of [holderName] field.
  /// Throws a localised [CieloValidationException] if the field is invalid.
  static bool validateHolderName(String? holderName, {CieloLanguage language = CieloLanguage.pt}) {
    if (holderName == null || holderName.isEmpty) {
      throw CieloValidationException(field: 'holderName', message: _CieloSOPValidatorsMessages.mandatoryFieldMessage(language: language));
    }
    RegExp regExp = RegExp(r'^[a-zA-Z ]{3,64}$');
    if (!regExp.hasMatch(holderName)) {
      throw CieloValidationException(field: 'holderName', message: _CieloSOPValidatorsMessages.invalidHolderNameFormatFieldMessage(language: language));
    }
    return true;
  }

  /// Validate the format of [cardNumber] field.
  /// Validates [cardNumber] using the Luhn algorithm (MOD10) if [validateMod10] is true.
  /// Throws a localised [CieloValidationException] if the field is invalid.
  static bool validateCardNumber(String? cardNumber, {CieloLanguage language = CieloLanguage.pt, bool validateMod10 = true}) {
    if (cardNumber == null || cardNumber.isEmpty) {
      throw CieloValidationException(field: 'cardNumber', message: _CieloSOPValidatorsMessages.mandatoryFieldMessage(language: language));
    }
    RegExp regExp = RegExp(r'^[0-9]{16,19}$');
    if (!regExp.hasMatch(cardNumber)) {
      throw CieloValidationException(field: 'cardNumber', message: _CieloSOPValidatorsMessages.invalidCardNumberFormatFieldMessage(language: language));
    }
    if (validateMod10) {
      if (!validateCardNumberMod10(cardNumber)) {
        throw CieloValidationException(field: 'cardNumber', message: _CieloSOPValidatorsMessages.invalidCardNumberValidityMessage(language: language));
      }
    }
    return true;
  }

  /// Validate the format of [expirationDate] field.
  /// Throws a localised [CieloValidationException] if the field is invalid.
  static bool validateExpirationDate(String? expirationDate, {CieloLanguage language = CieloLanguage.pt}) {
    if (expirationDate == null || expirationDate.isEmpty) {
      throw CieloValidationException(field: 'expirationDate', message: _CieloSOPValidatorsMessages.mandatoryFieldMessage(language: language));
    }
    RegExp regExp = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{4})$');
    if (!regExp.hasMatch(expirationDate)) {
      throw CieloValidationException(field: 'expirationDate', message: _CieloSOPValidatorsMessages.invalidExpirationDateFormatFieldMessage(language: language));
    }
    return true;
  }

  /// Validate the format of [securityCode] field.
  /// Throws a localised [CieloValidationException] if the field is invalid.
  static bool validateSecurityCode(String? securityCode, {CieloLanguage language = CieloLanguage.pt}) {
    if (securityCode == null || securityCode.isEmpty) {
      throw CieloValidationException(field: 'securityCode', message: _CieloSOPValidatorsMessages.mandatoryFieldMessage(language: language));
    }
    RegExp regExp = RegExp(r'^[0-9]{3,4}$');
    if (!regExp.hasMatch(securityCode)) {
      throw CieloValidationException(field: 'securityCode', message: _CieloSOPValidatorsMessages.invalidSecurityCodeFormatFieldMessage(language: language));
    }
    return true;
  }

}

/// Localised messages for [CieloSOPValidators].
class _CieloSOPValidatorsMessages {

  const _CieloSOPValidatorsMessages._();

  static String mandatoryFieldMessage({CieloLanguage language = CieloLanguage.pt}) {
    switch (language) {
      case CieloLanguage.en:
        return "is mandatory";
      case CieloLanguage.es:
        return "es obligatorio";
      default:
        return "é obrigatório";
    }
  }

  static String invalidFormatFieldMessage({CieloLanguage language = CieloLanguage.pt}) {
    switch (language) {
      case CieloLanguage.en:
        return "invalid format";
      case CieloLanguage.es:
        return "formato inválido";
      default:
        return "formato inválido";
    }
  }

  static String invalidHolderNameFormatFieldMessage({CieloLanguage language = CieloLanguage.pt}) {
    switch (language) {
      case CieloLanguage.en:
        return "should contain a maximum of 64 alphanumeric characters";
      case CieloLanguage.es:
        return "debe contener un máximo de 64 caracteres alfanuméricos";
      default:
        return "deve conter no máximo 64 caracteres alfanuméricos";
    }
  }

  static String invalidCardNumberFormatFieldMessage({CieloLanguage language = CieloLanguage.pt}) {
    switch (language) {
      case CieloLanguage.en:
        return "should contain a maximum of 19 numeric characters";
      case CieloLanguage.es:
        return "debe contener un máximo de 19 caracteres numéricos";
      default:
        return "deve conter no máximo 19 caracteres alfanuméricos";
    }
  }

  static String invalidCardNumberValidityMessage({CieloLanguage language = CieloLanguage.pt}) {
    switch (language) {
      case CieloLanguage.en:
        return "must contain a valid card number";
      case CieloLanguage.es:
        return "debe contener un número de tarjeta válida";
      default:
        return "deve conter um número de cartão válido";
    }
  }

  static String invalidExpirationDateFormatFieldMessage({CieloLanguage language = CieloLanguage.pt}) {
    switch (language) {
      case CieloLanguage.en:
        return "must be valid and respect the format MM/YYYY";
      case CieloLanguage.es:
        return "debe ser válido y respetar el formato MM/AAAA";
      default:
        return "deve ser válido e respeitar o formato MM/AAAA";
    }
  }

  static String invalidSecurityCodeFormatFieldMessage({CieloLanguage language = CieloLanguage.pt}) {
    switch (language) {
      case CieloLanguage.en:
        return "must contain 3 or 4 numeric characters";
      case CieloLanguage.es:
        return "debe contener 3 o 4 caracteres numéricos";
      default:
        return "deve conter 3 ou 4 caracteres numéricos";
    }
  }

}