import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';  // Add this import
import '../models/service_provider.dart';

class OfflineService {
  final Box _serviceBox = Hive.box('services');

  void cacheServices(List<ServiceProvider> services) {
    _serviceBox.put('services', services.map((s) => s.toMap()).toList());
  }

  List<ServiceProvider> getCachedServices() {
    var data = _serviceBox.get('services', defaultValue: []);
    return (data as List).map((map) => ServiceProvider.fromMap(map)).toList();
  }
}
