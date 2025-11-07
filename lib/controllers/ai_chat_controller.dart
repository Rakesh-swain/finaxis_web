import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/chat_message.dart';
import '../services/chatgpt_service.dart';

/// 🤖 AI Chat Controller - State Management for ChatGPT Integration
class AiChatController extends GetxController {
  final ChatGPTService _chatService = ChatGPTService();
  final GetStorage _storage = GetStorage();
  
  // ==================== REACTIVE STATE ====================
  
  /// Current chat session
  final Rx<ChatSession?> currentSession = Rx<ChatSession?>(null);
  
  /// All chat sessions
  final RxList<ChatSession> sessions = RxList<ChatSession>([]);
  
  /// Current conversation messages
  RxList<ChatMessage> get messages => 
      currentSession.value?.messages.obs ?? RxList<ChatMessage>([]);
  
  /// Loading states
  final RxBool isLoading = false.obs;
  final RxBool isStreaming = false.obs;
  final RxBool isConfigured = false.obs;
  
  /// Input state
  final RxString currentInput = ''.obs;
  final RxBool isRecording = false.obs; // For voice input
  
  /// Quick actions
  final RxList<QuickAction> quickActions = RxList<QuickAction>([]);
  
  /// API Configuration
  final RxString apiKey = ''.obs;
  final RxString currentModel = 'gpt-4'.obs;
  
  /// Statistics
  final RxInt totalTokensUsed = 0.obs;
  final RxDouble totalCostIncurred = 0.0.obs;
  
  // ==================== INITIALIZATION ====================
  
  @override
  void onInit() {
    super.onInit();
    _initializeChat();
    _loadStoredData();
  }
  
  void _initializeChat() {
    // Load quick actions
    quickActions.value = ChatGPTService.getFinancialQuickActions();
    
    // Check if API key is configured
    final storedKey = ChatGPTService.getStoredApiKey();
    if (storedKey.isNotEmpty) {
      apiKey.value = storedKey;
      ChatGPTService.setApiKey(storedKey);
      isConfigured.value = true;
    }
    
    // Create default session if none exists
    if (sessions.isEmpty) {
      createNewSession('Welcome to Finaxis AI');
    }
  }
  
  void _loadStoredData() {
    try {
      // Load chat sessions from storage
      final storedSessions = _storage.read('chat_sessions');
      if (storedSessions != null) {
        final sessionList = (storedSessions as List)
            .map((s) => ChatSession.fromJson(s))
            .toList();
        sessions.value = sessionList;
        
        // Load last active session
        final lastSessionId = _storage.read('last_active_session');
        if (lastSessionId != null) {
          final session = sessions.firstWhereOrNull((s) => s.id == lastSessionId);
          if (session != null) {
            currentSession.value = session;
          }
        }
      }
      
      // Load statistics
      totalTokensUsed.value = _storage.read('total_tokens_used') ?? 0;
      totalCostIncurred.value = _storage.read('total_cost_incurred') ?? 0.0;
    } catch (e) {
      if (kDebugMode) print('Error loading chat data: $e');
    }
  }
  
  // ==================== SESSION MANAGEMENT ====================
  
  /// Create new chat session
  void createNewSession(String title) {
    final session = ChatSession.create(
      title: title,
      metadata: {
        'created_from': 'ai_chat_hub',
        'version': '1.0.0',
      },
    );
    
    sessions.add(session);
    currentSession.value = session;
    _saveSessionsToStorage();
    
    // Add welcome message for first session
    if (sessions.length == 1) {
      _addWelcomeMessage();
    }
  }
  
  /// Switch to existing session
  void switchToSession(String sessionId) {
    final session = sessions.firstWhereOrNull((s) => s.id == sessionId);
    if (session != null) {
      currentSession.value = session;
      _storage.write('last_active_session', sessionId);
    }
  }
  
  /// Delete session
  void deleteSession(String sessionId) {
    sessions.removeWhere((s) => s.id == sessionId);
    
    // Switch to another session if current was deleted
    if (currentSession.value?.id == sessionId) {
      if (sessions.isNotEmpty) {
        currentSession.value = sessions.last;
      } else {
        createNewSession('New Conversation');
      }
    }
    
    _saveSessionsToStorage();
  }
  
  /// Rename session
  void renameSession(String sessionId, String newTitle) {
    final sessionIndex = sessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex != -1) {
      final session = sessions[sessionIndex];
      final updatedSession = ChatSession(
        id: session.id,
        title: newTitle,
        createdAt: session.createdAt,
        updatedAt: DateTime.now(),
        messages: session.messages,
        metadata: session.metadata,
      );
      
      sessions[sessionIndex] = updatedSession;
      
      if (currentSession.value?.id == sessionId) {
        currentSession.value = updatedSession;
      }
      
      _saveSessionsToStorage();
    }
  }
  
  // ==================== MESSAGE HANDLING ====================
  
  /// Send message to AI
  Future<void> sendMessage(String message, {bool useStream = true}) async {
    if (!isConfigured.value) {
      Get.snackbar(
        'API Key Required', 
        'Please configure your ChatGPT API key in settings.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    
    if (message.trim().isEmpty) return;
    
    try {
      // Add user message
      final userMessage = ChatMessage.user(
        content: message,
        sessionId: currentSession.value?.id ?? 'default',
      );
      _addMessageToCurrentSession(userMessage);
      
      // Clear input
      currentInput.value = '';
      
      // Get financial context
      final financialContext = await _getFinancialContext();
      
      if (useStream) {
        await _sendStreamMessage(message, financialContext);
      } else {
        await _sendRegularMessage(message, financialContext);
      }
      
    } catch (e) {
      _handleChatError(e.toString());
    }
  }
  
  /// Send message with streaming response
  Future<void> _sendStreamMessage(
    String message, 
    Map<String, dynamic>? context,
  ) async {
    isStreaming.value = true;
    
    try {
      final conversationHistory = currentSession.value?.messages ?? [];
      String accumulatedResponse = '';
      
      // Create placeholder message for streaming
      final aiMessage = ChatMessage.assistant(
        content: '',
        sessionId: currentSession.value?.id ?? 'default',
      );
      _addMessageToCurrentSession(aiMessage);
      
      final stream = _chatService.sendMessageStream(
        message,
        conversationHistory,
        sessionId: currentSession.value?.id,
        financialContext: context,
      );
      
      await for (final chunk in stream) {
        accumulatedResponse += chunk;
        
        // Update the last message with accumulated content
        if (currentSession.value != null) {
          final updatedMessages = [...currentSession.value!.messages];
          updatedMessages.last = updatedMessages.last.copyWith(
            content: accumulatedResponse,
          );
          
          final updatedSession = ChatSession(
            id: currentSession.value!.id,
            title: currentSession.value!.title,
            createdAt: currentSession.value!.createdAt,
            updatedAt: DateTime.now(),
            messages: updatedMessages,
            metadata: currentSession.value!.metadata,
          );
          
          currentSession.value = updatedSession;
          _updateSessionInList(updatedSession);
        }
      }
      
      // Add actions to the completed message if applicable
      final actions = _extractActionsFromResponse(accumulatedResponse);
      if (actions.isNotEmpty) {
        _updateLastMessageWithActions(actions);
      }
      
    } finally {
      isStreaming.value = false;
      _saveSessionsToStorage();
    }
  }
  
  /// Send regular (non-streaming) message
  Future<void> _sendRegularMessage(
    String message, 
    Map<String, dynamic>? context,
  ) async {
    isLoading.value = true;
    
    try {
      final conversationHistory = currentSession.value?.messages ?? [];
      
      final aiResponse = await _chatService.sendMessage(
        message,
        conversationHistory,
        sessionId: currentSession.value?.id,
        financialContext: context,
      );
      
      // Extract and add actions
      final actions = _extractActionsFromResponse(aiResponse.content);
      final messageWithActions = aiResponse.copyWith(actions: actions);
      
      _addMessageToCurrentSession(messageWithActions);
      
      // Update usage statistics
      if (aiResponse.usage != null) {
        totalTokensUsed.value += aiResponse.usage!.totalTokens;
        if (aiResponse.usage!.cost != null) {
          totalCostIncurred.value += aiResponse.usage!.cost!;
        }
        _saveUsageStats();
      }
      
    } finally {
      isLoading.value = false;
      _saveSessionsToStorage();
    }
  }
  
  /// Send quick action message
  void sendQuickAction(QuickAction action) {
    sendMessage(action.prompt, useStream: true);
  }
  
  // ==================== UTILITY METHODS ====================
  
  /// Add welcome message
  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage.assistant(
      content: '''
🚀 **Welcome to Finaxis AI!**

I'm your financial assistant, ready to help with:

✅ **Risk Analysis** - Assess loan portfolios and credit scores
📊 **Portfolio Insights** - Generate comprehensive snapshots  
📈 **Trend Analysis** - Identify market patterns and opportunities
🔍 **Data Exploration** - Drill down into specific metrics
📋 **Compliance** - Review regulatory requirements

Try one of the quick actions below, or ask me anything about your financial data!
''',
      sessionId: currentSession.value?.id ?? 'default',
      actions: [
        ChatAction.navigation(
          label: 'View Dashboard',
          route: '/dashboard',
          icon: '📊',
        ),
        ChatAction.navigation(
          label: 'Analyze Applicants',
          route: '/applicants',
          icon: '👥',
        ),
      ],
    );
    
    _addMessageToCurrentSession(welcomeMessage);
  }
  
  /// Add message to current session
  void _addMessageToCurrentSession(ChatMessage message) {
    if (currentSession.value != null) {
      final updatedSession = currentSession.value!.addMessage(message);
      currentSession.value = updatedSession;
      _updateSessionInList(updatedSession);
    }
  }
  
  /// Update session in sessions list
  void _updateSessionInList(ChatSession updatedSession) {
    final index = sessions.indexWhere((s) => s.id == updatedSession.id);
    if (index != -1) {
      sessions[index] = updatedSession;
    }
  }
  
  /// Update last message with actions
  void _updateLastMessageWithActions(List<ChatAction> actions) {
    if (currentSession.value != null && 
        currentSession.value!.messages.isNotEmpty) {
      final lastMessage = currentSession.value!.messages.last;
      final updatedMessage = lastMessage.copyWith(actions: actions);
      
      final updatedMessages = [...currentSession.value!.messages];
      updatedMessages.last = updatedMessage;
      
      final updatedSession = ChatSession(
        id: currentSession.value!.id,
        title: currentSession.value!.title,
        createdAt: currentSession.value!.createdAt,
        updatedAt: DateTime.now(),
        messages: updatedMessages,
        metadata: currentSession.value!.metadata,
      );
      
      currentSession.value = updatedSession;
      _updateSessionInList(updatedSession);
    }
  }
  
  /// Extract actions from AI response
  List<ChatAction> _extractActionsFromResponse(String response) {
    final actions = <ChatAction>[];
    
    // Look for common action patterns in response
    if (response.contains('dashboard') || response.contains('Dashboard')) {
      actions.add(ChatAction.navigation(
        label: 'Open Dashboard',
        route: '/dashboard',
        icon: '📊',
      ));
    }
    
    if (response.contains('applicant') || response.contains('Applicant')) {
      actions.add(ChatAction.navigation(
        label: 'View Applicants',
        route: '/applicants',
        icon: '👥',
      ));
    }
    
    if (response.contains('export') || response.contains('Export')) {
      actions.add(ChatAction.export(
        label: 'Export Data',
        params: {'type': 'csv', 'data': 'current_analysis'},
        icon: '📄',
      ));
    }
    
    return actions;
  }
  
  /// Get current financial context for AI
  Future<Map<String, dynamic>> _getFinancialContext() async {
    // This would typically fetch from your dashboard controller
    // For now, return mock data structure
    return {
      'total_applicants': 1250,
      'active_loans': 890,
      'risk_distribution': {
        'high': 125,
        'medium': 340,
        'low': 785,
      },
      'avg_credit_score': 720,
      'current_month': DateTime.now().month,
      'current_year': DateTime.now().year,
    };
  }
  
  /// Handle chat errors
  void _handleChatError(String error) {
    final errorMessage = ChatMessage.assistant(
      content: '❌ **Error**: $error\\n\\nPlease check your API key configuration and try again.',
      sessionId: currentSession.value?.id ?? 'default',
      actions: [
        ChatAction.navigation(
          label: 'Configure API Key',
          route: '/settings',
          icon: '⚙️',
        ),
      ],
    );
    
    _addMessageToCurrentSession(errorMessage);
    isLoading.value = false;
    isStreaming.value = false;
  }
  
  // ==================== STORAGE METHODS ====================
  
  /// Save sessions to local storage
  void _saveSessionsToStorage() {
    try {
      final sessionsJson = sessions.map((s) => s.toJson()).toList();
      _storage.write('chat_sessions', sessionsJson);
      _storage.write('last_active_session', currentSession.value?.id);
    } catch (e) {
      if (kDebugMode) print('Error saving sessions: $e');
    }
  }
  
  /// Save usage statistics
  void _saveUsageStats() {
    _storage.write('total_tokens_used', totalTokensUsed.value);
    _storage.write('total_cost_incurred', totalCostIncurred.value);
  }
  
  // ==================== CONFIGURATION ====================
  
  /// Configure API key
  void configureApiKey(String newApiKey) {
    if (newApiKey.trim().isNotEmpty) {
      apiKey.value = newApiKey;
      ChatGPTService.setApiKey(newApiKey);
      isConfigured.value = true;
      
      Get.snackbar(
        'Success', 
        'ChatGPT API key configured successfully!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
  
  /// Clear all data
  void clearAllData() {
    sessions.clear();
    currentSession.value = null;
    totalTokensUsed.value = 0;
    totalCostIncurred.value = 0.0;
    
    _storage.remove('chat_sessions');
    _storage.remove('last_active_session');
    _storage.remove('total_tokens_used');
    _storage.remove('total_cost_incurred');
    
    // Create new default session
    createNewSession('New Conversation');
  }
  
  /// Export chat history
  String exportChatHistory() {
    final exportData = {
      'sessions': sessions.map((s) => s.toJson()).toList(),
      'total_tokens': totalTokensUsed.value,
      'total_cost': totalCostIncurred.value,
      'exported_at': DateTime.now().toIso8601String(),
      'version': '1.0.0',
    };
    
    return const JsonEncoder.withIndent('  ').convert(exportData);
  }
}