import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OwnerRevenueScreen extends StatefulWidget {
  const OwnerRevenueScreen({super.key});

  @override
  State<OwnerRevenueScreen> createState() => _OwnerRevenueScreenState();
}

class _OwnerRevenueScreenState extends State<OwnerRevenueScreen> {
  bool _isLoading = true;
  List<RevenueData> _revenueData = [];

  @override
  void initState() {
    super.initState();
    _loadRevenueData();
  }

  void _loadRevenueData() {
    // Simulate loading data from API
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _revenueData = [
          RevenueData(month: 'Jan', revenue: 50000),
          RevenueData(month: 'Feb', revenue: 60000),
          RevenueData(month: 'Mar', revenue: 70000),
          RevenueData(month: 'Apr', revenue: 80000),
          RevenueData(month: 'May', revenue: 75000),
          RevenueData(month: 'Jun', revenue: 85000),
          RevenueData(month: 'Jul', revenue: 90000),
          RevenueData(month: 'Aug', revenue: 95000),
          RevenueData(month: 'Sep', revenue: 100000),
          RevenueData(month: 'Oct', revenue: 110000),
          RevenueData(month: 'Nov', revenue: 120000),
          RevenueData(month: 'Dec', revenue: 130000),
        ];
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Revenue Analytics')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Revenue',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY:
                              _revenueData
                                  .map((d) => d.revenue.toDouble())
                                  .reduce((a, b) => a > b ? a : b) *
                              1.2,
                          barGroups:
                              _revenueData.asMap().entries.map((entry) {
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.revenue.toDouble(),
                                      color: Theme.of(context).primaryColor,
                                      width: 16,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value < 0 ||
                                      value >= _revenueData.length) {
                                    return const Text('');
                                  }
                                  return Text(
                                    _revenueData[value.toInt()].month,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '₹${(value / 1000).toStringAsFixed(0)}K',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                                reservedSize: 40,
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 20000,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withAlpha(51),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class RevenueData {
  final String month;
  final int revenue;

  RevenueData({required this.month, required this.revenue});
}
