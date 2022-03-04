// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import,camel_case_types
mixin CandleEntity {
  late double open;
  late double high;
  late double low;
  late double close;

  double? mac_high;
  double? mac_upper;
  double? mac_low;
  double? mac_lower;
  double? mac_high_1;
  double? mac_upper_1;
  double? mac_low_1;
  double? mac_lower_1;
  double? rsi;
  double? rsi_signal;
  String? rsi_flag;
  String? stochastic_kd_flag;
  double? moving_average;
  double? top_box;
  double? bottom_box;
  List<double>? maValueList;

//  上轨线
  double? up;

//  中轨线
  double? mb;

//  下轨线
  double? dn;

  double? BOLLMA;

  // MAC
  double? macUp;
  double? macLow;

  double? maH;
  double? maL;
  double? ma;

  double? stoch_buy;
  double? stoch_sell;
}
