import '../entity/k_entity.dart';

class KLineEntity extends KEntity {
  late double open;
  late double high;
  late double low;
  late double close;
  late double vol;
  late double amount;
  double? change;
  double? ratio;
  int? time;
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

  KLineEntity.fromCustom({
    required this.amount,
    required this.open,
    required this.close,
    this.change,
    this.ratio,
    this.time,
    required this.high,
    required this.low,
    required this.vol,
    this.mac_high,
    this.mac_upper,
    this.mac_low,
    this.mac_lower,
    this.mac_high_1,
    this.mac_upper_1,
    this.mac_low_1,
    this.mac_lower_1,
    this.rsi,
    this.rsi_signal,
    this.rsi_flag,
    this.stochastic_kd_flag,
    this.moving_average,
    this.top_box,
    this.bottom_box,
  });

  KLineEntity.fromJson(Map<String, dynamic> json) {
    open = json['open']?.toDouble() ?? 0;
    high = json['high']?.toDouble() ?? 0;
    low = json['low']?.toDouble() ?? 0;
    close = json['close']?.toDouble() ?? 0;
    vol = json['vol']?.toDouble() ?? 0;
    amount = json['amount']?.toDouble() ?? 0;
    int? tempTime = json['time']?.toInt();
    //兼容火币数据
    if (tempTime == null) {
      tempTime = json['id']?.toInt() ?? 0;
      tempTime = tempTime! * 1000;
    }
    time = tempTime;
    ratio = json['ratio']?.toDouble() ?? 0;
    change = json['change']?.toDouble() ?? 0;
    mac_high = json['high_ma']?.toDouble() ?? 0;
    mac_upper = json['mac_upper']?.toDouble() ?? 0;
    mac_low = json['mac_low']?.toDouble() ?? 0;
    mac_lower = json['mac_lower']?.toDouble() ?? 0;
    mac_high_1 = json['mac_high_1']?.toDouble() ?? 0;
    mac_upper_1 = json['mac_upper_1']?.toDouble() ?? 0;
    mac_low_1 = json['mac_low_1']?.toDouble() ?? 0;
    mac_lower_1 = json['mac_lower_1']?.toDouble() ?? 0;
    rsi = json['rsi']?.toDouble() ?? 0;
    rsi_signal = json['rsi_signal']?.toDouble() ?? 0;
    rsi_flag = json['rsi_flag'];
    stochastic_kd_flag = json['stochastic_kd_flag'];

    moving_average = json['ma']?.toDouble() ?? 0;
    top_box = json['top_box']?.toDouble() ?? 0;
    bottom_box = json['bottom_box']?.toDouble() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['open'] = this.open;
    data['close'] = this.close;
    data['high'] = this.high;
    data['low'] = this.low;
    data['vol'] = this.vol;
    data['amount'] = this.amount;
    data['ratio'] = this.ratio;
    data['change'] = this.change;
    data['mac_high'] = this.mac_high;
    data['mac_upper'] = this.mac_upper;
    data['mac_low'] = this.mac_low;
    data['mac_lower'] = this.mac_lower;
    data['mac_high_1'] = this.mac_high_1;
    data['mac_upper_1'] = this.mac_upper_1;
    data['mac_low_1'] = this.mac_low_1;
    data['mac_lower_1'] = this.mac_lower_1;
    data['rsi'] = this.rsi;
    data['rsi_signal'] = this.rsi_signal;
    data['rsi_flag'] = this.rsi_flag;
    data['stochastic_kd_flag'] = this.stochastic_kd_flag;

    data['moving_average'] = this.moving_average;
    data['top_box'] = this.top_box;
    data['bottom_box'] = this.bottom_box;
    return data;
  }

  @override
  String toString() {
    return 'MarketModel{open: $open, high: $high, low: $low, close: $close, vol: $vol, time: $time, amount: $amount, ratio: $ratio, change: $change, mac_high: $mac_high, mac_upper: $mac_upper, mac_low: $mac_low, mac_lower: $mac_lower, mac_high_1: $mac_high_1, mac_upper_1: $mac_upper_1, mac_low_1: $mac_low_1, mac_lower_1: $mac_lower_1, rsi: $rsi, rsi_signal: $rsi_signal, rsi_flag: $rsi_flag, stochastic_kd_flag: $stochastic_kd_flag, moving_average: $moving_average, top_box: $top_box, bottom_box: $bottom_box}';
  }
}
