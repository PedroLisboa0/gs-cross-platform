class NeighborhoodMetric {
  const NeighborhoodMetric({
    required this.name,
    required this.demand,
    required this.capacity,
  });

  final String name;
  final int demand;
  final int capacity;

  factory NeighborhoodMetric.fromJson(Map<String, dynamic> json) {
    return NeighborhoodMetric(
      name: json['name'] as String,
      demand: json['demand'] as int,
      capacity: json['capacity'] as int,
    );
  }
}

class ServiceMetric {
  const ServiceMetric({
    required this.id,
    required this.name,
    required this.category,
    required this.demand,
    required this.previousDemand,
    required this.capacity,
    required this.averageWaitHours,
    required this.resolutionRate,
    required this.neighborhoods,
  });

  final String id;
  final String name;
  final String category;
  final int demand;
  final int previousDemand;
  final int capacity;
  final int averageWaitHours;
  final double resolutionRate;
  final List<NeighborhoodMetric> neighborhoods;

  double get demandRatio => demand / capacity;
  double get trend =>
      previousDemand == 0 ? 0 : (demand - previousDemand) / previousDemand;

  factory ServiceMetric.fromJson(Map<String, dynamic> json) {
    return ServiceMetric(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      demand: json['demand'] as int,
      previousDemand: json['previousDemand'] as int,
      capacity: json['capacity'] as int,
      averageWaitHours: json['averageWaitHours'] as int,
      resolutionRate: (json['resolutionRate'] as num).toDouble(),
      neighborhoods: (json['neighborhoods'] as List<dynamic>)
          .map(
            (item) => NeighborhoodMetric.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
