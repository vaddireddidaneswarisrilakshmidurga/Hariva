class ServiceProvider {
  String id;
  String name;
  String description;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ServiceProvider.fromMap(Map<String, dynamic> map) {
    return ServiceProvider(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }
}
