import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('te')
  ];

  /// Title of the application
  ///
  /// In en, this message translates to:
  /// **'FarmService Connect'**
  String get appTitle;

  /// Tagline describing the app purpose
  ///
  /// In en, this message translates to:
  /// **'Connecting Farmers with Drone Services'**
  String get welcomeMessage;

  /// Login button label
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Label for phone number input
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Button label for sending OTP
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// Label for OTP input field
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// Button label for verifying OTP
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// Message displayed when login succeeds
  ///
  /// In en, this message translates to:
  /// **'Login Successful'**
  String get loginSuccess;

  /// Error message when login fails
  ///
  /// In en, this message translates to:
  /// **'Login Failed. Please try again.'**
  String get loginFailed;

  /// Title for the home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Label for service name
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get serviceName;

  /// Label for service description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get serviceDescription;

  /// Button label for booking a service
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// Title for booking page
  ///
  /// In en, this message translates to:
  /// **'Book Service'**
  String get bookingTitle;

  /// Label for entering farm name
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get farmName;

  /// Label for the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for selecting acres in booking
  ///
  /// In en, this message translates to:
  /// **'Acres'**
  String get acres;

  /// Label for choosing the service location
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// Label for displaying total booking price
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// Button label for payment processing
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get proceedToPayment;

  /// Message displayed when booking is successful
  ///
  /// In en, this message translates to:
  /// **'Booking Successful'**
  String get bookingSuccess;

  /// Error message when booking fails
  ///
  /// In en, this message translates to:
  /// **'Booking Failed. Please try again.'**
  String get bookingFailed;

  /// Title for the payment page
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// Label for total payment amount
  ///
  /// In en, this message translates to:
  /// **'Amount to Pay'**
  String get amountToPay;

  /// Button label to proceed with payment
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// Message displayed when payment is successful
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccess;

  /// Error message when payment fails
  ///
  /// In en, this message translates to:
  /// **'Payment Failed. Please try again.'**
  String get paymentFailed;

  /// Title for the admin panel
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboardTitle;

  /// Button label to add a new service
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// Section title for managing bookings
  ///
  /// In en, this message translates to:
  /// **'Manage Bookings'**
  String get manageBookings;

  /// Message displayed when a user lacks permission
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// Title for chatbot feature
  ///
  /// In en, this message translates to:
  /// **'Chatbot'**
  String get chatbotTitle;

  /// Question about booking services
  ///
  /// In en, this message translates to:
  /// **'How to book?'**
  String get howToBook;

  /// Instructions on how to book a service
  ///
  /// In en, this message translates to:
  /// **'Go to the Home Screen, select a service, and fill out the booking form.'**
  String get bookingInstructions;

  /// User question about pricing
  ///
  /// In en, this message translates to:
  /// **'What is the price?'**
  String get priceQuestion;

  /// Predefined chatbot response for pricing inquiry
  ///
  /// In en, this message translates to:
  /// **'The price is ₹400 per acre.'**
  String get priceResponse;

  /// Title for the voice booking feature
  ///
  /// In en, this message translates to:
  /// **'Voice Booking'**
  String get voiceBookingTitle;

  /// Button label to start voice booking
  ///
  /// In en, this message translates to:
  /// **'Start Voice Booking'**
  String get startVoiceBooking;

  /// Voice assistant prompt for booking service
  ///
  /// In en, this message translates to:
  /// **'What service do you want to book?'**
  String get voicePrompt;

  /// Warning message when offline
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternet;

  /// Message displayed when using the app offline
  ///
  /// In en, this message translates to:
  /// **'Offline Mode: Data may be outdated'**
  String get offlineMode;

  /// Message displayed during data synchronization
  ///
  /// In en, this message translates to:
  /// **'Syncing Data...'**
  String get syncingData;

  /// Button label for logging out
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Prompt for users to register if they don't have an account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get registerPrompt;

  /// Button label for user registration
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Label for email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Option to register using email instead of phone
  ///
  /// In en, this message translates to:
  /// **'Register with Email'**
  String get registerWithEmail;

  /// Error message when required fields are empty
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get fillAllFields;

  /// Message displayed when email OTP is not available
  ///
  /// In en, this message translates to:
  /// **'Email OTP sending not implemented yet'**
  String get emailOtpNotImplemented;

  /// Message prompting the user to enter OTP
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP'**
  String get enterOtpPrompt;

  /// Error message when an incorrect OTP is entered
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get invalidOtp;

  /// Message displayed when a service is deleted
  ///
  /// In en, this message translates to:
  /// **'Service deleted successfully'**
  String get serviceDeleted;

  /// Label for describing a service or item
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for the cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for adding a new item
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Message displayed when a new service is added
  ///
  /// In en, this message translates to:
  /// **'Service added successfully'**
  String get serviceAdded;

  /// Welcome greeting for users
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Alert showing current service pricing
  ///
  /// In en, this message translates to:
  /// **'Service available at ₹400 per acre'**
  String get serviceAlert;

  /// Header for the services section
  ///
  /// In en, this message translates to:
  /// **'Available Services'**
  String get availableServices;

  /// Header for past bookings section
  ///
  /// In en, this message translates to:
  /// **'Past Bookings'**
  String get pastBookings;

  /// Message shown when no bookings exist
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get noBookingsYet;

  /// Title for payment screen
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Header for order summary section
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// Prompt to select payment method
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// Option to pay cash when service is delivered
  ///
  /// In en, this message translates to:
  /// **'Cash on Service'**
  String get cashOnService;

  /// Option to pay online
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get onlinePayment;

  /// Available online payment options
  ///
  /// In en, this message translates to:
  /// **'UPI, Card, Wallet, Net Banking'**
  String get razorpayOptions;

  /// Button to confirm payment
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// Title for booking confirmation screen
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmation'**
  String get bookingConfirmation;

  /// Message shown when booking is completed
  ///
  /// In en, this message translates to:
  /// **'Booking Successful!'**
  String get bookingSuccessful;

  /// Label for booking identifier
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// Label for booking date
  ///
  /// In en, this message translates to:
  /// **'Booking Date'**
  String get bookingDate;

  /// Label for booking status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Status indicating booking is pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Status indicating booking is confirmed
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// Button to return to home screen
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Button to view all bookings
  ///
  /// In en, this message translates to:
  /// **'View All Bookings'**
  String get viewAllBookings;

  /// Label for payment method used
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
