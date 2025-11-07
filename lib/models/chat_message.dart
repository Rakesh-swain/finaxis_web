import 'dart:convert';

/// 💬 Chat Message Model for AI Conversations
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String sessionId;
  final ChatUsage? usage;
  final List<ChatAction>? actions;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    required this.sessionId,
    this.usage,
    this.actions,
    this.metadata,
  });

  /// Create user message
  factory ChatMessage.user({
    required String content,
    String? sessionId,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
      sessionId: sessionId ?? 'default',
      metadata: metadata,
    );
  }

  /// Create AI assistant message
  factory ChatMessage.assistant({
    required String content,
    String? sessionId,
    ChatUsage? usage,
    List<ChatAction>? actions,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      sessionId: sessionId ?? 'default',
      usage: usage,
      actions: actions,
      metadata: metadata,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'sessionId': sessionId,
      'usage': usage?.toJson(),
      'actions': actions?.map((a) => a.toJson()).toList(),
      'metadata': metadata,
    };
  }

  /// Create from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      sessionId: json['sessionId'],
      usage: json['usage'] != null ? ChatUsage.fromJson(json['usage']) : null,
      actions: json['actions'] != null
          ? (json['actions'] as List)
              .map((a) => ChatAction.fromJson(a))
              .toList()
          : null,
      metadata: json['metadata'],
    );
  }

  /// Convert to JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Create from JSON string
  factory ChatMessage.fromJsonString(String jsonString) {
    return ChatMessage.fromJson(jsonDecode(jsonString));
  }

  /// Copy with new properties
  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    String? sessionId,
    ChatUsage? usage,
    List<ChatAction>? actions,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      sessionId: sessionId ?? this.sessionId,
      usage: usage ?? this.usage,
      actions: actions ?? this.actions,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() => 'ChatMessage(id: $id, isUser: $isUser, content: $content)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 📊 ChatGPT API Usage Statistics
class ChatUsage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final double? cost; // Estimated cost in USD

  ChatUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    this.cost,
  });

  /// Create from ChatGPT API response
  factory ChatUsage.fromJson(Map<String, dynamic> json) {
    final promptTokens = json['prompt_tokens'] ?? 0;
    final completionTokens = json['completion_tokens'] ?? 0;
    final totalTokens = json['total_tokens'] ?? 0;

    // Estimate cost based on GPT-4 pricing (approximate)
    final cost = _estimateGPT4Cost(promptTokens, completionTokens);

    return ChatUsage(
      promptTokens: promptTokens,
      completionTokens: completionTokens,
      totalTokens: totalTokens,
      cost: cost,
    );
  }

  /// Estimate GPT-4 cost (as of 2024 pricing)
  static double _estimateGPT4Cost(int promptTokens, int completionTokens) {
    const promptCostPer1K = 0.03; // $0.03 per 1K prompt tokens
    const completionCostPer1K = 0.06; // $0.06 per 1K completion tokens
    
    final promptCost = (promptTokens / 1000) * promptCostPer1K;
    final completionCost = (completionTokens / 1000) * completionCostPer1K;
    
    return promptCost + completionCost;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'total_tokens': totalTokens,
      'cost': cost,
    };
  }

  @override
  String toString() {
    return 'Usage: ${totalTokens} tokens (\$${cost?.toStringAsFixed(4) ?? 'N/A'})';
  }
}

/// 🎯 Chat Action - Clickable actions in AI responses
class ChatAction {
  final String id;
  final String label;
  final String type; // 'navigation', 'export', 'filter', 'chart'
  final String? route;
  final Map<String, dynamic>? params;
  final String? icon;

  ChatAction({
    required this.id,
    required this.label,
    required this.type,
    this.route,
    this.params,
    this.icon,
  });

  /// Create navigation action
  factory ChatAction.navigation({
    required String label,
    required String route,
    Map<String, dynamic>? params,
    String? icon,
  }) {
    return ChatAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      type: 'navigation',
      route: route,
      params: params,
      icon: icon ?? '🔗',
    );
  }

  /// Create export action
  factory ChatAction.export({
    required String label,
    required Map<String, dynamic> params,
    String? icon,
  }) {
    return ChatAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      type: 'export',
      params: params,
      icon: icon ?? '📄',
    );
  }

  /// Create filter action
  factory ChatAction.filter({
    required String label,
    required Map<String, dynamic> params,
    String? icon,
  }) {
    return ChatAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      type: 'filter',
      params: params,
      icon: icon ?? '🔍',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'type': type,
      'route': route,
      'params': params,
      'icon': icon,
    };
  }

  /// Create from JSON
  factory ChatAction.fromJson(Map<String, dynamic> json) {
    return ChatAction(
      id: json['id'],
      label: json['label'],
      type: json['type'],
      route: json['route'],
      params: json['params'],
      icon: json['icon'],
    );
  }
}

/// 💾 Chat Session - Group of related messages
class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatMessage> messages;
  final Map<String, dynamic>? metadata;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    this.metadata,
  });

  /// Create new session
  factory ChatSession.create({
    required String title,
    Map<String, dynamic>? metadata,
  }) {
    return ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: [],
      metadata: metadata,
    );
  }

  /// Add message to session
  ChatSession addMessage(ChatMessage message) {
    final updatedMessages = [...messages, message];
    return ChatSession(
      id: id,
      title: title,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      messages: updatedMessages,
      metadata: metadata,
    );
  }

  /// Get total token usage for session
  int get totalTokens {
    return messages
        .where((m) => m.usage != null)
        .fold(0, (sum, m) => sum + m.usage!.totalTokens);
  }

  /// Get total estimated cost for session
  double get totalCost {
    return messages
        .where((m) => m.usage?.cost != null)
        .fold(0.0, (sum, m) => sum + m.usage!.cost!);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'metadata': metadata,
    };
  }

  /// Create from JSON
  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m))
          .toList(),
      metadata: json['metadata'],
    );
  }
}