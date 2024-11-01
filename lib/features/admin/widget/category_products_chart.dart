import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:amazon_clone_tutorial/features/admin/models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> salesData;

  const CategoryProductsChart({
    super.key,
    required this.salesData,
  });

  @override
  Widget build(BuildContext context) {
    final double maxY = salesData.map((sales) => sales.earning).reduce((a, b) => a > b ? a : b).toDouble() * 1.1;
    final double roundedMaxY = (maxY / 1000).ceil() * 1000;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: roundedMaxY,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < salesData.length) {
                  return Text(salesData[index].label,
                      style: const TextStyle(fontSize: 10));
                } else {
                  return const Text('');
                }
              },
              reservedSize: 28,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: salesData.asMap().entries.map((entry) {
          int index = entry.key;
          Sales sales = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: sales.earning.toDouble(),
                color: Colors.blue,
                width: 20,
                borderRadius: BorderRadius.zero,
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.grey,
              strokeWidth: 0.5,
            );
          },
        ),
      ),
    );
  }
}
