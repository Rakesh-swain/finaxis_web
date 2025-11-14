/// models/local_chat_models.dart
/// Shared models for local chat functionality

/// Local Chat Message Model
class LocalChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  LocalChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

/// Quick Action Item Model
class QuickActionItem {
  final String icon;
  final String category;
  final String title;
  final String message;

  QuickActionItem({
    required this.icon,
    required this.category,
    required this.title,
    required this.message,
  });
}