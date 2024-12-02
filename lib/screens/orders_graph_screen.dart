
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/enum.dart';
import '../utils/json_loader.dart';
import '../widgets/bar_graph.dart';
import '../widgets/line_graph.dart';
import '../widgets/pie_graph.dart';


class OrdersGraphScreen extends StatefulWidget {
  const OrdersGraphScreen({super.key});

  @override
  OrdersGraphScreenState createState() => OrdersGraphScreenState();
}

class OrdersGraphScreenState extends State<OrdersGraphScreen> {
  final int batchSize = 20;
  int currentIndex = 0;
  bool isLoading = false;
  List<Order> displayedOrders = [];
  final ScrollController _scrollController = ScrollController();

  late Future<List<Order>> orders;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    orders = loadJsonData('assets/orders.json').then(Order.fromJsonList);
    loadMoreOrders();
  }

  void loadMoreOrders() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final List<Order> allOrders = await orders;
    final nextBatch = allOrders.sublist(
      currentIndex,
      currentIndex + batchSize > allOrders.length
          ? allOrders.length
          : currentIndex + batchSize,
    );

    setState(() {
      displayedOrders.addAll(nextBatch);
      currentIndex += nextBatch.length;
      isLoading = false;
    });
  }
  Map<String, int> _generateOrdersByDate(List<Order> orders) {
    final Map<String, int> ordersByDate = {};

    for (var order in orders) {
      final date = order.registered.toIso8601String().split('T')[0];
      ordersByDate.update(date, (count) => count + 1, ifAbsent: () => 1);
    }

    return ordersByDate;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Order>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          final ordersData = snapshot.data ?? [];
          if (ordersData.isEmpty) {
            return const Center(child: Text("No orders available"));
          }

          final ordersByDate = _generateOrdersByDate(ordersData);

          final maxOrdersPerDate = ordersByDate.values.isNotEmpty
              ? ordersByDate.values
                  .reduce((max, value) => value > max ? value : max)
              : 0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const Center(child: CircularProgressIndicator.adaptive()),
              _buildChartSelector(),
              const SizedBox(
                height: 50,
              ),
              _buildChart(ordersByDate, maxOrdersPerDate,context,_scrollController,
              )],
          );
        },
      ),
    );
  }


  Widget _buildChart(Map<String, int> ordersByDate, int maxOrdersPerDate,BuildContext context,ScrollController scrollController) {
    switch (_selectedChartType) {
      case ChartType.line:
        return buildLineGraph(ordersByDate, maxOrdersPerDate,context,scrollController);
      case ChartType.bar:
        return buildBarGraph(ordersByDate, maxOrdersPerDate,context,scrollController);
      case ChartType.pie:
        return buildOrderCountPieChart(ordersByDate);
      default:
        return const SizedBox.shrink(); // Fallback in case of an invalid value
    }
  }



  ChartType _selectedChartType = ChartType.line;

  Widget _buildChartSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButton<ChartType>(
        value: _selectedChartType,
        onChanged: (ChartType? newValue) {
          setState(() {
            _selectedChartType = newValue!;
          });
        },
        items: const [
          DropdownMenuItem(
            value: ChartType.line,
            child: Text('Line Chart'),
          ),
          DropdownMenuItem(
            value: ChartType.bar,
            child: Text('Bar Chart'),
          ),
          DropdownMenuItem(
            value: ChartType.pie,
            child: Text('Pie Chart'),
          ),
        ],
      ),
    );
  }

}


