import 'package:catchmypain/model/condition_model.dart';
import 'package:catchmypain/model/painHistory_model.dart';
import 'package:flutter/material.dart';

class FilledBelowCurvedPainter extends CustomPainter {
  final List<dynamic> chartData;
  final double containerHeight;
  final int levelLenth;
  final double iconSize;
  Map<String, dynamic> moodsToInt = {
    'VERY_BAD': 1,
    'BAD': 2,
    'NORMAL': 3,
    'GOOD': 4,
    'VERY_GOOD': 5
  };

  FilledBelowCurvedPainter(
      this.chartData, this.containerHeight, this.levelLenth, this.iconSize);

  //level 반환 : painHistory data
  //condition 반환 : condition data
  String checkData(List<dynamic> chartData) {
    // 첫 번째 요소가 ConditionModel 객체인지 확인합니다.
    if (chartData[0] is ConditionModel) {
      print('conditionModel');
      return 'condition';
    } else if (chartData[0] is PainHistoryModel) {
      return 'level';
    }
    return ''; // 기본값을 반환합니다. 필요에 따라 다른 값을 설정할 수 있습니다.
  }

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.amber.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    String keyData = chartData.isNotEmpty ? checkData(chartData) : '';
    Path path = Path();
    Path fillPath = Path();

    switch (keyData) {
      //painHistory data
      case 'level':
        if (chartData.length > 1) {
          double startX = (size.width / chartData.length) * 0 +
              (size.width / chartData.length) / 2;
          double startY = containerHeight -
              (chartData[0].level.toDouble() * (containerHeight / levelLenth)) +
              iconSize / 2;

          fillPath.moveTo(startX, size.height);
          fillPath.lineTo(startX, startY);
          path.moveTo(startX, startY);

          for (int i = 0; i < chartData.length - 1; i++) {
            double endX = (size.width / chartData.length) * (i + 1) +
                (size.width / chartData.length) / 2;
            double endY = containerHeight -
                (chartData[i + 1].level.toDouble() *
                    (containerHeight / levelLenth)) +
                iconSize / 2;

            double midX = (startX + endX) / 2;
            path.quadraticBezierTo(
                midX, i % 2 == 0 ? startY : endY, endX, endY);
            fillPath.quadraticBezierTo(
                midX, i % 2 == 0 ? startY : endY, endX, endY);

            startX = endX;
            startY = endY;
          }

          fillPath.lineTo(startX, size.height);
          fillPath.close();
        }
        canvas.drawPath(fillPath, fillPaint);
        canvas.drawPath(path, strokePaint);
        break;

      //condition data
      case 'condition':
        if (chartData.length > 1) {
          double startX = (size.width / chartData.length) * 0 +
              (size.width / chartData.length) / 2;
          double startY = containerHeight -
              (moodsToInt[chartData[0].condition] *
                  (containerHeight / levelLenth)) +
              (containerHeight / levelLenth) / 2;

          fillPath.moveTo(startX, size.height);
          fillPath.lineTo(startX, startY);
          path.moveTo(startX, startY);

          for (int i = 0; i < chartData.length - 1; i++) {
            double endX = (size.width / chartData.length) * (i + 1) +
                (size.width / chartData.length) / 2;
            double endY = containerHeight -
                (moodsToInt[chartData[i + 1].condition] *
                    (containerHeight / levelLenth)) +
                (containerHeight / levelLenth) / 2;

            double midX = (startX + endX) / 2;
            path.quadraticBezierTo(
                midX, i % 2 == 0 ? startY : endY, endX, endY);
            fillPath.quadraticBezierTo(
                midX, i % 2 == 0 ? startY : endY, endX, endY);

            startX = endX;
            startY = endY;
          }

          fillPath.lineTo(startX, size.height);
          fillPath.close();
        }
        canvas.drawPath(fillPath, fillPaint);
        canvas.drawPath(path, strokePaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}