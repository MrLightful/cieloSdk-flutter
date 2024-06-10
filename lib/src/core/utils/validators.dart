import 'package:cielo_flutter/src/core/utils/luhn.dart';
import 'package:cielo_flutter/src/core/models/exception.dart';
import 'package:cielo_flutter/src/core/options.dart';

/// The set of validators for the card data validity.
class CieloValidators {
  const CieloValidators._();

  /// Validate the format of [accessToken] field.
  /// Throws a [CieloException] if the field is invalid.
  /// The exception message is for debugging purposes only, not to be shown to the user.
  static bool validateAccessToken(String accessToken,
      {CieloLanguage language = CieloLanguage.pt}) {
    if (accessToken.isEmpty) {
      throw CieloException(
        field: 'accessToken',
        code: 'MISSING_FIELD',
        message: 'The access token cannot be empty.',
      );
    }
    RegExp regExp = RegExp(
        r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');
    if (!regExp.hasMatch(accessToken)) {
      throw CieloException(
        field: 'accessToken',
        code: 'INVALID_FORMAT',
        message: 'The access token has an invalid format.',
      );
    }
    return true;
  }

  /// Validate the format of [holderName] field.
  /// Throws a localised [CieloException] if the field is invalid.
  static bool validateHolderName(String holderName,
      {CieloLanguage language = CieloLanguage.pt}) {
    if (holderName.isEmpty) {
      throw CieloCardValidationException(
        field: 'holderName',
        code: 'MISSING_FIELD',
        message: _CieloSOPValidatorsMessages.mandatoryFieldMessage(
          fieldNameMap: {
            CieloLanguage.en: 'Cardholder name',
            CieloLanguage.es: 'Nombre del titular de la tarjeta',
            CieloLanguage.pt: 'Nome do titular do cartão',
          },
          language: language,
        ),
      );
    }
    RegExp regExp = RegExp(r'^[A-Za-zŽžÀ-ÿ ]{3,64}$');
    if (!regExp.hasMatch(holderName)) {
      throw CieloCardValidationException(
        field: 'holderName',
        code: 'INVALID_FORMAT',
        message: _CieloSOPValidatorsMessages.getLocalizedErrorMessage(
            'CARDHOLDER_NAME_INVALID',
            language: language),
      );
    }
    return true;
  }

  /// Validate the format of [cardNumber] field.
  /// Validates [cardNumber] using the Luhn algorithm (MOD10) if [validateMod10] is true.
  /// Throws a localised [CieloException] if the field is invalid.
  static bool validateCardNumber(String cardNumber,
      {CieloLanguage language = CieloLanguage.pt, bool validateMod10 = true, bool isSandbox = false}) {
    if (cardNumber.isEmpty) {
      throw CieloCardValidationException(
        field: 'cardNumber',
        code: 'MISSING_FIELD',
        message: _CieloSOPValidatorsMessages.mandatoryFieldMessage(
          fieldNameMap: {
            CieloLanguage.en: 'Card number',
            CieloLanguage.es: 'Número de tarjeta',
            CieloLanguage.pt: 'Número do cartão',
          },
          language: language,
        ),
      );
    }
    const regex = r'^(?:4[0-9]{12}(?:[0-9]{3})?'         // Visa
                   r'|^5[1-5][0-9]{14}$'                  // MasterCard
                   r'|^3[47][0-9]{13}$'                   // American Express
                   r'|^3(?:0[0-5]|[68][0-9])[0-9]{11}$'   // Diners Club
                   r'|^6(?:011|5[0-9]{2})[0-9]{12}$'      // Discover
                   r'|^(?:2131|1800|35\d{3})\d{11})$';    // JCB

    // Allow pre-defined test card numbers in sandbox mode.
    // Learn more: https://braspag.github.io/en/manual/braspag-pagador#test-cards-(simulado)
    const sandboxRegex = r'^0{15}[1-9]$';

    RegExp sandboxRegExp = RegExp(sandboxRegex);
    RegExp regExp = RegExp(regex);
    final isSandboxTestCard = isSandbox && sandboxRegExp.hasMatch(cardNumber);
    if (!regExp.hasMatch(cardNumber) && !isSandboxTestCard) {
      throw CieloCardValidationException(
        field: 'cardNumber',
        code: 'INVALID_FORMAT',
        message: _CieloSOPValidatorsMessages.getLocalizedErrorMessage(
            "INVALID_CARD_NUMBER",
            language: language),
      );
    }
    if (validateMod10 && !isSandboxTestCard) {
      if (!validateCardNumberMod10(cardNumber)) {
        throw CieloCardValidationException(
          field: 'cardNumber',
          code: 'INVALID_CARD_NUMBER',
          message: _CieloSOPValidatorsMessages.getLocalizedErrorMessage(
              "INVALID_CARD_NUMBER",
              language: language),
        );
      }
    }
    return true;
  }

  /// Validate the format of [expirationDate] field.
  /// Throws a localised [CieloException] if the field is invalid.
  static bool validateExpirationDate(String expirationDate,
      {CieloLanguage language = CieloLanguage.pt,
      bool checkForExpiredDate = true}) {
    if (expirationDate.isEmpty) {
      throw CieloCardValidationException(
        field: 'expirationDate',
        code: 'MISSING_FIELD',
        message: _CieloSOPValidatorsMessages.mandatoryFieldMessage(
          fieldNameMap: {
            CieloLanguage.en: 'Expiration date',
            CieloLanguage.es: 'Fecha de vencimiento',
            CieloLanguage.pt: 'Data de validade',
          },
          language: language,
        ),
      );
    }

    RegExp regExp = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{4})$');
    if (!regExp.hasMatch(expirationDate)) {
      throw CieloCardValidationException(
        field: 'expirationDate',
        code: 'INVALID_FORMAT',
        message: _CieloSOPValidatorsMessages.getLocalizedErrorMessage(
            "INVALID_EXPIRATION_DATE",
            language: language),
      );
    }

    if (checkForExpiredDate) {
      final now = DateTime.now();
      final month = int.parse(expirationDate.substring(0, 2));
      final year = int.parse(expirationDate.substring(3, 7));
      if (year < now.year || (year == now.year && month <= now.month)) {
        throw CieloCardValidationException(
          field: 'expirationDate',
          code: 'EXPIRED_DATE',
          message: _CieloSOPValidatorsMessages.getLocalizedErrorMessage(
              "EXPIRED_DATE",
              language: language),
        );
      }
    }

    return true;
  }

  /// Validate the format of [securityCode] field.
  /// Throws a localised [CieloException] if the field is invalid.
  static bool validateSecurityCode(String? securityCode,
      {CieloLanguage language = CieloLanguage.pt}) {
    if (securityCode == null) return true;
    if (securityCode.isEmpty) {
      throw CieloCardValidationException(
        field: 'securityCode',
        code: 'MISSING_FIELD',
        message: _CieloSOPValidatorsMessages.mandatoryFieldMessage(
          fieldNameMap: {
            CieloLanguage.en: 'Security code',
            CieloLanguage.es: 'Código de seguridad',
            CieloLanguage.pt: 'Código de segurança',
          },
          language: language,
        ),
      );
    }
    RegExp regExp = RegExp(r'^[0-9]{3,4}$');
    if (!regExp.hasMatch(securityCode)) {
      throw CieloCardValidationException(
        field: 'securityCode',
        code: 'INVALID_FORMAT',
        message: _CieloSOPValidatorsMessages.getLocalizedErrorMessage(
            "INVALID_SECURITY_CODE",
            language: language),
      );
    }
    return true;
  }
}

/// Localised messages for [CieloValidators].
class _CieloSOPValidatorsMessages {
  const _CieloSOPValidatorsMessages._();

  static const Map<CieloLanguage, Map<String, String>> errorsMap = {
    CieloLanguage.en: {
      "CARDHOLDER_NAME_INVALID":
          "Cardholder name is too long or too short. Please try again.",
      "INVALID_CARD_NUMBER":
          "Credit card number is invalid. Please enter a valid card number.",
      "INVALID_EXPIRATION_DATE":
          "Invalid expiry date format. Please use MM/YYYY format.",
      "EXPIRED_DATE": "The card has expired. Please use a different card.",
      "INVALID_SECURITY_CODE":
          "Security code must contain 3 or 4 numeric characters.",
      "_EMPTY_FIELD":
          " cannot be empty. Please enter the required information.",
    },
    CieloLanguage.es: {
      "CARDHOLDER_NAME_INVALID":
          "El nombre del titular de la tarjeta es demasiado largo o demasiado corto. Por favor, inténtelo de nuevo.",
      "INVALID_CARD_NUMBER":
          "El número de la tarjeta de crédito no es válido. Introduzca un número de tarjeta válido.",
      "INVALID_EXPIRATION_DATE":
          "Formato de fecha de vencimiento no válido. Utilice el formato MM/AAAA.",
      "EXPIRED_DATE": "La tarjeta ha caducado. Utilice una tarjeta diferente.",
      "INVALID_SECURITY_CODE":
          "El código de seguridad debe contener 3 o 4 caracteres numéricos",
      "_EMPTY_FIELD":
          " no puede estar vacío. Por favor, introduzca la información requerida.",
    },
    CieloLanguage.pt: {
      "CARDHOLDER_NAME_INVALID":
          "O nome do titular do cartão é muito longo ou muito curto. Por favor, tente novamente.",
      "INVALID_CARD_NUMBER":
          "O número do cartão de crédito é inválido. Por favor, insira um número de cartão válido.",
      "INVALID_EXPIRATION_DATE":
          "Formato de data de validade inválido. Utilize o formato MM/AAAA.",
      "EXPIRED_DATE":
          "O cartão expirou. Por favor, utilize um cartão diferente.",
      "INVALID_SECURITY_CODE":
          "O código de segurança deve conter 3 ou 4 caracteres numéricos",
      "_EMPTY_FIELD":
          " não pode ser vazio. Por favor, insira as informações requeridas.",
    },
  };

  static String getLocalizedErrorMessage(String code,
      {CieloLanguage language = CieloLanguage.pt}) {
    return errorsMap[language]?[code] ?? 'Unknown language or error code';
  }

  static String mandatoryFieldMessage(
      {required Map<CieloLanguage, String> fieldNameMap,
      CieloLanguage language = CieloLanguage.pt}) {
    return fieldNameMap[language]! +
        _CieloSOPValidatorsMessages.getLocalizedErrorMessage('_EMPTY_FIELD',
            language: language);
  }
}
