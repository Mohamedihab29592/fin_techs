import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';




Widget buildLineGraph(
    Map<String, int> ordersByDate,
    int maxOrdersPerDate,
    BuildContext context,
    ScrollController scrollController
    ) {
  final List<String> dates = ordersByDate.keys.toList();
  final List<int> orderCounts = ordersByDate.values.toList();

  final List<FlSpot> spots = List.generate(dates.length, (index) {
    return FlSpot(index.toDouble(), orderCounts[index].toDouble());
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
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    color: Colors.blueAccent,
                    barWidth: 2,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                minX: 0,
                maxX: dates.length.toDouble(),
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
                      reservedSize: 40,
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