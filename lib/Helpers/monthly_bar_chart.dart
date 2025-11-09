import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<String> months;
  final List<double> values;

  const MonthlyBarChart({
    super.key,
    required this.months,
    required this.values,
  });

  // ✅ Format Numbers like: 1200 → 1,200
  String formatNumber(double value) {
    return NumberFormat('#,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(   // ✅ background color
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                formatNumber(rod.toY),             // ✅ format value
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),

        barGroups: _buildBarGroups(),

        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= months.length) return const SizedBox();
                return Text(months[index]);
              },
            ),
          ),
        ),

        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(months.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: values[i],
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
