import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class ConfirmationScreen extends StatelessWidget {
  final String bookingId;
  final double amount;
  final String paymentMethod;

  const ConfirmationScreen({
    super.key,
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.bookingConfirmation),
            automaticallyImplyLeading: false, // Remove back button
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.successGreen,
                  size: 80,
                ),
                const SizedBox(height: 24),
                Text(
                  localizations.bookingSuccessful,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Booking Details Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          localizations.bookingId,
                          bookingId,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          localizations.totalPrice,
                          '₹${amount.toStringAsFixed(2)}',
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          localizations.paymentMethod,
                          paymentMethod == 'cash'
                              ? localizations.cashOnService
                              : localizations.onlinePayment,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          localizations.bookingDate,
                          _formatDate(DateTime.now()),
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          localizations.status,
                          paymentMethod == 'cash'
                              ? localizations.pending
                              : localizations.confirmed,
                          valueColor:
                              paymentMethod == 'cash'
                                  ? AppColors.warningYellow
                                  : AppColors.successGreen,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.oliveGreen),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(localizations.backToHome),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to view all bookings
                          // This could be implemented in a future update
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(localizations.viewAllBookings),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
