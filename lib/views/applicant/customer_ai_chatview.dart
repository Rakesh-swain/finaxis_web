import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../controllers/ai_chat_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../models/chat_message.dart';
import '../../services/chatgpt_service.dart';

/// 👤 Customer-Specific AI Chat - Focused on Individual Customer Analysis
class CustomerAiChatView extends StatelessWidget {
  final String customerId;
  final String customerName;
  final Map<String, dynamic>? customerData;

  const CustomerAiChatView({
    Key? key,
    required this.customerId,
    required this.customerName,
    this.customerData,
  }) : super(key: key);

  /// Static method to open customer chat
  static void open({
    required String customerId,
    required String customerName,
    Map<String, dynamic>? customerData,
  }) {
    Get.to(
      () => CustomerAiChatView(
        customerId: customerId,
        customerName: customerName,
        customerData: customerData,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final chatController = Get.put(
      AiChatController(),
      tag: 'customer_$customerId',
    );

    // Initialize with customer context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCustomerChat(chatController);
    });

    return Scaffold(
      backgroundColor: themeController.getThemeData().scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildCustomerHeader(context, themeController),
          Expanded(
            child: _buildChatInterface(
              context,
              themeController,
              chatController,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle send message with PDF support
  Future<void> _handleSendMessage(
    AiChatController controller,
    TextEditingController textController,
    String pdfSourceId,
    RxString uploadedFileName,
    RxString uploadedPdfSourceId,
  ) async {
    final input = controller.currentInput.value.trim();
    if (input.isEmpty) return;

    try {
      // If PDF is uploaded, use ChatPDF API
      if (pdfSourceId.isNotEmpty) {
        // Add user message to chat
        final userMessage = ChatMessage.user(
          content: input,
          sessionId: controller.currentSession.value?.id ?? 'default',
        );
        controller.currentSession.value = controller.currentSession.value!
            .addMessage(userMessage);

        // Clear input
        textController.clear();
        controller.currentInput.value = '';
        controller.isLoading.value = true;

        // Get response from ChatPDF
        final response = await _sendChatPdfMessage(pdfSourceId, input);

        // Add assistant response
        final assistantMessage = ChatMessage.assistant(
          content: response,
          sessionId: controller.currentSession.value?.id ?? 'default',
        );
        controller.currentSession.value = controller.currentSession.value!
            .addMessage(assistantMessage);

        controller.isLoading.value = false;
      } else {
        // Regular customer chat without PDF
        final customerPrompt =
            'Regarding customer $customerName (ID: $customerId): $input';

        textController.clear();
        controller.currentInput.value = '';
        controller.sendMessage(customerPrompt, useStream: true);
      }
    } catch (e) {
      controller.isLoading.value = false;

      Get.snackbar(
        '❌ Error',
        'Failed to send message: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
      );

      // Add error message to chat
      final errorMessage = ChatMessage.assistant(
        content:
            '⚠️ **Error:** Failed to process your request. Please try again.',
        sessionId: controller.currentSession.value?.id ?? 'default',
      );
      controller.currentSession.value = controller.currentSession.value!
          .addMessage(errorMessage);
    }
  }

  /// Initialize chat with customer context
  void _initializeCustomerChat(AiChatController controller) {
    if (controller.currentSession.value == null ||
        controller.currentSession.value!.messages.isEmpty) {
      // Create customer-specific session
      controller.createNewSession('Chat with $customerName');

      // Add customer welcome message
      final welcomeMessage = ChatMessage.assistant(
        content:
            '''
👋 **Hello! I'm analyzing data for $customerName**

I have access to this customer's complete profile and can help you with:

🔍 **Risk Assessment** - Evaluate credit worthiness and risk factors
📊 **Loan Analysis** - Review loan applications and history
💰 **Financial Health** - Assess income, expenses, and stability
📈 **Trends & Patterns** - Identify behavioral patterns
🎯 **Recommendations** - Suggest next best actions
📄 **Document Analysis** - Upload PDFs for detailed analysis

What would you like to know about this customer?
''',
        sessionId: controller.currentSession.value?.id ?? 'default',
        actions: [
          ChatAction.navigation(
            label: 'View Full Profile',
            route: '/applicants/detail/$customerId',
            icon: '👤',
          ),
          ChatAction.filter(
            label: 'Risk Analysis',
            params: {'customer_id': customerId, 'type': 'risk'},
            icon: '⚠️',
          ),
        ],
      );

      controller.currentSession.value = controller.currentSession.value!
          .addMessage(welcomeMessage);
    }
  }

  /// Build customer-focused header
  Widget _buildCustomerHeader(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeController.getThemeData().primaryColor.withOpacity(0.1),
            themeController.getThemeData().primaryColor.withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: themeController.getThemeData().dividerColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: themeController.getThemeData().cardColor,
              padding: const EdgeInsets.all(12),
            ),
          ),

          const SizedBox(width: 16),

          // Customer avatar
          Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: themeController.getPrimaryGradient(),
                  boxShadow: [
                    BoxShadow(
                      color: themeController
                          .getThemeData()
                          .primaryColor
                          .withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              )
              .animate()
              .scale(delay: 100.ms, duration: 600.ms)
              .shimmer(duration: 2000.ms, delay: 800.ms),

          const SizedBox(width: 16),

          // Customer info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                      customerName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 4),

                Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: themeController
                                .getThemeData()
                                .primaryColor
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: themeController
                                  .getThemeData()
                                  .primaryColor
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.smart_toy_rounded,
                                size: 14,
                                color: themeController
                                    .getThemeData()
                                    .primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'AI Assistant Active',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: themeController
                                          .getThemeData()
                                          .primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideX(begin: -0.2, end: 0),
              ],
            ),
          ),

          // Quick stats
          if (customerData != null) _buildQuickStats(context, themeController),
        ],
      ),
    );
  }

  /// Build quick stats
  Widget _buildQuickStats(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Row(
          children: [
            _buildStatBadge(
              context,
              themeController,
              icon: Icons.credit_score_rounded,
              label: 'Credit Score',
              value: customerData?['credit_score']?.toString() ?? 'N/A',
            ),
            const SizedBox(width: 12),
            _buildStatBadge(
              context,
              themeController,
              icon: Icons.account_balance_rounded,
              label: 'Active Loans',
              value: customerData?['active_loans']?.toString() ?? '0',
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .slideX(begin: 0.2, end: 0);
  }

  /// Build stat badge
  Widget _buildStatBadge(
    BuildContext context,
    ThemeController themeController, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: themeController.getThemeData().cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeController.getThemeData().dividerColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: themeController.getThemeData().primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: themeController.getThemeData().primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Build chat interface
  Widget _buildChatInterface(
    BuildContext context,
    ThemeController themeController,
    AiChatController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            themeController.getThemeData().scaffoldBackgroundColor,
            themeController.getThemeData().scaffoldBackgroundColor.withOpacity(
              0.95,
            ),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main chat area
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _buildMessagesArea(
                    context,
                    themeController,
                    controller,
                  ),
                ),
                _buildChatInput(context, themeController, controller),
              ],
            ),
          ),

          // Customer insights panel
          _buildInsightsPanel(context, themeController, controller),
        ],
      ),
    );
  }

  /// Build messages area
  Widget _buildMessagesArea(
    BuildContext context,
    ThemeController themeController,
    AiChatController controller,
  ) {
    return Obx(() {
      final messages = controller.currentSession.value?.messages ?? [];

      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return _buildMessageBubble(message, context, themeController)
              .animate(delay: (index * 100).ms)
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.3, end: 0);
        },
      );
    });
  }

  /// Build message bubble
  Widget _buildMessageBubble(
    ChatMessage message,
    BuildContext context,
    ThemeController themeController,
  ) {
    final isUser = message.isUser;

    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
        left: isUser ? 80 : 0,
        right: isUser ? 0 : 80,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatarIcon(false, themeController),
          if (!isUser) const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 60),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message content
                      isUser
                          ? SelectableText(
                              message.content,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(height: 1.5),
                            )
                          : MarkdownBody(
                              data: message.content,
                              styleSheet: MarkdownStyleSheet.fromTheme(
                                Theme.of(context),
                              ),
                            ),
                
                      // Actions
                      if (message.actions != null &&
                          message.actions!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: message.actions!.map((action) {
                            return _buildActionChip(
                              action,
                              themeController,
                              context,
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _formatTimestamp(message.timestamp),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          if (isUser) const SizedBox(width: 12),
          if (isUser) _buildAvatarIcon(true, themeController),
        ],
      ),
    );
  }

  /// Build avatar icon
  Widget _buildAvatarIcon(bool isUser, ThemeController themeController) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isUser
            ? LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade600],
              )
            : themeController.getPrimaryGradient(),
        boxShadow: [
          BoxShadow(
            color:
                (isUser
                        ? Colors.grey
                        : themeController.getThemeData().primaryColor)
                    .withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        isUser ? Icons.person_rounded : Icons.psychology_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  /// Build action chip
  Widget _buildActionChip(
    ChatAction action,
    ThemeController themeController,
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleActionTap(action),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                themeController.getThemeData().primaryColor.withOpacity(0.15),
                themeController.getThemeData().primaryColor.withOpacity(0.08),
              ],
            ),
            border: Border.all(
              color: themeController.getThemeData().primaryColor.withOpacity(
                0.3,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(action.icon ?? '🔗', style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                action.label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: themeController.getThemeData().primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build insights panel
  Widget _buildInsightsPanel(
    BuildContext context,
    ThemeController themeController,
    AiChatController controller,
  ) {
    return Container(
          width: 280,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: themeController.getThemeData().dividerColor.withOpacity(
                0.1,
              ),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_rounded,
                      color: themeController.getThemeData().primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Quick Insights',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Expanded(
                child: Obx(() {
                  final actions = controller.quickActions;
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: actions.length,
                    itemBuilder: (context, index) {
                      return _buildCustomerQuickAction(
                            actions[index],
                            themeController,
                            controller,
                            context,
                          )
                          .animate(delay: (index * 100).ms)
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.2, end: 0);
                    },
                  );
                }),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 500.ms)
        .slideX(begin: 0.3, end: 0);
  }

  /// Build customer quick action
  Widget _buildCustomerQuickAction(
    QuickAction action,
    ThemeController themeController,
    AiChatController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _sendCustomerSpecificQuery(action, controller),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  themeController.getThemeData().primaryColor.withOpacity(0.08),
                  themeController.getThemeData().primaryColor.withOpacity(0.03),
                ],
              ),
              border: Border.all(
                color: themeController.getThemeData().primaryColor.withOpacity(
                  0.2,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: themeController.getPrimaryGradient(),
                  ),
                  child: Center(
                    child: Text(
                      action.icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.category,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: themeController.getThemeData().primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        action.title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build chat input with PDF upload
  Widget _buildChatInput(
    BuildContext context,
    ThemeController themeController,
    AiChatController controller,
  ) {
    final textController = TextEditingController();
    final RxString uploadedPdfSourceId = ''.obs;
    final RxString uploadedFileName = ''.obs;
    final RxBool isUploadingPdf = false.obs;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: themeController.getThemeData().dividerColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // PDF Upload Status
          Obx(() {
            if (uploadedFileName.value.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: themeController
                      .getThemeData()
                      .primaryColor
                      .withOpacity(0.1),
                  border: Border.all(
                    color: themeController
                        .getThemeData()
                        .primaryColor
                        .withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: themeController.getThemeData().primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PDF Attached',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: themeController
                                      .getThemeData()
                                      .primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            uploadedFileName.value,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        uploadedPdfSourceId.value = '';
                        uploadedFileName.value = '';
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0);
            }
            return const SizedBox.shrink();
          }),

          // Input Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // PDF Upload Button
              Obx(
                () => Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isUploadingPdf.value
                        ? Colors.grey.shade300
                        : themeController.getThemeData().cardColor,
                    border: Border.all(
                      color: themeController
                          .getThemeData()
                          .primaryColor
                          .withOpacity(0.2),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isUploadingPdf.value
                          ? null
                          : () => _handlePdfUpload(
                              context,
                              uploadedPdfSourceId,
                              uploadedFileName,
                              isUploadingPdf,
                              controller,
                            ),
                      borderRadius: BorderRadius.circular(12),
                      child: Icon(
                        isUploadingPdf.value
                            ? Icons.hourglass_empty
                            : Icons.add_rounded,
                        color: themeController.getThemeData().primaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Text Input
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: themeController
                            .getThemeData()
                            .primaryColor
                            .withOpacity(0.08),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: textController,
                    onChanged: (value) => controller.currentInput.value = value,
                    onSubmitted: (value) => _handleSendMessage(
                      controller,
                      textController,
                      uploadedPdfSourceId.value,
                      uploadedFileName,
                      uploadedPdfSourceId,
                    ),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: uploadedPdfSourceId.value.isEmpty
                          ? 'Ask about $customerName...'
                          : 'Ask about the uploaded PDF...',
                      hintStyle: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.5),
                          ),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Send Button
              Obx(
                () => Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient:
                        controller.isLoading.value ||
                            controller.isStreaming.value
                        ? LinearGradient(
                            colors: [
                              Colors.grey.shade400,
                              Colors.grey.shade600,
                            ],
                          )
                        : themeController.getPrimaryGradient(),
                    boxShadow: [
                      BoxShadow(
                        color: themeController
                            .getThemeData()
                            .primaryColor
                            .withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap:
                          controller.isLoading.value ||
                              controller.isStreaming.value
                          ? null
                          : () => _handleSendMessage(
                              controller,
                              textController,
                              uploadedPdfSourceId.value,
                              uploadedFileName,
                              uploadedPdfSourceId,
                            ),
                      borderRadius: BorderRadius.circular(12),
                      child: Icon(
                        controller.isLoading.value ||
                                controller.isStreaming.value
                            ? Icons.hourglass_empty_rounded
                            : Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Handle PDF upload
Future<void> _handlePdfUpload(
  BuildContext context,
  RxString uploadedPdfSourceId,
  RxString uploadedFileName,
  RxBool isUploadingPdf,
  AiChatController controller,
) async {
  try {
    // Pick PDF file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      isUploadingPdf.value = true;

      final platformFile = result.files.single;      // <-- Updated
      final fileName = platformFile.name;

      // Show uploading message
      Get.snackbar(
        '📄 Uploading PDF',
        'Processing $fileName...',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );

      // Upload using BYTES (Web safe)
      final sourceId = await _uploadPdfToChatPdfWeb(platformFile);

      if (sourceId.isNotEmpty) {
        uploadedPdfSourceId.value = sourceId;
        uploadedFileName.value = fileName;

        final pdfMessage = ChatMessage.assistant(
          content: '''
📄 **PDF Document Uploaded Successfully**

**File:** $fileName

I can now analyze this document for **$customerName**. You can ask me:
- Summary of the document
- Key information extraction
- Specific questions about the content
- Risk assessment based on document data
- Comparison with customer profile

What would you like to know about this document?
''',
          sessionId: controller.currentSession.value?.id ?? 'default',
        );

        controller.currentSession.value =
            controller.currentSession.value!.addMessage(pdfMessage);

        Get.snackbar(
          '✅ PDF Ready',
          'You can now ask questions about $fileName',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
          duration: const Duration(seconds: 3),
        );
      }
    }
  } catch (e) {
    print('Error uploading PDF: $e');
    Get.snackbar(
      '❌ Upload Failed',
      'Error uploading PDF: ${e.toString()}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.1),
    );
  } finally {
    isUploadingPdf.value = false;
  }
}
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
    const apiKey = 'sec_aQhHyq7ih2mnjLzWzMYE7ZKCQaTdE8TI'; // Replace with your API key

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
print(json['content'] + referencesText);
        return content + referencesText;
      } else {
        throw Exception(
          'Chat request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Send customer-specific query
  void _sendCustomerSpecificQuery(
    QuickAction action,
    AiChatController controller,
  ) {
    final customerPrompt =
        'For customer $customerName (ID: $customerId): ${action.prompt}';
    controller.sendMessage(customerPrompt, useStream: true);
  }

  /// Handle send message
  // void _handleSendMessage(AiChatController controller) {
  //   final input = controller.currentInput.value.trim();
  //   if (input.isNotEmpty) {
  //     final customerPrompt =
  //         'Regarding customer $customerName (ID: $customerId): $input';
  //     controller.sendMessage(customerPrompt, useStream: true);
  //   }
  // }

  /// Handle action tap
  void _handleActionTap(ChatAction action) {
    switch (action.type) {
      case 'navigation':
        if (action.route != null) {
          Get.toNamed(action.route!);
        }
        break;
      case 'export':
        Get.snackbar(
          'Export',
          'Exporting customer data...',
          snackPosition: SnackPosition.TOP,
        );
        break;
      case 'filter':
        Get.snackbar(
          'Analysis',
          'Running ${action.params?['type']} analysis...',
          snackPosition: SnackPosition.TOP,
        );
        break;
    }
  }

  /// Format timestamp
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
