import 'package:cielo_flutter/cielo_flutter.dart';
import 'package:cielo_flutter/src/apps/sop/cielo_sop.dart';

class Cielo {

  Cielo._();
  static Cielo _instance = Cielo._();

  /// Options for Cielo environment.
  CieloOptions? _options;

  /// Sets the environment options for Cielo.
  /// [options] is optional; defaults to cielo, sandbox, pt.
  static void init(CieloOptions options) {
    dispose();
    _instance._options = options;
  }

  /// Returns the environment options for Cielo.
  /// If the options are not set, it will return the default options.
  static CieloOptions get options {
    if (_instance._options == null) {
      throw Exception(
        'Cielo environment options are not initialized. '
        'Call Cielo.instance.init() before using it.',
      );
    }
    return _instance._options!;
  }

  /// Silent Order Post app
  CieloSOP? _sop;

  /// Initializes the Silent Order Post app.
  /// [options] is optional.
  /// Learn More:
  ///  - Cielo: https://developercielo.github.io/en/manual/cielo-ecommerce#silent-order-post
  ///  - Braspag: https://braspag.github.io//manualp/braspag-silent-order-post
  static void initSOP([CieloSOPOptions? options]) {
    if (_instance._options == null) {
      throw Exception(
        'Cielo environment options are not initialized. '
        'Call Cielo.instance.init() before using it.',
      );
    }
    final ops = options ?? const CieloSOPOptions();
    _instance._sop = CieloSOP(coreOptions: Cielo.options, options: ops);
  }

  /// Returns the Silent Order Post app.
  static CieloSOP get sop {
    if (_instance._options == null) {
      throw Exception(
        'Cielo environment options are not initialized. '
        'Call Cielo.instance.init() before using it.',
      );
    }
    if (_instance._sop == null) {
      throw Exception(
        'Cielo Silent Order Post app is not initialized. '
        'Call Cielo.initSOP() before using it.',
      );
    }
    return _instance._sop!;
  }

  static void dispose() {
    _instance = Cielo._();
  }

}