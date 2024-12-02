import 'package:flutter/material.dart';

import 'metric_card.dart';

Widget buildSingleColumnLayout(int totalOrders, double avgPrice, int returnsCount) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,

    children: [
      MetricCard(title: 'Total Orders', value: '$totalOrders'),
      MetricCard(title: 'Average Price', value: '\$${avgPrice.toStringAsFixed(2)}'),
      MetricCard(title: 'Returns', value: '$returnsCount'),
    ],
  );
}
Widget buildGridLayout(int totalOrders, double avgPrice, int returnsCount, {int crossAxisCount = 2}) {
  return GridView.count(
    crossAxisCount: crossAxisCount,
    padding: const EdgeInsets.all(16.0),
    children: [
      MetricCard(title: 'Total Orders', value: '$totalOrders'),
      MetricCard(title: 'Average Price', value: '\$${avgPrice.toStringAsFixed(2)}'),
      MetricCard(title: 'Returns', value: '$returnsCount'),
    ],
  );
}
