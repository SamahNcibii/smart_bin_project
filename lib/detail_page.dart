import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final double temperature;
  final int niveau;

  const DetailPage({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.temperature,
    required this.niveau,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, color: color, size: 80),
            const SizedBox(height: 20),
            Text(
              value,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 30),

            // Température avec jauge
if (title == "Température") ...[
  const Text(
    "Température actuelle",
    style: TextStyle(fontSize: 20),
  ),
  const SizedBox(height: 20),
  SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
        minimum: 0,
        maximum: 50,
        ranges: <GaugeRange>[
          GaugeRange(startValue: 0, endValue: 20, color: Colors.blue),
          GaugeRange(startValue: 20, endValue: 35, color: Colors.orange),
          GaugeRange(startValue: 35, endValue: 50, color: Colors.red),
        ],
        pointers: <GaugePointer>[
          NeedlePointer(value: temperature),
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
            widget: Text(
              '$temperature°C',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            angle: 90,
            positionFactor: 0.5,
          ),
        ],
      ),
    ],
  ),
],


            // GaugeChart pour le niveau de remplissage
            if (title == "Niveau de remplissage") ...[
              const Text(
                "Niveau de remplissage",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              SfRadialGauge(
                axes: [
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    ranges: [
                      GaugeRange(
                        startValue: 0,
                        endValue: 100,
                        color: Colors.green,
                      ),
                    ],
                    pointers: [
                      NeedlePointer(value: niveau.toDouble()),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
