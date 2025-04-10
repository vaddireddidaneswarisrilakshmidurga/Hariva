import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatbotService {
  // This will be replaced with the actual API key
  static const String _openRouterApiKey = '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';
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  
  // Model ID for DeepSeek on OpenRouter
  static const String _modelId = 'deepseek-ai/deepseek-chat';

  // Store conversation history
  final List<Map<String, String>> _conversationHistory = [];

  // Get conversation history
  List<Map<String, String>> get conversationHistory => _conversationHistory;

  // Clear conversation history
  void clearConversation() {
    _conversationHistory.clear();
  }

  // Send a message to the chatbot
  Future<String> sendMessage(String message, {String language = 'en'}) async {
    try {
      // Add user message to conversation history
      _conversationHistory.add({
        'role': 'user',
        'content': message,
      });

      // Prepare the system message based on language
      String systemPrompt = language == 'te' 
          ? 'మీరు FarmService Connect అనే వ్యవసాయ సేవల యాప్‌లో ఒక సహాయక చాట్‌బాట్. మీరు తెలుగులో మాట్లాడాలి మరియు రైతులకు డ్రోన్ సేవలు, ధరలు, బుకింగ్ ప్రక్రియ మరియు చెల్లింపు ఎంపికల గురించి సహాయం చేయాలి. మీ సమాధానాలు సరళంగా, స్పష్టంగా మరియు 2-3 వాక్యాలకు పరిమితం చేయండి.'
          : 'You are a helpful chatbot in the FarmService Connect agricultural services app. You should speak in English and help farmers with information about drone services, pricing, booking process, and payment options. Keep your responses simple, clear, and limited to 2-3 sentences.';

      // Prepare the messages for the API request
      final List<Map<String, String>> messages = [
        {'role': 'system', 'content': systemPrompt},
        ..._conversationHistory,
      ];

      // Make the API request
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openRouterApiKey',
          'HTTP-Referer': 'https://farmserviceconnect.com', // Replace with your actual domain
        },
        body: jsonEncode({
          'model': _modelId,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data['choices'][0]['message']['content'] as String;
        
        // Add bot response to conversation history
        _conversationHistory.add({
          'role': 'assistant',
          'content': botResponse,
        });
        
        return botResponse;
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.body}');
        return 'Sorry, I encountered an error. Please try again later.';
      }
    } catch (e) {
      debugPrint('Exception: $e');
      return 'Sorry, I encountered an error. Please try again later.';
    }
  }
}
