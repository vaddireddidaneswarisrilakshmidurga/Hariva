import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/payment_service.dart';
import '../theme/app_theme.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  String _paymentMethod = 'cash'; // Default to cash
  bool _isProcessing = false;

  void _processPayment(double amount, BuildContext context) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      if (_paymentMethod == 'online') {
        // Get phone from current user or use a default for testing
        String phone = '+919999999999'; // Replace with actual user phone
        _paymentService.initializePayment(amount, phone);
        // The Razorpay SDK will handle the payment flow
        // We'll navigate to confirmation in the payment success callback
      } else {
        // For cash payment, directly navigate to confirmation
        await Future.delayed(const Duration(seconds: 1)); // Simulate processing
        if (mounted) {
          Navigator.pushReplacement(
            mounted ? context : throw Exception('Context is no longer valid'),
            MaterialPageRoute(
              builder:
                  (context) => ConfirmationScreen(
                    bookingId: 'BK${DateTime.now().millisecondsSinceEpoch}',
                    amount: amount,
                    paymentMethod: _paymentMethod,
                  ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
         mounted ? context : throw Exception('Context is no longer valid'),
        ).showSnackBar(SnackBar(content: Text('Payment error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double amount = ModalRoute.of(context)!.settings.arguments as double;

    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(title: Text(localizations.payment)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.orderSummary,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(localizations.totalPrice),
                            Text(
                              '₹${amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Methods
                Text(
                  localizations.selectPaymentMethod,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // Cash on Service
                RadioListTile<String>(
                  title: Row(
                    children: [
                      const Icon(Icons.money, color: AppColors.oliveGreen),
                      const SizedBox(width: 16),
                      Text(localizations.cashOnService),
                    ],
                  ),
                  value: 'cash',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                ),

                // Online Payment (Razorpay)
                RadioListTile<String>(
                  title: Row(
                    children: [
                      const Icon(Icons.payment, color: AppColors.oliveGreen),
                      const SizedBox(width: 16),
                      Text(localizations.onlinePayment),
                    ],
                  ),
                  subtitle: Text(localizations.razorpayOptions),
                  value: 'online',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                ),

                const Spacer(),

                // Payment Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _isProcessing
                            ? null
                            : () => _processPayment(amount, context),
                    child:
                        _isProcessing
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(localizations.confirmPayment),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
