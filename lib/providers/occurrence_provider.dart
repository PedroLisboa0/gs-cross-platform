import 'package:flutter/foundation.dart';

import '../models/occurrence.dart';
import '../services/local_database.dart';

class OccurrenceProvider extends ChangeNotifier {
  OccurrenceProvider(this._database);

  final LocalDatabase _database;
  List<Occurrence> _occurrences = const [];
  bool _isLoading = false;
  Object? _error;

  List<Occurrence> get occurrences => _occurrences;
  bool get isLoading => _isLoading;
  Object? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _occurrences = await _database.getOccurrences();
    } catch (error) {
      _error = error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(Occurrence occurrence) async {
    _error = null;
    try {
      final saved = await _database.addOccurrence(occurrence);
      _occurrences = [saved, ..._occurrences];
      notifyListeners();
    } catch (error) {
      _error = error;
      notifyListeners();
      rethrow;
    }
  }
}
