import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceBookingService {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  Future<void> startVoiceBooking(Function(String) onBooking) async {
    await _tts.setLanguage('te-IN'); // Telugu
    await _tts.speak(
      'మీరు ఏ సేవను బుక్ చేయాలనుకుంటున్నారు?',
    ); // "What service do you want to book?"
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) {
          String command = result.recognizedWords;
          onBooking(command); // Process command (e.g., "Book Drone 5 acres")
        },
        localeId: 'te_IN',
      );
    }
  }
}
