import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/chatbot_service.dart';
import '../services/voice_service.dart';
import '../theme/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ChatbotService _chatbotService = ChatbotService();
  final VoiceService _voiceService = VoiceService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isListening = false;

  // Sample initial messages
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'message':
          'Hello! I am your FarmService Connect assistant. How can I help you today?',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeVoiceService();
  }

  Future<void> _initializeVoiceService() async {
    await _voiceService.initialize();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add({'isUser': true, 'message': userMessage});
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // Get the current language code
      final localeProvider = Provider.of<LocaleProvider>(
        context,
        listen: false,
      );
      final languageCode = localeProvider.locale.languageCode;

      // Send message to chatbot service
      final response = await _chatbotService.sendMessage(
        userMessage,
        language: languageCode,
      );

      if (mounted) {
        setState(() {
          _messages.add({'isUser': false, 'message': response});
          _isLoading = false;
        });

        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({
            'isUser': false,
            'message': 'Sorry, I encountered an error. Please try again later.',
          });
          _isLoading = false;
        });

        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.chatbotTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _messages.clear();
                    _messages.add({
                      'isUser': false,
                      'message':
                          'Hello! I am your FarmService Connect assistant. How can I help you today?',
                    });
                    _chatbotService.clearConversation();
                  });
                },
                tooltip: 'Reset conversation',
              ),
            ],
          ),
          body: Column(
            children: [
              // Chat messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length) {
                      // Show typing indicator
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            right: 80.0,
                          ),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: AppColors.lightBrown.withAlpha(51),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 8),
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.oliveGreen,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Typing...',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final message = _messages[index];
                    final isUser = message['isUser'] as bool;

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          left: isUser ? 80.0 : 0.0,
                          right: isUser ? 0.0 : 80.0,
                        ),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color:
                              isUser
                                  ? AppColors.oliveGreen
                                  : AppColors.lightBrown.withAlpha(51),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          message['message'] as String,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Input area
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Voice input button
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic_off : Icons.mic,
                        color: _isListening ? Colors.red : AppColors.oliveGreen,
                      ),
                      onPressed: () async {
                        final localeProvider = Provider.of<LocaleProvider>(
                          context,
                          listen: false,
                        );
                        final languageCode = localeProvider.locale.languageCode;
                        final localeId =
                            languageCode == 'te' ? 'te-IN' : 'en-US';

                        if (_isListening) {
                          setState(() => _isListening = false);
                          await _voiceService.stopListening();
                        } else {
                          final available = await _voiceService.isAvailable;
                          if (!available) {
                            if (!mounted) return;
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Speech recognition not available',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() => _isListening = true);
                          await _voiceService.startListening(
                            onResult: (text) {
                              if (text.isNotEmpty) {
                                setState(() {
                                  _messageController.text = text;
                                  _isListening = false;
                                });
                              }
                            },
                            localeId: localeId,
                          );
                        }
                      },
                    ),

                    // Text input field
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: localizations.chatbotTitle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),

                    // Send button
                    IconButton(
                      icon: const Icon(Icons.send, color: AppColors.oliveGreen),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
