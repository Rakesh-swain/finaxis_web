import 'package:finaxis_web/models/local_chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiController extends GetxController {
  // Observables
  final localMessages = <LocalChatMessage>[].obs;
  final isTyping = false.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();
  
  // Keep your existing properties
  final currentSession = Rx<ChatSession?>(null);
  final isLoading = false.obs;
  final isStreaming = false.obs;
  final isRecording = false.obs;
  final currentInput = ''.obs;
  final quickActions = <QuickAction>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with empty state
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// Send hardcoded message with AI response
  Future<void> sendHardcodedMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    localMessages.add(LocalChatMessage(
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    // Clear input
    textController.clear();
    
    // Scroll to bottom
    _scrollToBottom();

    // Show typing indicator
    isTyping.value = true;

    // Simulate AI thinking time (900ms like in HTML)
    await Future.delayed(const Duration(milliseconds: 900));

    // Hide typing indicator
    isTyping.value = false;

    // Get AI response
    final aiResponse = _getHardcodedResponse(message.toLowerCase());

    // Add AI message
    localMessages.add(LocalChatMessage(
      content: aiResponse,
      isUser: false,
      timestamp: DateTime.now(),
    ));

    // Scroll to bottom
    _scrollToBottom();
  }

  /// Send quick action message
  Future<void> sendQuickActionMessage(String message) async {
    await sendHardcodedMessage(message);
  }

  /// Get hardcoded AI responses
  String _getHardcodedResponse(String input) {
    // Greetings
    if (RegExp(r'^(hi|hello|hey)').hasMatch(input)) {
      return "Hi there! 👋\nI'm your Finaxis Assistant.\nHow can I help you manage your finances today?";
    }

    // Risk Distribution
    if (input.contains('risk distribution') || input.contains('risk') && input.contains('applicant')) {
      return "📊 Risk Distribution Analysis:\n\n"
          "🟢 Low Risk: 45% (1,350 applicants)\n"
          "• Credit score > 750\n"
          "• Stable income history\n"
          "• Low debt-to-income ratio\n\n"
          "🟡 Medium Risk: 35% (1,050 applicants)\n"
          "• Credit score 650-750\n"
          "• Moderate income stability\n"
          "• Average debt-to-income ratio\n\n"
          "🔴 High Risk: 20% (600 applicants)\n"
          "• Credit score < 650\n"
          "• Irregular income\n"
          "• High debt-to-income ratio\n\n"
          "Key Risk Indicators:\n"
          "• Default rate: 2.3%\n"
          "• Average recovery time: 45 days\n"
          "• Risk-adjusted return: 8.5%";
    }

    // Business Types & Customer Segments
    if (input.contains('business') || input.contains('customer segment') || input.contains('portfolio')) {
      return "🏢 Business Types & Loan Approaches:\n\n"
          "1️⃣ Retail & E-commerce (32%)\n"
          "• Working capital loans\n"
          "• Inventory financing\n"
          "• Risk: Low-Medium\n\n"
          "2️⃣ Manufacturing (25%)\n"
          "• Equipment financing\n"
          "• Term loans\n"
          "• Risk: Medium\n\n"
          "3️⃣ Services (28%)\n"
          "• Business expansion loans\n"
          "• Line of credit\n"
          "• Risk: Low-Medium\n\n"
          "4️⃣ Agriculture (15%)\n"
          "• Seasonal loans\n"
          "• Crop financing\n"
          "• Risk: Medium-High\n\n"
          "Evaluation Criteria:\n"
          "✓ Business vintage (min 2 years)\n"
          "✓ Annual turnover threshold\n"
          "✓ Cash flow analysis\n"
          "✓ Industry risk assessment";
    }

    // Approval Rates
    if (input.contains('approval rate') || input.contains('approval')) {
      return "✅ Loan Approval Rate Analysis:\n\n"
          "📈 Overall Approval Rate: 68%\n\n"
          "By Risk Category:\n"
          "• Low Risk: 92% approval\n"
          "• Medium Risk: 71% approval\n"
          "• High Risk: 28% approval\n\n"
          "By Loan Type:\n"
          "• Personal Loans: 74%\n"
          "• Business Loans: 65%\n"
          "• SME Loans: 61%\n\n"
          "Time Period Trends:\n"
          "• Q1 2024: 65%\n"
          "• Q2 2024: 68%\n"
          "• Q3 2024: 70%\n"
          "• Q4 2024: 72% (↑4% YoY)\n\n"
          "🎯 Improvement Opportunities:\n"
          "• Streamline documentation (save 2 days)\n"
          "• Enhanced risk scoring models\n"
          "• Faster credit bureau checks\n"
          "• Automated income verification";
    }

    // Loan Rates
    if (input.contains('rate') || input.contains('loan rate')) {
      return "Here are today's loan rates:\n\n• Personal Loan: 11.5%\n• SME Loan: 14.2%\n• Credit Line: 9.8%";
    }

    // Pending Consents
    if (input.contains('pending consent') || input.contains('consent')) {
      return "There are 212 pending consents that customers haven't acted on yet.";
    }

    // Default response with suggestions
    return "I can help you with:\n\n"
        "🔴 Risk Distribution - Detailed applicant risk analysis\n"
        "📊 Portfolio Analysis - Business types & customer segments\n"
        "✅ Approval Rates - Performance metrics & trends\n\n"
        "Just ask me about any of these topics!";
  }

  /// Scroll to bottom of chat
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Keep your existing methods for compatibility
  void sendMessage(String message, {bool useStream = false}) {
    sendHardcodedMessage(message);
  }

  void sendQuickAction(QuickAction action) {
    // Handle quick action
  }
}

/// Keep your existing models for compatibility
class ChatSession {
  final String id;
  final List<ChatMessage> messages;
  
  ChatSession({required this.id, required this.messages});
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final List<ChatAction>? actions;
  final dynamic usage;
  
  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.actions,
    this.usage,
  });
}

class ChatAction {
  final String label;
  final String type;
  final String? icon;
  final String? route;
  
  ChatAction({
    required this.label,
    required this.type,
    this.icon,
    this.route,
  });
}

class QuickAction {
  final String icon;
  final String category;
  final String title;
  final String prompt;
  
  QuickAction({
    required this.icon,
    required this.category,
    required this.title,
    required this.prompt,
  });
}