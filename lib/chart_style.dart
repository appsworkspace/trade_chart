import 'package:flutter/material.dart' show Color;

class ChartColors {
  Color kLineColor = Color(0xff4C86CD);
  Color lineFillColor = Color(0x554C86CD);
  Color ma5Color = Color(0xffC9B885);
  Color ma10Color = Color(0xff6CB0A6);
  Color ma20Color = Color(0xffffa500);
  Color ma30Color = Color(0xff9979C6);
  Color upColor = Color(0xff0000FF); // blue
  // Color upColor = Color(0xff00b300); //green

  Color dnColor = Color(0xffFF0000);
  Color volColor = Color(0xff4729AE);

  Color macdColor = Color(0xff4729AE);
  Color difColor = Color(0xffC9B885);
  Color deaColor = Color(0xff6CB0A6);

  Color kColor = Color(0xffC9B885);
  Color dColor = Color(0xff6CB0A6);
  Color jColor = Color(0xff9979C6);
  Color rsiColor = Color(0xffffa500);
  Color signalColor = Color(0xff6CB0A6);

  Color maHighColor = Color(0xff800080);
  Color maLowColor = Color(0xff0083cc);

  Color maUpperColor = Color(0xffcc8400);
  Color maLowerColor = Color(0xff6CB0A6);

  Color TBoxColor = Color(0xffe50000);
  Color BBoxColor = Color(0xff654321);

  Color defaultTextColor = Color(0xff60738E);

  Color nowPriceColor = Color(0xff000000);
  Color nowPriceUpColor = Color(0xff4DAA90);
  Color nowPriceDnColor = Color(0xffC15466);
  Color nowPriceTextColor = Color(0xffffffff);

  Color rsiBuy = Color(0xff00b300);
  Color rsiSell = Color(0xffff1493);
  Color stochKDBuy = Color(0xff00b300);
  Color stockKDSell = Color(0xffff1493);

  //深度颜色
  Color depthBuyColor = Color(0xff60A893);
  Color depthSellColor = Color(0xffC15866);
  //选中后显示值边框颜色
  Color selectBorderColor = Color(0xff6C7A86);

  //选中后显示值背景的填充颜色
  Color selectFillColor = Color(0xffffffff);

  //分割线颜色
  Color gridColor = Color(0xffE0E0E0);

  Color infoWindowNormalColor = Color(0xff000000);
  Color infoWindowTitleColor = Color(0xff000000);
  Color infoWindowUpColor = Color(0xff0000FF);
  Color infoWindowDnColor = Color(0xffff0000);

  Color hCrossColor = Color(0xff000000);
  Color vCrossColor = Color(0xff000000);
  Color crossTextColor = Color(0xff000000);

  //当前显示内最大和最小值的颜色
  Color maxColor = Color(0xff0000FF);
  Color minColor = Color(0xffFF0000);

  Color getMAColor(int index) {
    Color maColor = ma5Color;
    switch (index % 3) {
      case 0:
        maColor = ma5Color;
        break;
      case 1:
        maColor = ma10Color;
        break;
      case 2:
        maColor = ma30Color;
        break;
    }
    return maColor;
  }
}

class ChartStyle {
  //点与点的距离
  double pointWidth = 11.0;

  //蜡烛宽度
  double candleWidth = 8.5;

  //蜡烛中间线的宽度
  double candleLineWidth = 1;

  //vol柱子宽度
  double volWidth = 8.5;

  //macd柱子宽度
  double macdWidth = 3.0;

  //垂直交叉线宽度
  double vCrossWidth = 0.5;

  //水平交叉线宽度
  double hCrossWidth = 0.5;

  double nowPriceLineSpan = 1;

  double nowPriceLineLength = 1;

  double nowPriceLineWidth = 1;
}
