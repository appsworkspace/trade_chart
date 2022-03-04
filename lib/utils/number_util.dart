import 'dart:math';

import 'package:intl/intl.dart';

class NumberUtil {
  static String twoDecimal(String string) {
    var formatter = NumberFormat('#,##0.##');
    var res = formatter.format(double.parse(string));
    return res;
  }

  static String fourDecimal(String string) {
    var formatter = NumberFormat('#,##0.####');
    var res = formatter.format(double.parse(string));
    return res;
  }

  static String formatNumber(double n) {
    var formatter = NumberFormat('#,##0');
    var res = formatter.format(n);
    return "${res}";
  }

  static String format(double n) {
    if (n >= 10000) {
      n /= 1000;
      return "${twoDecimal(n.toString())}K";
    } else {
      return "${fourDecimal(n.toString())}";
    }
  }

  static int getDecimalLength(double b) {
    String s = b.toString();
    int dotIndex = s.indexOf(".");
    if (dotIndex < 0) {
      return 0;
    } else {
      return s.length - dotIndex - 1;
    }
  }

  static int getMaxDecimalLength(double a, double b, double c, double d) {
    int result = max(getDecimalLength(a), getDecimalLength(b));
    result = max(result, getDecimalLength(c));
    result = max(result, getDecimalLength(d));
    return result;
  }

  static bool checkNotNullOrZero(double? a) {
    if (a == null || a == 0) {
      return false;
    } else if (a.abs().toStringAsFixed(4) == "0.0000") {
      return false;
    } else {
      return true;
    }
  }
}
