import 'package:flutter/material.dart';
import '../models/service_provider.dart';
import '../theme/app_theme.dart';
import 'osm_map_screen.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class BookingScreen extends StatefulWidget {
  final ServiceProvider service;
  @override
  const BookingScreen({super.key, required this.service});
  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  String farmName = '';
  double acres = 0;
  String location = 'Select Location';

  @override
  Widget build(BuildContext context) {
    double price = acres * 400; // ₹400 per acre
    final localizations = AppLocalizations.of(context)!;

    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${localizations.bookingTitle}: ${widget.service.name}',
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Info Card
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            _getIconForService(widget.service.name),
                            size: 48,
                            color: AppColors.oliveGreen,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.service.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(widget.service.description),
                                const SizedBox(height: 8),
                                Text(
                                  localizations.priceResponse,
                                  style: const TextStyle(
                                    color: AppColors.darkGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Booking Form
                  Text(
                    localizations.bookingTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: localizations.farmName,
                    ),
                    onChanged: (value) => farmName = value,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    decoration: InputDecoration(labelText: localizations.acres),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        acres = double.tryParse(value) ?? 0;
                      });
                    },
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Location Selection
                  OutlinedButton.icon(
                    onPressed: () async {
                      var selectedLocation = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OSMMapScreen(),
                        ),
                      );
                      if (selectedLocation != null) {
                        setState(() => location = selectedLocation);
                      }
                    },
                    icon: const Icon(Icons.location_on),
                    label: Text(
                      location == 'Select Location'
                          ? localizations.selectLocation
                          : location,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Price Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightBrown.withAlpha(51), // 0.2 opacity
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.lightBrown),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.totalPrice,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.oliveGreen,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Proceed Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (location == 'Select Location') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(localizations.selectLocation),
                              ),
                            );
                            return;
                          }
                          // Save booking to Firestore (implement as needed)
                          Navigator.pushNamed(
                            context,
                            '/payment',
                            arguments: price,
                          );
                        }
                      },
                      child: Text(localizations.proceedToPayment),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
