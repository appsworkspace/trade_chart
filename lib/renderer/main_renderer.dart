import 'package:flutter/material.dart';

import '../entity/candle_entity.dart';
import '../k_chart_widget.dart' show MainState;
import 'base_chart_renderer.dart';

class MainRenderer extends BaseChartRenderer<CandleEntity> {
  late double mCandleWidth;
  late double mCandleLineWidth;
  MainState state;
  bool isLine;

  late Rect _contentRect;
  double _contentPadding = 5.0;
  List<int> maDayList;
  final ChartStyle chartStyle;
  final ChartColors chartColors;
  final double mLineStrokeWidth = 1.0;
  double scaleX;
  late Paint mLinePaint;

  MainRenderer(
      Rect mainRect,
      double maxValue,
      double minValue,
      double topPadding,
      this.state,
      this.isLine,
      int fixedLength,
      this.chartStyle,
      this.chartColors,
      this.scaleX,
      [this.maDayList = const [5, 10, 20]])
      : super(
            chartRect: mainRect,
            maxValue: maxValue,
            minValue: minValue,
            topPadding: topPadding,
            fixedLength: fixedLength,
            gridColor: chartColors.gridColor) {
    mCandleWidth = this.chartStyle.candleWidth;
    mCandleLineWidth = this.chartStyle.candleLineWidth;
    mLinePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = mLineStrokeWidth
      ..color = this.chartColors.kLineColor;
    _contentRect = Rect.fromLTRB(
        chartRect.left,
        chartRect.top + _contentPadding,
        chartRect.right,
        chartRect.bottom - _contentPadding);
    if (maxValue == minValue) {
      maxValue *= 1.5;
      minValue /= 2;
    }
    scaleY = _contentRect.height / (maxValue - minValue);
  }

  @override
  void drawText(Canvas canvas, CandleEntity data, double x) {
    if (isLine == true) return;
    TextSpan? span;
    TextSpan? span2;
    TextSpan? span3;
    TextSpan? span4;
    if (state == MainState.MA) {
      span = TextSpan(
        children: _createMATextSpan(data),
      );
    } else if (state == MainState.BOLL) {
      span = TextSpan(
        children: [
          if (data.up != 0)
            TextSpan(
                text: "BOLL:${format(data.mb)}    ",
                style: getTextStyle(this.chartColors.ma5Color)),
          if (data.mb != 0)
            TextSpan(
                text: "UB:${format(data.up)}    ",
                style: getTextStyle(this.chartColors.ma10Color)),
          if (data.dn != 0)
            TextSpan(
                text: "LB:${format(data.dn)}    ",
                style: getTextStyle(this.chartColors.ma30Color)),
        ],
      );
      span2 = TextSpan(children: []);
      span3 = TextSpan(children: []);
    } else if (state == MainState.MAC) {
      span = TextSpan(children: [
        if (data.top_box != 0)
          TextSpan(
              text: "TBox(5) (${format(data.top_box)})  ",
              style: getTextStyle2(this.chartColors.TBoxColor)),
        if (data.bottom_box != 0)
          TextSpan(
              text: "BBox(5) (${format(data.bottom_box)})  ",
              style: getTextStyle2(this.chartColors.BBoxColor)),
        if (data.moving_average != 0)
          TextSpan(
              text: "MA(14) (${format(data.moving_average)})  ",
              style: getTextStyle2(this.chartColors.ma20Color)),
        if (data.mac_high != 0)
          TextSpan(
              text: "MACHigh(5) (${format(data.mac_high)})  ",
              style: getTextStyle2(this.chartColors.maHighColor)),
      ]);
      span2 = TextSpan(
        children: [],
      );
      span3 = TextSpan(
        children: [],
      );
    }
    if (span == null) return;
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(x, chartRect.top - topPadding));

    TextPainter tp2 =
        TextPainter(text: span2, textDirection: TextDirection.ltr);
    tp2.layout();
    tp2.paint(canvas, Offset(x, chartRect.top - topPadding + 15));

    TextPainter tp3 =
        TextPainter(text: span3, textDirection: TextDirection.ltr);
    tp3.layout();
    tp3.paint(canvas, Offset(x, chartRect.top - topPadding + 30));
  }

  List<InlineSpan> _createMATextSpan(CandleEntity data) {
    List<InlineSpan> result = [];
    for (int i = 0; i < (data.maValueList?.length ?? 0); i++) {
      if (data.maValueList?[i] != 0) {
        var item = TextSpan(
            text: "MA${maDayList[i]}:${format(data.maValueList![i])}    ",
            style: getTextStyle(this.chartColors.getMAColor(i)));
        result.add(item);
      }
    }
    return result;
  }

  @override
  void drawChart(CandleEntity lastPoint, CandleEntity curPoint, double lastX,
      double curX, Size size, Canvas canvas) {
    if (isLine != true) {
      drawCandle(curPoint, canvas, curX);
      drawRSISignal(curPoint, canvas, curX);
      drawStochKDSignal(curPoint, canvas, curX);
    }
    if (isLine == true) {
      drawPolyline(lastPoint.close, curPoint.close, canvas, lastX, curX);
    } else if (state == MainState.MA) {
      drawMaLine(lastPoint, curPoint, canvas, lastX, curX);
    } else if (state == MainState.BOLL) {
      drawBollLine(lastPoint, curPoint, canvas, lastX, curX);
    } else if (state == MainState.MAC) {
      drawMACLine(lastPoint, curPoint, canvas, lastX, curX);
    }
  }

  Shader? mLineFillShader;
  Path? mLinePath, mLineFillPath;
  Paint mLineFillPaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  Paint painter = Paint()
    ..color = Colors.purpleAccent
    ..style = PaintingStyle.fill;

  drawPolyline(double lastPrice, double curPrice, Canvas canvas, double lastX,
      double curX) {
    mLinePath ??= Path();
    if (lastX == curX) lastX = 0; //起点位置填充
    mLinePath!.moveTo(lastX, getY(lastPrice));
    mLinePath!.cubicTo((lastX + curX) / 2, getY(lastPrice), (lastX + curX) / 2,
        getY(curPrice), curX, getY(curPrice));

    mLineFillShader ??= LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.clamp,
      colors: [this.chartColors.lineFillColor, Colors.transparent],
    ).createShader(Rect.fromLTRB(
        chartRect.left, chartRect.top, chartRect.right, chartRect.bottom));
    mLineFillPaint..shader = mLineFillShader;

    mLineFillPath ??= Path();

    mLineFillPath!.moveTo(lastX, chartRect.height + chartRect.top);
    mLineFillPath!.lineTo(lastX, getY(lastPrice));
    mLineFillPath!.cubicTo((lastX + curX) / 2, getY(lastPrice),
        (lastX + curX) / 2, getY(curPrice), curX, getY(curPrice));
    mLineFillPath!.lineTo(curX, chartRect.height + chartRect.top);
    mLineFillPath!.close();

    canvas.drawPath(mLineFillPath!, mLineFillPaint);
    mLineFillPath!.reset();

    canvas.drawPath(mLinePath!,
        mLinePaint..strokeWidth = (mLineStrokeWidth / scaleX).clamp(0.1, 1.0));
    mLinePath!.reset();
  }

  void drawMaLine(CandleEntity lastPoint, CandleEntity curPoint, Canvas canvas,
      double lastX, double curX) {
    for (int i = 0; i < (curPoint.maValueList?.length ?? 0); i++) {
      if (i == 3) {
        break;
      }
      if (lastPoint.maValueList?[i] != 0) {
        drawLine(lastPoint.maValueList?[i], curPoint.maValueList?[i], canvas,
            lastX, curX, this.chartColors.getMAColor(i));
      }
    }
  }

  void drawBollLine(CandleEntity lastPoint, CandleEntity curPoint,
      Canvas canvas, double lastX, double curX) {
    if (lastPoint.up != 0) {
      drawLine(lastPoint.up, curPoint.up, canvas, lastX, curX,
          this.chartColors.ma10Color);
    }
    if (lastPoint.mb != 0) {
      drawLine(lastPoint.mb, curPoint.mb, canvas, lastX, curX,
          this.chartColors.ma5Color);
    }
    if (lastPoint.dn != 0) {
      drawLine(lastPoint.dn, curPoint.dn, canvas, lastX, curX,
          this.chartColors.ma30Color);
    }
  }

  void drawMACLine(CandleEntity lastPoint, CandleEntity curPoint, Canvas canvas,
      double lastX, double curX) {
    // Top Box Bottom Box
    if (lastPoint.top_box != 0) {
      final Paint paint = Paint();
      paint.color = this.chartColors.TBoxColor;
      paint.strokeCap = StrokeCap.square;
      paint.strokeWidth = 1.5;
      drawLine2(
          lastPoint.top_box, curPoint.top_box, canvas, lastX, curX, paint);
    }
    if (lastPoint.bottom_box != 0) {
      final Paint paint = Paint();
      paint.color = this.chartColors.BBoxColor;
      paint.strokeCap = StrokeCap.square;
      paint.strokeWidth = 1.5;
      drawLine2(lastPoint.bottom_box, curPoint.bottom_box, canvas, lastX, curX,
          paint);
    }
    if (lastPoint.moving_average != 0) {
      final Paint paint = Paint();
      paint.color = this.chartColors.ma20Color;
      paint.strokeCap = StrokeCap.square;
      paint.strokeWidth = 1.5;
      drawLine2(lastPoint.moving_average, curPoint.moving_average, canvas,
          lastX, curX, paint);
    }
    if (lastPoint.mac_high != 0) {
      final Paint paint = Paint();
      paint.color = this.chartColors.maHighColor;
      paint.strokeCap = StrokeCap.square;
      paint.strokeWidth = 1.5;
      drawLine2(
          lastPoint.mac_high, curPoint.mac_high, canvas, lastX, curX, paint);
    }
  }

  void drawStochKDSignal(CandleEntity curPoint, Canvas canvas, double curX) {
    var high = getY(curPoint.high);
    var low = getY(curPoint.low);
    var open = getY(curPoint.open);
    var close = getY(curPoint.close);
    var path = Path();
    double r = mCandleWidth / 2;
    double lineR = mCandleLineWidth / 2;
    if (open >= close) {
      // SELL
      if (curPoint.stochastic_kd_flag == "SHORT" &&
          (curPoint.open - curPoint.low) < ((curPoint.high - curPoint.close))) {
        chartPaint.color = this.chartColors.stockKDSell;
        path.moveTo(curX - 5, high - 25);
        path.lineTo(curX, high - 15);
        path.lineTo(curX + 5, high - 25);
        path.close();
        canvas.drawPath(path, chartPaint);
      }
      // BUY
      if (curPoint.stochastic_kd_flag == "LONG" &&
          (curPoint.open - curPoint.low) > ((curPoint.high - curPoint.close))) {
        chartPaint.color = this.chartColors.stochKDBuy;
        path.moveTo(curX - 5, low + 25);
        path.lineTo(curX, low + 15);
        path.lineTo(curX + 5, low + 25);
        path.close();
        canvas.drawPath(path, chartPaint);
      }
    } else if (close > open) {
      // SELL
      if (curPoint.stochastic_kd_flag == "SHORT" &&
          (curPoint.open - curPoint.low) < ((curPoint.high - curPoint.close))) {
        chartPaint.color = this.chartColors.stockKDSell;
        path.moveTo(curX - 5, high - 25);
        path.lineTo(curX, high - 15);
        path.lineTo(curX + 5, high - 25);
        path.close();
        canvas.drawPath(path, chartPaint);
      }
      // BUY
      if (curPoint.stochastic_kd_flag == "LONG" &&
          (curPoint.open - curPoint.low) > ((curPoint.high - curPoint.close))) {
        chartPaint.color = this.chartColors.stochKDBuy;
        path.moveTo(curX - 5, low + 15);
        path.lineTo(curX, low + 5);
        path.lineTo(curX + 5, low + 15);
        path.close();
        canvas.drawPath(path, chartPaint);
      }
    }
  }

  void drawRSISignal(CandleEntity curPoint, Canvas canvas, double curX) {
    var high = getY(curPoint.high);
    var low = getY(curPoint.low);
    var open = getY(curPoint.open);
    var close = getY(curPoint.close);
    var path = Path();
    double r = mCandleWidth / 2;
    double lineR = mCandleLineWidth / 2;
    if (open >= close) {
      // SELL
      if (curPoint.rsi_flag == "SHORT" &&
          (curPoint.open - curPoint.low) < ((curPoint.high - curPoint.close))) {
        chartPaint.color = this.chartColors.rsiSell;
        path.moveTo(curX - 5, high - 20);
        path.lineTo(curX, high);
        path.lineTo(curX + 5, high - 20);
        path.close();
        canvas.drawPath(path, chartPaint);
      }
      // BUY
      if (curPoint.rsi_flag == "LONG" &&
          (curPoint.open - curPoint.low) > ((curPoint.high - curPoint.close))) {
        chartPaint.color = this.chartColors.rsiBuy;
        path.moveTo(curX - 5, low + 15);
        path.lineTo(curX, low + 5);
        path.lineTo(curX + 5, low + 15);
        path.close();
        canvas.drawPath(path, chartPaint);
      }
    } else if (close > open) {
      // SELL
      if (curPoint.rsi_flag == "SHORT" &&
          (curPoint.open - curPoint.low) < ((curPoint.high - curPoint.close))) {
        chartPaint.color = this.chartColors.rsiSell;
        path.moveTo(curX - 5, high - 15);
        path.lineTo(curX, high - 5);
        path.lineTo(curX + 5, high - 15);
        path.close();
        canvas.drawPath(path, chartPaint);
      }
      // BUY
      if (curPoint.rsi_flag == "LONG" &&
          (curPoint.open - curPoint.low) > ((curPoint.high - curPoint.close))) {
        chartPaint.color = this.chartColors.rsiBuy;
        path.moveTo(curX - 5, low + 15);
        path.lineTo(curX, low + 5);
        path.lineTo(curX + 5, low + 15);
        path.close();
        canvas.drawPath(path, chartPaint);
      }
    }
  }

  void drawCandle(CandleEntity curPoint, Canvas canvas, double curX) {
    var high = getY(curPoint.high);
    var low = getY(curPoint.low);
    var open = getY(curPoint.open);
    var close = getY(curPoint.close);
    double r = mCandleWidth / 1.8;
    double lineR = mCandleLineWidth / 2;
    if (open >= close) {
      // 实体高度>= CandleLineWidth
      if (open - close < mCandleLineWidth) {
        open = close + mCandleLineWidth;
      }
      chartPaint.color = this.chartColors.upColor;
      canvas.drawRect(
          Rect.fromLTRB(curX - r, close, curX + r, open), chartPaint);
      canvas.drawRect(
          Rect.fromLTRB(curX - lineR, high, curX + lineR, low), chartPaint);
    } else if (close > open) {
      // 实体高度>= CandleLineWidth
      if (close - open < mCandleLineWidth) {
        open = close - mCandleLineWidth;
      }
      chartPaint.color = this.chartColors.dnColor;
      canvas.drawRect(
          Rect.fromLTRB(curX - r, open, curX + r, close), chartPaint);
      canvas.drawRect(
          Rect.fromLTRB(curX - lineR, high, curX + lineR, low), chartPaint);
    }
  }

  @override
  void drawRightText(canvas, textStyle, int gridRows) {
    double rowSpace = chartRect.height / gridRows;
    for (var i = 0; i <= gridRows; ++i) {
      double value = (gridRows - i) * rowSpace / scaleY + minValue;
      TextSpan span = TextSpan(text: "${format(value)}", style: textStyle);
      TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      if (i == 0) {
        tp.paint(canvas, Offset(chartRect.width - tp.width, topPadding));
      } else {
        tp.paint(
            canvas,
            Offset(chartRect.width - tp.width,
                rowSpace * i - tp.height + topPadding));
      }
    }
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns) {
//    final int gridRows = 4, gridColumns = 4;
    double rowSpace = chartRect.height / gridRows;
    for (int i = 0; i <= gridRows; i++) {
      canvas.drawLine(Offset(0, rowSpace * i + topPadding),
          Offset(chartRect.width, rowSpace * i + topPadding), gridPaint);
    }
    double columnSpace = chartRect.width / gridColumns;
    for (int i = 0; i <= columnSpace; i++) {
      canvas.drawLine(Offset(columnSpace * i, topPadding / 3),
          Offset(columnSpace * i, chartRect.bottom), gridPaint);
    }
  }

  @override
  double getY(double y) {
    return (maxValue - y) * scaleY + _contentRect.top;
  }
}
