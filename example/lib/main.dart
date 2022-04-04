import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:trade_chart/chart_style.dart';
import 'package:trade_chart/chart_translations.dart';
import 'package:trade_chart/flutter_k_chart.dart';
import 'package:trade_chart/k_chart_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<KLineEntity>? datas;
  bool showLoading = true;
  List<DepthEntity>? _bids, _asks;
  bool isChangeUI = false;

  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();

  IOClient _certification() {
    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return IOClient(ioc);
  }

  @override
  void initState() {
    chartColors.minColor = Colors.grey;
    chartColors.maxColor = Colors.grey;
    chartColors.nowPriceUpColor = Colors.yellow;
    chartColors.nowPriceDnColor = Colors.yellow;
    chartColors.nowPriceTextColor = Colors.black;
    chartColors.gridColor = Colors.black54;
    chartColors.dnColor = Colors.red;
    chartColors.upColor = Colors.green;
    chartColors.defaultTextColor = Colors.white;
    chartColors.selectFillColor = Colors.grey.withOpacity(1);
    chartColors.crossTextColor = Colors.black;
    chartColors.hCrossColor = Colors.grey;
    chartColors.vCrossColor = Colors.grey;
    chartColors.selectBorderColor = Colors.black;
    chartColors.infoWindowNormalColor = Colors.black;
    chartColors.infoWindowTitleColor = Colors.black;
    chartStyle.candleLineWidth = 2;
    chartStyle.nowPriceLineWidth = 1;
    chartStyle.volWidth = 6;

    super.initState();
    getData('1day');
    rootBundle.loadString('assets/depth.json').then((result) {
      final parseJson = json.decode(result);
      final tick = parseJson['tick'] as Map<String, dynamic>;
      final List<DepthEntity> bids = (tick['bids'] as List<dynamic>)
          .map<DepthEntity>(
              (item) => DepthEntity(item[0] as double, item[1] as double))
          .toList();
      final List<DepthEntity> asks = (tick['asks'] as List<dynamic>)
          .map<DepthEntity>(
              (item) => DepthEntity(item[0] as double, item[1] as double))
          .toList();
      initDepth(bids, asks);
    });
  }

  void initDepth(List<DepthEntity>? bids, List<DepthEntity>? asks) {
    if (bids == null || asks == null || bids.isEmpty || asks.isEmpty) return;
    _bids = [];
    _asks = [];
    double amount = 0.0;
    bids.sort((left, right) => left.price.compareTo(right.price));
    bids.reversed.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      _bids!.insert(0, item);
    });

    amount = 0.0;
    asks.sort((left, right) => left.price.compareTo(right.price));
    asks.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      _asks!.add(item);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: KChartWidget(
            datas,
            chartStyle,
            chartColors,
            isLine: false,
            mainState: MainState.BOLL,
            volHidden: false,
            secondaryState: SecondaryState.NONE,
            fixedLength: 2,
            timeFormat: TimeFormat.YEAR_MONTH_DAY,
            translations: kChartTranslations,
            isChinese: false,
            hideGrid: false,
            bgColor: [Colors.transparent, Colors.transparent],
          ),
        ),
      ),
    );
  }

  void getData(String period) {
    final Future<String> future = getIPAddress(period);
    future.then((String result) {
      final Map parseJson = jsonDecode(result) as Map<dynamic, dynamic>;

      final list = parseJson['data'] as List<dynamic>;
      datas = list
          .map((item) => KLineEntity.fromJson(item as Map<String, dynamic>))
          .toList()
          .cast<KLineEntity>();
      DataUtil.calculate(datas!);
      showLoading = false;
      setState(() {});
    }).catchError((_) {
      showLoading = false;
      setState(() {});
      print('### datas error $_');
    });
  }

  Future<String> getIPAddress(String? period) async {
    var url = 'https://api.andalasian.com/api/crypto/ETHUSDT';
    late String result;
    final _http = _certification();
    final response = await _http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      result = response.body;
    } else {
      print('Failed getting IP address');
    }
    return result;
  }
}
