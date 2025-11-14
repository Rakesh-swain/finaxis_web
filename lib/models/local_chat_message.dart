import 'package:flutter/material.dart';

class LocalChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isPdfUpload;
  final List<ChatOption>? options; // Add clickable options

  LocalChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isPdfUpload = false,
    this.options,
  });
}

/// Model for clickable chat options
class ChatOption {
  final String label;
  final String message;
  final IconData? icon;

  ChatOption({
    required this.label,
    required this.message,
    this.icon,
  });
}