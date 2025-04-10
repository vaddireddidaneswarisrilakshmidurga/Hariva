class Booking {
  final String id;
  final String userId;
  final String serviceId;
  final String farmName;
  final double acres;
  final String location;

  Booking({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.farmName,
    required this.acres,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'serviceId': serviceId,
      'farmName': farmName,
      'acres': acres,
      'location': location,
    };
  }
}
