import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../models/chat_message.dart';

/// 🤖 ChatGPT API Service - AI-First Financial Assistant
class ChatGPTService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  
  // Default API key (configurable)
  static String _apiKey = '';
  static const String _model = 'gpt-4'; // Configurable model
  
  final GetStorage _storage = GetStorage();
  
  /// Initialize with API key
  static void initialize(String apiKey) {
    _apiKey = apiKey;
  }
  
  /// Set API key dynamically
  static void setApiKey(String apiKey) {
    _apiKey = apiKey;
    GetStorage().write('chatgpt_api_key', apiKey);
  }
  
  /// Get stored API key
  static String getStoredApiKey() {
    return GetStorage().read('chatgpt_api_key') ?? '';
  }
  
  /// Check if API key is configured
  static bool get isConfigured => _apiKey.isNotEmpty;
  
  /// Send message to ChatGPT with financial context
  Future<ChatMessage> sendMessage(
    String message,
    List<ChatMessage> conversationHistory, {
    String? sessionId,
    Map<String, dynamic>? financialContext,
  }) async {
    if (!isConfigured) {
      throw Exception('ChatGPT API key not configured');
    }
    
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };
      
      final systemPrompt = _buildSystemPrompt(financialContext);
      final messages = _buildMessageHistory(systemPrompt, conversationHistory, message);
      
      final body = {
        'model': _model,
        'messages': messages,
        'max_tokens': 2000,
        'temperature': 0.7,
        'stream': false,
      };
      
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        final usage = data['usage'];
        
        return ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content,
          isUser: false,
          timestamp: DateTime.now(),
          sessionId: sessionId ?? 'default',
          usage: ChatUsage.fromJson(usage),
        );
      } else {
        final error = jsonDecode(response.body);
        throw Exception('ChatGPT API Error: ${error['error']['message']}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
  
  /// Stream messages from ChatGPT for real-time typing effect
  Stream<String> sendMessageStream(
    String message,
    List<ChatMessage> conversationHistory, {
    String? sessionId,
    Map<String, dynamic>? financialContext,
  }) async* {
    if (!isConfigured) {
      throw Exception('ChatGPT API key not configured');
    }
    
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };
      
      final systemPrompt = _buildSystemPrompt(financialContext);
      final messages = _buildMessageHistory(systemPrompt, conversationHistory, message);
      
      final body = {
        'model': _model,
        'messages': messages,
        'max_tokens': 2000,
        'temperature': 0.7,
        'stream': true,
      };
      
      final request = http.Request('POST', Uri.parse(_baseUrl));
      request.headers.addAll(headers);
      request.body = jsonEncode(body);
      
      final response = await request.send();
      
      if (response.statusCode == 200) {
        await for (final chunk in response.stream.transform(utf8.decoder)) {
          final lines = chunk.split('\\n');
          for (final line in lines) {
            if (line.startsWith('data: ')) {
              final data = line.substring(6);
              if (data.trim() == '[DONE]') break;
              
              try {
                final json = jsonDecode(data);
                final delta = json['choices'][0]['delta'];
                if (delta['content'] != null) {
                  yield delta['content'];
                }
              } catch (_) {
                // Skip malformed chunks
                continue;
              }
            }
          }
        }
      } else {
        throw Exception('ChatGPT Stream Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to stream message: $e');
    }
  }
  
  /// Build financial system prompt with context
  String _buildSystemPrompt(Map<String, dynamic>? financialContext) {
    final basePrompt = '''
You are Finaxis AI, an expert financial assistant integrated into a loan management platform. 

Your expertise includes:
- Risk assessment and credit analysis
- Loan portfolio management
- Financial trends and insights
- Regulatory compliance (banking/finance)
- Data interpretation and visualization recommendations

Current Context:
- Platform: Finaxis (Financial Analytics Platform)
- User Role: Loan Officer/Financial Analyst
- Focus: Enterprise lending and risk management

Guidelines:
- Provide actionable financial insights
- Suggest data visualizations when relevant
- Reference loan application funnels, RAG statuses, and credit scores
- Offer drill-down analysis recommendations
- Keep responses concise but comprehensive
- Use professional, confident tone
- Include relevant financial KPIs and metrics
''';
    
    if (financialContext != null) {
      final contextStr = financialContext.entries
          .map((e) => '- ${e.key}: ${e.value}')
          .join('\\n');
      return '$basePrompt\\n\\nCurrent Financial Data:\\n$contextStr';
    }
    
    return basePrompt;
  }
  
  /// Build conversation message history
  List<Map<String, String>> _buildMessageHistory(
    String systemPrompt,
    List<ChatMessage> history,
    String newMessage,
  ) {
    final messages = <Map<String, String>>[
      {'role': 'system', 'content': systemPrompt},
    ];
    
    // Add conversation history (limit to last 10 messages for context)
    final recentHistory = history.length > 10 
        ? history.sublist(history.length - 10) 
        : history;
    
    for (final msg in recentHistory) {
      messages.add({
        'role': msg.isUser ? 'user' : 'assistant',
        'content': msg.content,
      });
    }
    
    // Add new message
    messages.add({'role': 'user', 'content': newMessage});
    
    return messages;
  }
  
  /// Generate quick action prompts for financial queries
  static List<QuickAction> getFinancialQuickActions() {
    return [
      QuickAction(
        id: 'high_risk_applicants',
        title: 'Show high-risk applicants this month',
        prompt: 'Show me all high-risk loan applicants from this month with their risk factors and recommended actions.',
        icon: '🔴',
        category: 'Risk Analysis',
      ),
      QuickAction(
        id: 'portfolio_snapshot',
        title: 'Generate portfolio snapshot',
        prompt: 'Create a comprehensive portfolio snapshot including total loans, risk distribution, performance metrics, and key trends.',
        icon: '📊',
        category: 'Portfolio',
      ),
      // QuickAction(
      //   id: 'quarterly_trends',
      //   title: 'What trends should I watch this quarter?',
      //   prompt: 'Analyze the current loan portfolio and market conditions. What key trends and risk factors should I monitor this quarter?',
      //   icon: '📈',
      //   category: 'Analytics',
      // ),
      QuickAction(
        id: 'approval_rates',
        title: 'Analyze loan approval rates',
        prompt: 'Analyze our loan approval rates by category, risk level, and time period. Identify patterns and improvement opportunities.',
        icon: '✅',
        category: 'Performance',
      ),
      // QuickAction(
      //   id: 'risk_distribution',
      //   title: 'Review risk distribution trends',
      //   prompt: 'Review the current risk distribution across our loan portfolio. Are we seeing any concerning shifts in risk levels?',
      //   icon: '⚖️',
      //   category: 'Risk Analysis',
      // ),
      // QuickAction(
      //   id: 'compliance_check',
      //   title: 'Regulatory compliance overview',
      //   prompt: 'Provide an overview of our regulatory compliance status and any areas that need attention.',
      //   icon: '🛡️',
      //   category: 'Compliance',
      // ),
    ];
  }
}

/// Quick action model for pre-defined prompts
class QuickAction {
  final String id;
  final String title;
  final String prompt;
  final String icon;
  final String category;
  
  QuickAction({
    required this.id,
    required this.title,
    required this.prompt,
    required this.icon,
    required this.category,
  });
}