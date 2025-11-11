import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/chat_message.dart';
import '../../services/chatgpt_service.dart';

/// Controller for customer-specific AI chat
class CustomerAiChatController extends GetxController {
  // Services
  final ChatGPTService _chatService = Get.find<ChatGPTService>();

  // Customer context
  late String customerCif;
  late String customerName;
  late String riskStatus;
  late int creditScore;

  // Chat state
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final textController = TextEditingController();

  // Quick actions for customer analysis
  final RxList<QuickAction> quickActions = <QuickAction>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeQuickActions();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  /// Initialize customer context
  void initializeCustomerContext({
    required String cif,
    required String name,
    required String riskStatus,
    required int creditScore,
  }) {
    customerCif = cif;
    customerName = name;
    this.riskStatus = riskStatus;
    this.creditScore = creditScore;

    // Send initial welcome message
    _sendWelcomeMessage();
  }

  /// Initialize quick actions based on customer data
  void _initializeQuickActions() {
    quickActions.value = [
      QuickAction(
        icon: '🎯',
        category: 'RISK',
        title: 'Risk Assessment',
        description: 'Analyze current risk factors',
        prompt: 'Provide a detailed risk assessment for this customer',
      ),
      QuickAction(
        icon: '💳',
        category: 'CREDIT',
        title: 'Credit Analysis',
        description: 'Review credit history and score',
        prompt: 'Analyze the credit score and creditworthiness',
      ),
      QuickAction(
        icon: '💰',
        category: 'TRANSACTIONS',
        title: 'Transaction Patterns',
        description: 'Review spending behavior',
        prompt: 'Analyze transaction patterns and financial behavior',
      ),
      QuickAction(
        icon: '📊',
        category: 'PORTFOLIO',
        title: 'Portfolio Overview',
        description: 'View all active products',
        prompt: 'Show a summary of all accounts and products',
      ),
      QuickAction(
        icon: '⚠️',
        category: 'ALERTS',
        title: 'Red Flags',
        description: 'Identify potential issues',
        prompt: 'Identify any red flags or concerning patterns',
      ),
      QuickAction(
        icon: '📈',
        category: 'OPPORTUNITIES',
        title: 'Growth Opportunities',
        description: 'Cross-sell and upsell potential',
        prompt: 'Suggest products or services that would benefit this customer',
      ),
      QuickAction(
        icon: '🔍',
        category: 'COMPLIANCE',
        title: 'Compliance Check',
        description: 'Review regulatory status',
        prompt: 'Check compliance status and any regulatory concerns',
      ),
      QuickAction(
        icon: '📝',
        category: 'SUMMARY',
        title: 'Customer Summary',
        description: 'Complete profile overview',
        prompt: 'Provide a comprehensive summary of this customer profile',
      ),
    ];
  }

  /// Send welcome message with customer context
  void _sendWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: '',
      sessionId: '',
      content: '''
👋 **Welcome to Customer AI Assistant**

I'm here to help you analyze **$customerName** (CIF: $customerCif).

**Current Status:**
- Risk Level: **${_getRiskLabel(riskStatus)}**
- Credit Score: **$creditScore**

I can help you with:
- 🎯 Risk assessment and analysis
- 💳 Credit evaluation
- 💰 Transaction pattern insights
- 📊 Portfolio recommendations
- ⚠️ Identifying red flags
- 📈 Growth opportunities

**What would you like to know about this customer?**
      ''',
      isUser: false,
      timestamp: DateTime.now(),
    );

    messages.add(welcomeMessage);
  }

  /// Send a message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
         id: '',
      sessionId: '',
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);
    textController.clear();

    // Set loading state
    isLoading.value = true;

    try {
      // Build context-aware prompt
      final contextualPrompt = _buildContextualPrompt(text);

      // Get AI response
      final response = await _chatService.sendMessage(
        contextualPrompt,
        messages.toList(),
        sessionId: '',
      );

      // Add AI response
      final aiMessage = ChatMessage(
           id: '',
      sessionId: '',
        content: '',
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(aiMessage);

    } catch (e) {
      // Add error message
      final errorMessage = ChatMessage(
           id: '',
      sessionId: '',
        content: '❌ Sorry, I encountered an error: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  /// Send quick action
  Future<void> sendQuickAction(QuickAction action) async {
    await sendMessage(action.prompt);
  }

  /// Build contextual prompt with customer data
  String _buildContextualPrompt(String userQuery) {
    return '''
You are a financial AI assistant analyzing a specific customer. Here's the customer context:

**Customer Information:**
- Name: $customerName
- CIF Number: $customerCif
- Risk Status: ${_getRiskLabel(riskStatus)}
- Credit Score: $creditScore

**User Query:** $userQuery

Please provide a detailed, professional analysis based on this customer's profile. Use markdown formatting for better readability. Include relevant financial insights and recommendations.

Focus on:
1. Direct answer to the query
2. Risk implications if applicable
3. Actionable recommendations
4. Any red flags or opportunities

Be concise but thorough. Use bullet points and sections where appropriate.
    ''';
  }

  /// Clear chat history
  void clearChat() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              messages.clear();
              _sendWelcomeMessage();
              Get.back();
              Get.snackbar(
                'Chat Cleared',
                'Starting fresh conversation',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Get risk label
  String _getRiskLabel(String status) {
    switch (status.toUpperCase()) {
      case 'GREEN':
        return 'Low Risk';
      case 'AMBER':
        return 'Medium Risk';
      case 'RED':
        return 'High Risk';
      default:
        return status;
    }
  }
}

/// Quick action model
class QuickAction {
  final String icon;
  final String category;
  final String title;
  final String? description;
  final String prompt;

  QuickAction({
    required this.icon,
    required this.category,
    required this.title,
    this.description,
    required this.prompt,
  });
}