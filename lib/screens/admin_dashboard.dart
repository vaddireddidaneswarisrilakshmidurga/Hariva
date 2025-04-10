import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_provider.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({super.key});
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.adminDashboardTitle),
            actions: [
              IconButton(
                icon:const  Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ],
          ),
          body: StreamBuilder<List<ServiceProvider>>(
            stream:
                _firestoreService.getServices(), // Use FirestoreService stream
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final services =
                  snapshot.data!; // Data is already List<ServiceProvider>

              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ListTile(
                    title: Text(service.name),
                    subtitle: Text(service.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        try {
                          await _firestoreService.deleteService(service.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(localizations.serviceDeleted),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error deleting service: $e'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) =>
                        AddServiceDialog(firestoreService: _firestoreService),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class AddServiceDialog extends StatefulWidget {
  final FirestoreService firestoreService;
  const AddServiceDialog({super.key, required this.firestoreService});

  @override
  AddServiceDialogState createState() => AddServiceDialogState();
}

class AddServiceDialogState extends State<AddServiceDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localizations.addService),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: localizations.serviceName),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: localizations.description),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () async {
            final name = _nameController.text;
            final description = _descriptionController.text;
            if (name.isNotEmpty && description.isNotEmpty) {
              try {
                // Generate a unique ID or use a custom one as per your logic
                final id =
                    FirebaseFirestore.instance
                        .collection('service_providers')
                        .doc()
                        .id;
                await widget.firestoreService.addService(
                  ServiceProvider(id: id, name: name, description: description),
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.serviceAdded)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error adding service: $e')),
                  );
                }
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.fillAllFields)),
                );
              }
            }
          },
          child: Text(localizations.add),
        ),
      ],
    );
  }
}
