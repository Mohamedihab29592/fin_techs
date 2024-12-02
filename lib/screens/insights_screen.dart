import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../widgets/layouts.dart';
import '../widgets/responsive_wrapper.dart';
import '../utils/json_loader.dart';

class InsightsScreen extends StatelessWidget {
  final Future<List<Order>> orders;

  InsightsScreen({super.key})
      : orders = loadJsonData('assets/orders.json').then(Order.fromJsonList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Order>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders available'));
          }

          final data = snapshot.data!;
          final totalOrders = data.length;
          final avgPrice = data
              .map((e) => double.tryParse(e.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0)
              .reduce((a, b) => a + b) / totalOrders;
          final returnsCount = data.where((order) => order.status == 'RETURNED').length;

          return ResponsiveWrapper(
            mobile: buildSingleColumnLayout(totalOrders, avgPrice, returnsCount),
            tablet: buildGridLayout(totalOrders, avgPrice, returnsCount, crossAxisCount: 2),
            desktop: buildGridLayout(totalOrders, avgPrice, returnsCount, crossAxisCount: 3),
          );
        },
      ),

    );
  }


}
