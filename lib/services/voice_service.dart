import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  // Initialize the speech recognition and text-to-speech
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    // Initialize speech to text
    _isInitialized = await _speech.initialize(
      onError: (error) => debugPrint('Speech recognition error: $error'),
      onStatus: (status) => debugPrint('Speech recognition status: $status'),
    );

    // Initialize text to speech
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(
      0.5,
    ); // Slower rate for better understanding
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    return _isInitialized;
  }

  // Start listening for speech
  Future<void> startListening({
    required Function(String) onResult,
    required String localeId,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        debugPrint('Could not initialize speech recognition');
        return;
      }
    }

    // Set the locale for speech recognition
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: localeId,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  // Stop listening for speech
  Future<void> stopListening() async {
    await _speech.stop();
  }

  // Check if speech recognition is available
  Future<bool> get isAvailable async {
    if (!_isInitialized) {
      await initialize();
    }
    return _speech.isAvailable;
  }

  // Speak text
  Future<void> speak(String text, {String language = 'en-US'}) async {
    await _flutterTts.setLanguage(language);
    await _flutterTts.speak(text);
  }

  // Stop speaking
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  // Dispose resources
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
  }
}
