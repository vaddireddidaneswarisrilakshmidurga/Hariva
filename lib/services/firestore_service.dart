import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_provider.dart';

class FirestoreService {
  final CollectionReference _services = FirebaseFirestore.instance.collection(
    'service_providers',
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **1️⃣ Add Multiple Admin Users**
  Future<void> addAdminUsers() async {
    List<Map<String, dynamic>> adminUsers = [
      {'uid': 'admin1_uid', 'phone': '+91 8074227194', 'role': 'admin'},
      {'uid': 'admin2_uid', 'phone': '+91 9052028220', 'role': 'admin'},
    ];

    for (var admin in adminUsers) {
      await _firestore
          .collection('users')
          .doc(admin['uid'])
          .set(admin, SetOptions(merge: true));
    }

    // Add sample services if they don't exist
    await _addSampleServices();

    print('✅ Admins and sample services added successfully!');
  }

  /// Add sample services for testing
  Future<void> _addSampleServices() async {
    List<Map<String, dynamic>> services = [
      {
        'id': 'service1',
        'name': 'Pesticide Spray',
        'description': 'Drone-based pesticide spraying for all crops',
      },
      {
        'id': 'service2',
        'name': 'Seed Sowing',
        'description': 'Precision seed sowing using drones',
      },
      {
        'id': 'service3',
        'name': 'Crop Monitoring',
        'description': 'Aerial crop health monitoring and analysis',
      },
      {
        'id': 'service4',
        'name': 'Fertilizer Spray',
        'description': 'Efficient fertilizer application via drones',
      },
    ];

    // Check if services already exist
    final snapshot = await _services.get();
    if (snapshot.docs.isEmpty) {
      // Add services only if none exist
      for (var service in services) {
        await _services.doc(service['id']).set(service);
      }
      print('✅ Sample services added');
    }
  }

  /// **2️⃣ Check if a user is an admin**
  Future<bool> isAdmin(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc['role'] == 'admin';
    }
    return false;
  }

  /// **3️⃣ Approve a service provider**
  Future<void> approveServiceProvider(String id) async {
    await _firestore.collection('service_providers').doc(id).update({
      'approved': true,
    });
  }

  /// **4️⃣ Get all service providers**
  Stream<List<ServiceProvider>> getServices() {
    return _services.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) =>
                    ServiceProvider.fromMap(doc.data() as Map<String, dynamic>)
                      ..id = doc.id, // Ensure ID is set from document
              )
              .toList(),
    );
  }

  /// **5️⃣ Add a new service provider**
  Future<void> addService(ServiceProvider service) {
    return _services.doc(service.id).set(service.toMap());
  }

  /// **6️⃣ Delete a service provider**
  Future<void> deleteService(String id) async {
    if (id.isEmpty) {
      throw Exception('Service ID cannot be empty');
    }
    await _services.doc(id).delete();
  }
}
