import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentService {
  late Razorpay _razorpay;
  Function? _onPaymentSuccess;
  Function? _onPaymentError;

  PaymentService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: 'Payment Successful: ${response.paymentId}',
      toastLength: Toast.LENGTH_SHORT,
    );
    if (_onPaymentSuccess != null) {
      _onPaymentSuccess!(response);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: 'Payment Failed: ${response.message}',
      toastLength: Toast.LENGTH_SHORT,
    );
    if (_onPaymentError != null) {
      _onPaymentError!(response);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: 'External Wallet: ${response.walletName}',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void initializePayment(
    double amount,
    String phone, {
    Function? onSuccess,
    Function? onError,
  }) {
    _onPaymentSuccess = onSuccess;
    _onPaymentError = onError;

    // Convert amount to paise (Razorpay expects amount in smallest currency unit)
    int amountInPaise = (amount * 100).toInt();

    var options = {
      'key': 'rzp_test_YOUR_KEY_HERE', // Replace with your actual Razorpay key
      'amount': amountInPaise,
      'name': 'FarmService Connect',
      'description': 'Drone Service Booking',
      'prefill': {'contact': phone},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      Fluttertoast.showToast(msg: 'Error: $e', toastLength: Toast.LENGTH_SHORT);
    }
  }
}
