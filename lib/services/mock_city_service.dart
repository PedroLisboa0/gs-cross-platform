import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/service_metric.dart';

class CitySnapshot {
  const CitySnapshot({
    required this.territory,
    required this.updatedAt,
    required this.services,
  });

  final String territory;
  final DateTime updatedAt;
  final List<ServiceMetric> services;

  factory CitySnapshot.fromJson(Map<String, dynamic> json) {
    return CitySnapshot(
      territory: json['territory'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      services: (json['services'] as List<dynamic>)
          .map((item) => ServiceMetric.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MockCityService {
  Future<CitySnapshot> fetchSnapshot() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final raw = await rootBundle.loadString('lib/data/sample_data.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final snapshot = CitySnapshot.fromJson(decoded);
    if (snapshot.services.isEmpty) {
      throw const FormatException('O conjunto de indicadores está vazio.');
    }
    return snapshot;
  }
}
