import 'package:intl/intl.dart';

class CurrencyUtils {
  static String format(double value) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(value);
  }
}