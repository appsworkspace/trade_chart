import 'dart:ui';

import 'package:flutter/material.dart';

import '../entity/macd_entity.dart';
import '../k_chart_widget.dart' show SecondaryState;
import 'base_chart_renderer.dart';

class SecondaryRenderer extends BaseChartRenderer<MACDEntity> {
  late double mMACDWidth;
  SecondaryState state;
  final ChartStyle chartStyle;
  final ChartColors chartColors;

  SecondaryRenderer(
      Rect mainRect,
      double maxValue,
      double minValue,
      double topPadding,
      this.state,
      int fixedLength,
      this.chartStyle,
      this.chartColors)
      : super(
            chartRect: mainRect,
            maxValue: maxValue,
            minValue: minValue,
            topPadding: topPadding,
            fixedLength: fixedLength,
            gridColor: chartColors.gridColor,) {
    mMACDWidth = this.chartStyle.macdWidth;
  }

  @override
  void drawChart(MACDEntity lastPoint, MACDEntity curPoint, double lastX,
      double curX, Size size, Canvas canvas) {
    switch (state) {
      case SecondaryState.MACD:
        drawMACD(curPoint, canvas, curX, lastPoint, lastX);
        break;
      case SecondaryState.KDJ:
        drawLine(lastPoint.k, curPoint.k, canvas, lastX, curX,
            this.chartColors.kColor);
        drawLine(lastPoint.d, curPoint.d, canvas, lastX, curX,
            this.chartColors.dColor);
        break;
      case SecondaryState.RSI:
        drawLine(lastPoint.rsi, curPoint.rsi, canvas, lastX, curX,
            this.chartColors.rsiColor);
        break;
      case SecondaryState.WR:
        drawLine(lastPoint.r, curPoint.r, canvas, lastX, curX,
            this.chartColors.rsiColor);
        break;
      case SecondaryState.CCI:
        drawLine(lastPoint.cci, curPoint.cci, canvas, lastX, curX,
            this.chartColors.rsiColor);
        break;
      default:
        break;
    }
  }

  void drawMACD(MACDEntity curPoint, Canvas canvas, double curX,
      MACDEntity lastPoint, double lastX) {
    final macd = curPoint.k ?? 0;
    double macdY = getY(macd);

    final macd2 = curPoint.d ?? 0;
    double macdY2 = getY(macd2);

    double r = mMACDWidth / 2;
    double zeroy = getY(0);

    if (macd >= 70) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY, curX + r, zeroy),
          chartPaint..color = this.chartColors.overbought);
    } else if (macd >= 60) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY, curX + r, zeroy),
          chartPaint..color = this.chartColors.strongbuy);
    }else if (macd >= 50) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY, curX + r, zeroy),
          chartPaint..color = this.chartColors.buy);
    } else if (macd == 50) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY, curX + r, zeroy),
          chartPaint..color = this.chartColors.netral);
    } else if (macd < 50) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY, curX + r, zeroy),
          chartPaint..color = this.chartColors.sell);
    } else if (macd <= 40) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY, curX + r, zeroy),
          chartPaint..color = this.chartColors.strongsell);
    } else if (macd <= 30) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY, curX + r, zeroy),
          chartPaint..color = this.chartColors.oversold);
    }

        if (macd2 >= 80) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY2, curX + r, zeroy),
          chartPaint..color = this.chartColors.overbought);
    } else if (macd2 >= 65) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY2, curX + r, zeroy),
          chartPaint..color = this.chartColors.strongbuy);
    }else if (macd2 >= 50) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY2, curX + r, zeroy),
          chartPaint..color = this.chartColors.buy);
    } else if (macd2 == 50) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY2, curX + r, zeroy),
          chartPaint..color = this.chartColors.netral);
    } else if (macd2 < 50) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY2, curX + r, zeroy),
          chartPaint..color = this.chartColors.sell);
    } else if (macd2 <= 35) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY2, curX + r, zeroy),
          chartPaint..color = this.chartColors.strongsell);
    } else if (macd2 <= 20) {
      canvas.drawRect(Rect.fromLTRB(curX - r, macdY2, curX + r, zeroy),
          chartPaint..color = this.chartColors.oversold);
    }
    // if (lastPoint.k != 0) {
    //   drawLine(lastPoint.k, curPoint.k, canvas, lastX, curX,
    //       this.chartColors.kColor);
    // }
    // if (lastPoint.d != 0) {
    //   drawLine(lastPoint.d, curPoint.d, canvas, lastX, curX,
    //       this.chartColors.dColor);
    // }
  }

  @override
  void drawText(Canvas canvas, MACDEntity data, double x) {
    final macd = data.k ?? 0;
    final macd2 = data.d ?? 0;
    List<TextSpan>? children;
    switch (state) {
      case SecondaryState.MACD:
        children = [

TextSpan(
                text: 
                macd >= 70 ? "RSI (${format(macd)}) : OVERBOUGHT    "
                : macd >= 60 ? "RSI (${format(macd)}) : STRONG BUY    "
                : macd >= 50 ? "RSI (${format(macd)}) : BUY    "
                : macd == 50 ? "RSI (${format(macd)}) : NETRAL   "
                : macd < 50 ? "RSI (${format(macd)}) : SELL    "
                : macd <= 40 ? "RSI (${format(macd)}) : STRONG SELL    "
                : macd <= 30 ? "RSI (${format(macd)}) : OVER SOLD   "
                : "-   ",
                style: macd >= 70 ? getTextStyle(this.chartColors.overbought)
                : macd >= 60 ? getTextStyle(this.chartColors.strongbuy)
                : macd >= 50 ? getTextStyle(this.chartColors.buy)
                : macd == 50 ? getTextStyle(this.chartColors.netral)
                : macd < 50 ? getTextStyle(this.chartColors.sell)
                : macd <= 40 ? getTextStyle(this.chartColors.strongsell)
                : macd <= 30 ? getTextStyle(this.chartColors.oversold)
                : getTextStyle(this.chartColors.netral)
),

TextSpan(
                text: 
                macd2 >= 80 ? "MFI (${format(macd2)}) : OVERBOUGHT    "
                : macd2 >= 65 ? "MFI (${format(macd2)}) : STRONG BUY    "
                : macd2 >= 50 ? "MFI (${format(macd2)}) : BUY    "
                : macd2 == 50 ? "MFI (${format(macd2)}) : NETRAL   "
                : macd2 < 50 ? "MFI (${format(macd2)}) : SELL    "
                : macd2 <= 35 ? "MFI (${format(macd2)}) : STRONG SELL    "
                : macd2 <= 20 ? "MFI (${format(macd2)}) : OVER SOLD   "
                : "-   ",
                style: macd2 >= 80 ? getTextStyle(this.chartColors.overbought)
                : macd2 >= 65 ? getTextStyle(this.chartColors.strongbuy)
                : macd2 >= 50 ? getTextStyle(this.chartColors.buy)
                : macd2 == 50 ? getTextStyle(this.chartColors.netral)
                : macd2 < 50 ? getTextStyle(this.chartColors.sell)
                : macd2 <= 35 ? getTextStyle(this.chartColors.strongsell)
                : macd2 <= 20 ? getTextStyle(this.chartColors.oversold)
                : getTextStyle(this.chartColors.netral)
),
     
    
        ];
        break;
      case SecondaryState.KDJ:
        children = [
          TextSpan(
                text: "RSI:${format(data.k)}    ",
                style: getTextStyle(this.chartColors.kColor)),
          TextSpan(
                text: "MFI:${format(data.d)}    ",
                style: getTextStyle(this.chartColors.dColor)),      
          // if (data.macd != 0)
          //   TextSpan(
          //       text: "K:${format(data.k)}    ",
          //       style: getTextStyle(this.chartColors.kColor)),
          // if (data.dif != 0)
          //   TextSpan(
          //       text: "D:${format(data.d)}    ",
          //       style: getTextStyle(this.chartColors.dColor)),
          // if (data.dea != 0)
          //   TextSpan(
          //       text: "J:${format(data.j)}    ",
          //       style: getTextStyle(this.chartColors.jColor)),
        ];
        break;
      case SecondaryState.RSI:
        children = [
          TextSpan(
              text: "RSI(14):${format(data.rsi)}    ",
              style: getTextStyle(this.chartColors.rsiColor)),
        ];
        break;
      case SecondaryState.WR:
        children = [
          TextSpan(
              text: "WR(14):${format(data.r)}    ",
              style: getTextStyle(this.chartColors.rsiColor)),
        ];
        break;
      case SecondaryState.CCI:
        children = [
          TextSpan(
              text: "CCI(14):${format(data.cci)}    ",
              style: getTextStyle(this.chartColors.rsiColor)),
        ];
        break;
      default:
        break;
    }
    TextPainter tp = TextPainter(
        text: TextSpan(children: children ?? []),
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x, chartRect.top - topPadding));
  }

  @override
  void drawRightText(canvas, textStyle, int gridRows) {
    TextPainter maxTp = TextPainter(
        text: TextSpan(text: "${format(maxValue)}", style: textStyle),
        textDirection: TextDirection.ltr);
    maxTp.layout();
    TextPainter minTp = TextPainter(
        text: TextSpan(text: "${format(minValue)}", style: textStyle),
        textDirection: TextDirection.ltr);
    minTp.layout();

    maxTp.paint(canvas,
        Offset(chartRect.width - maxTp.width, chartRect.top - topPadding));
    minTp.paint(canvas,
        Offset(chartRect.width - minTp.width, chartRect.bottom - minTp.height));
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns) {
    canvas.drawLine(Offset(0, chartRect.top),
        Offset(chartRect.width, chartRect.top), gridPaint);
    canvas.drawLine(Offset(0, chartRect.bottom),
        Offset(chartRect.width, chartRect.bottom), gridPaint);
    double columnSpace = chartRect.width / gridColumns;
    for (int i = 0; i <= columnSpace; i++) {
      //mSecondaryRect垂直线
      canvas.drawLine(Offset(columnSpace * i, chartRect.top - topPadding),
          Offset(columnSpace * i, chartRect.bottom), gridPaint);
    }
  }
}
