// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/service_provider.dart';
import 'package:hariva/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.homeTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () => Navigator.pushNamed(context, '/chatbot'),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Message
                Text(
                  '${localizations.welcome}, ${_getUserName()}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.welcomeMessage,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),

                // Service Availability Alert
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightBrown.withAlpha(51), // 0.2 opacity
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.lightBrown),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.darkGreen,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          localizations.serviceAlert,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Services Grid
                Text(
                  localizations.availableServices,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                StreamBuilder<List<ServiceProvider>>(
                  stream: _firestoreService.getServices(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final services = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        ServiceProvider service = services[index];
                        return _buildServiceCard(context, service);
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Past Bookings
                Text(
                  localizations.pastBookings,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Expanded(child: _buildPastBookingsList(context)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/voice'),
            backgroundColor: AppColors.oliveGreen,
            child: const Icon(Icons.mic),
          ),
        );
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceProvider service) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/booking', arguments: service),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForService(service.name),
                size: 48,
                color: AppColors.oliveGreen,
              ),
              const SizedBox(height: 12),
              Text(
                service.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.bookNow,
                style: const TextStyle(
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPastBookingsList(BuildContext context) {
    // This would ideally fetch from Firestore
    // For now, we'll show a placeholder
    return Center(
      child: Text(
        AppLocalizations.of(context)!.noBookingsYet,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  String _getUserName() {
    // This would fetch the user's name from Firebase Auth or Firestore
    // For now, return a placeholder
    return 'Farmer';
  }

  IconData _getIconForService(String serviceName) {
    // Return appropriate icons based on service name
    switch (serviceName.toLowerCase()) {
      case 'pesticide spray':
        return Icons.sanitizer;
      case 'seed sowing':
        return Icons.grass;
      case 'crop monitoring':
        return Icons.visibility;
      case 'fertilizer spray':
        return Icons.water_drop;
      default:
        return Icons.agriculture;
    }
  }
}
