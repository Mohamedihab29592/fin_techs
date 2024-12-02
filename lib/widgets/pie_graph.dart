import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/legend_item.dart';

Widget buildOrderCountPieChart(Map<String, int> ordersByDate) {
  // Count how many dates have 0, 1, 2, 3, 4, 5 (or more) orders
  final orderCountMap = <int, int>{};

  ordersByDate.forEach((date, orderCount) {
    orderCountMap[orderCount] = (orderCountMap[orderCount] ?? 0) + 1;
  });

  // Prepare pie chart data with the count of orders for each order number (0, 1, 2, etc.)
  final pieChartData = orderCountMap.entries.map((entry) {
    final orderCount = entry.key;
    final count = entry.value;

    return PieChartSectionData(
      radius: 150,
      value: count.toDouble(),
      color: _getColorForOrderCount(orderCount),
      title: '${((count / ordersByDate.length) * 100).toStringAsFixed(1)}%',
      // Percentage
      titleStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }).toList();

  // Generate legend data for all possible order counts from 0 to 5
  final legendData = List.generate(6, (index) {
    return LegendItem(
      orderCount: index,
      color: _getColorForOrderCount(index),
    );
  });

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: pieChartData,
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 30,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend: Show all order counts from 0 to 5, even if not present in the data
        Wrap(
          children: legendData.map((legendItem) {
            return Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: legendItem.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    legendItem.orderCount > 1
                        ? '${legendItem.orderCount} Orders'
                        : '${legendItem.orderCount} Order',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
Color _getColorForOrderCount(int orderCount) {
  final colors = [
    Colors.grey, // For 0 orders
    Colors.blueAccent, // For 1 order
    Colors.greenAccent, // For 2 orders
    Colors.orangeAccent, // For 3 orders
    Colors.redAccent, // For 4 orders
    Colors.purpleAccent, // For 5 orders
  ];

  // Ensure the color corresponds to the order count, with a fallback for order count greater than 5
  return colors[orderCount < 6
      ? orderCount
      : 5]; // Use the color for the last index if order count > 5
}
