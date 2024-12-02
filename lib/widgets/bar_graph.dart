import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget buildBarGraph(Map<String, int> ordersByDate, int maxOrdersPerDate,BuildContext context ,ScrollController scrollController) {
  final List<String> dates = ordersByDate.keys.toList();
  final List<int> orderCounts = ordersByDate.values.toList();

  // Bar chart data preparation
  final barData = List.generate(dates.length, (index) {
    return BarChartGroupData(
      x: index,
      barsSpace: 4,
      barRods: [
        BarChartRodData(
          toY: orderCounts[index].toDouble(),
          color: Colors.blueAccent,
          width: 16,
          borderRadius: BorderRadius.zero,
        ),
      ],
    );
  });

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      height: 300,
      child: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: dates.length * 60.0,
              maxWidth:
              max(dates.length * 60.0, MediaQuery.of(context).size.width),
            ),
            child: BarChart(
              BarChartData(
                barGroups: barData,
                minY: 0,
                maxY: maxOrdersPerDate > 5 ? maxOrdersPerDate.toDouble() : 5,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < dates.length) {
                          final date = dates[value.toInt()];
                          final day = date.substring(8, 10);
                          final month = date.substring(5, 7);
                          final year = date.substring(2, 4);

                          final formattedDate = '$year-$month-$day';
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                  fontSize: kIsWeb ? 10.0 : 12.0),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      interval: 1,
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 5,
                      getTitlesWidget: (value, meta) {
                        final int orderCount = value.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            orderCount.toString(),
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
