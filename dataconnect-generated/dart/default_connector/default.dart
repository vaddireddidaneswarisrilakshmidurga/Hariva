import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DefaultConnector {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static final DefaultConnector _instance = DefaultConnector._internal();
  
  DefaultConnector._internal();
  
  static DefaultConnector get instance => _instance;
  
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }
  
  FirebaseFirestore get database => _firestore;
}
