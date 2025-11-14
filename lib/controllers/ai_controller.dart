import 'dart:convert';
import 'package:finaxis_web/models/local_chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class AiController extends GetxController {
  // Observables
  final localMessages = <LocalChatMessage>[].obs;
  final isTyping = false.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();
  
  // PDF related observables
  final uploadedPdfSourceId = ''.obs;
  final uploadedFileName = ''.obs;
  final isUploadingPdf = false.obs;
  final isPdfChatMode = false.obs;
  
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

  /// Handle PDF Upload
  Future<void> handlePdfUpload() async {
    try {
      // Pick PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        isUploadingPdf.value = true;

        final platformFile = result.files.single;
        final fileName = platformFile.name;

        // Add uploading message
        localMessages.add(LocalChatMessage(
          content: '📄 Uploading PDF: $fileName...',
          isUser: false,
          timestamp: DateTime.now(),
          isPdfUpload: true,
        ));
        _scrollToBottom();

        // Show uploading snackbar
        // Get.snackbar(
        //   '📄 Uploading PDF',
        //   'Processing $fileName...',
        //   snackPosition: SnackPosition.TOP,
        //   duration: const Duration(seconds: 2),
        // );

        // Upload PDF
        final sourceId = await _uploadPdfToChatPdfWeb(platformFile);

        if (sourceId.isNotEmpty) {
          uploadedPdfSourceId.value = sourceId;
          uploadedFileName.value = fileName;
          isPdfChatMode.value = true;

          // Remove uploading message and add success message
          localMessages.removeLast();
          
          localMessages.add(LocalChatMessage(
            content: '''📄 **PDF Document Uploaded Successfully**

**File:** $fileName

I can now analyze this document for you. You can ask me:
• Summary of the document
• Key information extraction
• Specific questions about the content
• Document analysis

What would you like to know about this document?''',
            isUser: false,
            timestamp: DateTime.now(),
            isPdfUpload: true,
          ));

          _scrollToBottom();

          // Get.snackbar(
          //   '✅ PDF Ready',
          //   'You can now ask questions about $fileName',
          //   snackPosition: SnackPosition.TOP,
          //   backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
          //   duration: const Duration(seconds: 3),
          // );
        }
      }
    } catch (e) {
      print('Error uploading PDF: $e');
      // Get.snackbar(
      //   '❌ Upload Failed',
      //   'Error uploading PDF: ${e.toString()}',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.red.withOpacity(0.1),
      // );
    } finally {
      isUploadingPdf.value = false;
    }
  }

  /// Upload PDF to ChatPDF
  Future<String> _uploadPdfToChatPdfWeb(PlatformFile platformFile) async {
    const apiKey = 'sec_aQhHyq7ih2mnjLzWzMYE7ZKCQaTdE8TI';

    try {
      final bytes = platformFile.bytes;
      final fileName = platformFile.name;

      if (bytes == null) {
        throw Exception("PDF bytes are null — Web requires byte upload");
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.chatpdf.com/v1/sources/add-file'),
      );

      request.headers['x-api-key'] = apiKey;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
          contentType: http.MediaType('application', 'pdf'),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return json['sourceId'] ?? '';
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload PDF: $e');
    }
  }

  /// Send message to ChatPDF API
  Future<String> _sendChatPdfMessage(String sourceId, String message) async {
    const apiKey = 'sec_aQhHyq7ih2mnjLzWzMYE7ZKCQaTdE8TI';

    try {
      var url = 'https://api.chatpdf.com/v1/chats/message';
      var headers = {'Content-Type': 'application/json', 'x-api-key': apiKey};

      var body = jsonEncode({
        'sourceId': sourceId,
        'messages': [
          {'role': 'user', 'content': message},
        ],
        'referenceSources': true,
      });

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        final content = json['content'] ?? '';

        // Extract references if available
        final references = json['references'] as List?;
        String referencesText = '';

        if (references != null && references.isNotEmpty) {
          referencesText = '\n\n**References:**\n';
          for (var ref in references) {
            referencesText += '• Page ${ref['page']}: ${ref['text']}\n';
          }
        }

        return content;
      } else {
        throw Exception(
          'Chat request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// End PDF Chat Mode
  void endPdfChat() {
    isPdfChatMode.value = false;
    uploadedPdfSourceId.value = '';
    uploadedFileName.value = '';

    localMessages.add(LocalChatMessage(
      content: '✅ PDF chat ended. You can now continue with normal chat or upload a new PDF.',
      isUser: false,
      timestamp: DateTime.now(),
    ));

    _scrollToBottom();

    // Get.snackbar(
    //   'PDF Chat Ended',
    //   'Returning to normal chat mode',
    //   snackPosition: SnackPosition.TOP,
    //   duration: const Duration(seconds: 2),
    // );
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

  // Check if in PDF chat mode
  if (isPdfChatMode.value && uploadedPdfSourceId.value.isNotEmpty) {
    try {
      // Get response from ChatPDF
      final aiResponse = await _sendChatPdfMessage(
        uploadedPdfSourceId.value,
        message,
      );

      // Hide typing indicator
      isTyping.value = false;

      // Add AI message
      localMessages.add(LocalChatMessage(
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      isTyping.value = false;
      localMessages.add(LocalChatMessage(
        content: '❌ Error getting response from PDF: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }
  } else {
    // Normal hardcoded response
    await Future.delayed(const Duration(milliseconds: 900));
    isTyping.value = false;

    final aiResponse = _getHardcodedResponse(message.toLowerCase());

    // Check if this is the default response with options
    final shouldShowOptions = aiResponse.contains("I can help you with:");
    
    localMessages.add(LocalChatMessage(
      content: aiResponse,
      isUser: false,
      timestamp: DateTime.now(),
      options: shouldShowOptions ? [
        ChatOption(
          label: "Risk Distribution",
          message: "Give me the risk distribution of my applicants",
          icon: Icons.pie_chart_rounded,
        ),
        ChatOption(
          label: "Portfolio Analysis",
          message: "What all kind of business, customer segment approach for loan",
          icon: Icons.business_center_rounded,
        ),
        ChatOption(
          label: "Approval Rates",
          message: "Analyze loan approval rates",
          icon: Icons.check_circle_rounded,
        ),
      ] : null,
    ));
  }

  // Scroll to bottom
  _scrollToBottom();
}
  /// Send quick action message
  Future<void> sendQuickActionMessage(String message) async {
    await sendHardcodedMessage(message);
  }

  /// Get hardcoded AI responses
  String _getHardcodedResponse(String input, {bool returnOptions = false}) {
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
      "Risk Distribution - Detailed applicant risk analysis\n"
      "Portfolio Analysis - Business types & customer segments\n"
      "Approval Rates - Performance metrics & trends\n\n"
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
  
  ChatSession addMessage(ChatMessage message) {
    return ChatSession(
      id: id,
      messages: [...messages, message],
    );
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String sessionId;
  final List<ChatAction>? actions;
  final dynamic usage;
  
  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    required this.sessionId,
    this.actions,
    this.usage,
  });
  
  factory ChatMessage.assistant({
    required String content,
    required String sessionId,
  }) {
    return ChatMessage(
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      sessionId: sessionId,
    );
  }
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