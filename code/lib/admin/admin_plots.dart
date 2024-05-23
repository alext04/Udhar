import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';


// widget called in the home screen to show analytics for the home screen
// currently filled with prefilled data due to lack of user data
class GraphsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      color: Colors.black,
      child: PageView(
        children: <Widget>[
          _buildChart(
            title: "Weekly Profit",
            data: [
              FlSpot(0, 3),
              FlSpot(1, 4),
              FlSpot(2, 5),
              FlSpot(3, 5.5),
              FlSpot(4, 6),
              FlSpot(5, 7),
            ],
            color: Colors.blue,
            
            description: "Total profit made on a weekly basis.",
          ),
          _buildChart(
            data: [
              FlSpot(0, 20),
              FlSpot(1, 23),
              FlSpot(2, 25),
              FlSpot(3, 22),
              FlSpot(4, 30),
              FlSpot(5, 32),
            ],
            color: Colors.red,
            title: "User Base Count",
            description: "Total user base count over time.",
          ),
        ],
      ),
    );
  }

  Widget _buildChart({
    required List<FlSpot> data,
    required Color color,
    required String title,
    required String description,
  }) {
    DateTime startDate = DateTime(2023, 4, 1); // Starting from April 2023

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              backgroundColor: Colors.black,
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.white24, strokeWidth: 1);
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(color: Colors.white24, strokeWidth: 1);
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      DateTime weekDate = startDate.add(Duration(days: (value.toInt() * 7)));
                      String month = DateFormat('MMM').format(weekDate);
                      int weekOfYear = ((weekDate.difference(startDate).inDays) / 7).ceil();
                      return Text(
                        '$month $weekOfYear',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      );
                    },
                    interval: 1, // Ensures a label for every point
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toInt()}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                  isCurved: true,
                  barWidth: 2,
                  color: color,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
