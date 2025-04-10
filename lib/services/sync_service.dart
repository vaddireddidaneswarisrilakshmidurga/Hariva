import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/firestore_service.dart';
import 'offline_service.dart';

class SyncService {
  final FirestoreService _firestoreService = FirestoreService();
  final OfflineService _offlineService = OfflineService();

  Future<void> syncData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      var services = await _firestoreService.getServices().first;
      _offlineService.cacheServices(services);
    }
  }
}
