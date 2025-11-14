import 'package:finaxis_web/controllers/ai_controller.dart';
import 'package:finaxis_web/models/local_chat_message.dart';
import 'package:finaxis_web/widgets/futuristic_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../controllers/theme_controller.dart';

/// 🤖 AI Chat Hub - Enhanced with Hardcoded Responses
class AiChatView extends StatelessWidget {
  const AiChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(AiController(), permanent: false);
    final themeController = Get.find<ThemeController>();

    return FuturisticLayout(
      selectedIndex: 0,
      pageTitle: 'AI Chat Hub',
      // headerActions: [
      //   _buildHeaderAction(
      //     icon: Icons.settings,
      //     label: 'Settings',
      //     onTap: () => Get.snackbar('AI Chat Settings', 'Coming soon'),
      //     color: Colors.blue,
      //   ),
      // ],
      child: GetBuilder<AiController>(
        init: controller,
        builder: (ctrl) => _buildChatInterface(context, themeController, ctrl),
      ),
    );
  }

  Widget _buildHeaderAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  /// Build main chat interface
  Widget _buildChatInterface(
    BuildContext context, 
    ThemeController themeController,
    AiController controller,
  ) {
    return Obx(() {
      final hasMessages = controller.localMessages.isNotEmpty;

      return Column(
        children: [
          if (!hasMessages) _buildGlowingHeader(context, themeController),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildMessagesArea(context, themeController, controller),
                ),
                if (!hasMessages)
                  _buildQuickActions(context, themeController, controller),
              ],
            ),
          ),
          _buildChatInput(context, themeController, controller),
        ],
      );
    });
  }

  /// Build glowing header
  Widget _buildGlowingHeader(BuildContext context, ThemeController themeController) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 16),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => themeController.getPrimaryGradient()
                .createShader(bounds),
            child: Text(
              'Finaxis AI',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1.0,
              ),
            ),
          ).animate()
            .fadeIn(duration: 800.ms, delay: 200.ms)
            .slideY(begin: -0.3, end: 0)
            .then()
            .shimmer(duration: 2000.ms, delay: 1000.ms),
          
          const SizedBox(height: 8),
          
          SizedBox(
            height: 30,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Your AI-Powered Financial Assistant',
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    letterSpacing: 0.8,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
                TypewriterAnimatedText(
                  'Advanced Risk Analysis & Portfolio Insights',
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    letterSpacing: 0.8,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(seconds: 2),
            ),
          ).animate()
            .fadeIn(duration: 1000.ms, delay: 1200.ms),
        ],
      ),
    );
  }

  /// Build messages area
  Widget _buildMessagesArea(
    BuildContext context, 
    ThemeController themeController,
    AiController controller,
  ) {
    return Obx(() {
      final messages = controller.localMessages;
      final isTyping = controller.isTyping.value;
      
      if (messages.isEmpty && !isTyping) {
        return _buildEmptyState(context, themeController);
      }
      
      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: messages.length + (isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == messages.length && isTyping) {
            return _buildTypingIndicator(context, themeController);
          }
          
          final message = messages[index];
          return _buildMessageBubble(
            message,
            context,
            themeController,
          ).animate(delay: (index * 100).ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic);
        },
      );
    });
  }

  /// Build typing indicator
  Widget _buildTypingIndicator(BuildContext context, ThemeController themeController) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16, right: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatarIcon(false, themeController),
          const SizedBox(width: 12),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: themeController.getThemeData().primaryColor.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTypingDot(0, isDark),
                const SizedBox(width: 6),
                _buildTypingDot(200, isDark),
                const SizedBox(width: 6),
                _buildTypingDot(400, isDark),
              ],
            ),
          ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2000.ms, color: themeController.getThemeData().primaryColor.withOpacity(0.3)),
        ],
      ),
    );
  }

  /// Build individual typing dot
  Widget _buildTypingDot(int delay, bool isDark) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
      .fadeOut(delay: delay.ms, duration: 600.ms)
      .then()
      .fadeIn(duration: 600.ms);
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context, ThemeController themeController) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: themeController.getPrimaryGradient(),
                boxShadow: [
                  BoxShadow(
                    color: themeController.getThemeData().primaryColor.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                size: 60,
                color: Colors.white,
              ),
            ).animate()
              .scale(delay: 300.ms, duration: 800.ms)
              .then()
              .shake(hz: 1, curve: Curves.easeInOutCubic)
              .then()
              .shimmer(duration: 3000.ms),
            
            const SizedBox(height: 32),
            
            Text(
              'Ask me anything about your',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ).animate(delay: 800.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
            
            ShaderMask(
              shaderCallback: (bounds) => themeController.getPrimaryGradient()
                  .createShader(bounds),
              child: Text(
                'Customers',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ).animate(delay: 1000.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 16),
            
            Text(
              'Get instant risk and opportunity insights',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            ).animate(delay: 1200.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }

  /// Build message bubble
  Widget _buildMessageBubble(
    LocalChatMessage message,
    BuildContext context,
    ThemeController themeController,
  ) {
    final isUser = message.isUser;
    
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: isUser ? 60 : 0,
        right: isUser ? 0 : 60,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatarIcon(false, themeController),
          if (!isUser) const SizedBox(width: 12),
          
          Flexible(
            child: _buildMessageContent(message, context, themeController),
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
            color: (isUser ? Colors.grey : themeController.getThemeData().primaryColor)
                .withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        isUser ? Icons.person_rounded : Icons.smart_toy_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  /// Build message content
Widget _buildMessageContent(
  LocalChatMessage message,
  BuildContext context,
  ThemeController themeController,
) {
  final isUser = message.isUser;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  
  return Column(
    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
          minWidth: 100,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isUser
                ? [
                    themeController.getThemeData().primaryColor.withOpacity(0.15),
                    themeController.getThemeData().primaryColor.withOpacity(0.08),
                  ]
                : isDark
                    ? [
                        Colors.grey.shade800,
                        Colors.grey.shade900,
                      ]
                    : [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
          ),
          border: Border.all(
            color: isUser
                ? themeController.getThemeData().primaryColor.withOpacity(0.3)
                : isDark
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isUser
                  ? themeController.getThemeData().primaryColor.withOpacity(0.15)
                  : Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: SelectableText(
            message.content,
            style: TextStyle(
              height: 1.5,
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 15,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
      
      const SizedBox(height: 6),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          _formatTimestamp(message.timestamp),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
            fontSize: 11,
          ),
        ),
      ),
    ],
  );
}

  /// Build quick actions panel
  Widget _buildQuickActions(
    BuildContext context, 
    ThemeController themeController,
    AiController controller,
  ) {
    final quickActions = [
      QuickActionItem(
        icon: '🔴',
        category: 'Risk Analysis',
        title: 'Give me the risk distribution of my applicants',
        message: 'Provide a detailed risk distribution of all applicants, including segments such as low, medium, and high risk, along with key risk indicators.',
      ),
      QuickActionItem(
        icon: '📊',
        category: 'Portfolio',
        title: 'What all kind of business, customer segment approach for loan',
        message: 'Explain the different business types and customer segments eligible for loans, along with their typical loan approaches, risk profiles, and evaluation criteria.',
      ),
      QuickActionItem(
        icon: '✅',
        category: 'Performance',
        title: 'Analyze loan approval rates',
        message: 'Analyze our loan approval rates by category, risk level, and time period. Identify patterns and improvement opportunities.',
      ),
    ];

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          final itemCount = quickActions.length;
          final itemHeight = availableHeight / itemCount;

          return SingleChildScrollView(
            child: Column(
              children: [
                for (int index = 0; index < itemCount; index++)
                  SizedBox(
                    height: itemHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: _buildQuickActionCard(
                              quickActions[index], themeController, context, controller)
                          .animate(delay: (index * 100).ms)
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build quick action card
  Widget _buildQuickActionCard(
    QuickActionItem action,
    ThemeController themeController,
    BuildContext context,
    AiController controller,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.sendQuickActionMessage(action.message),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeController.getThemeData().primaryColor.withOpacity(0.1),
                themeController.getThemeData().primaryColor.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: themeController.getThemeData().primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: themeController.getThemeData().primaryColor.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    action.icon,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      action.category,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: themeController.getThemeData().primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                action.title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  height: 1.3,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build chat input
  Widget _buildChatInput(
    BuildContext context, 
    ThemeController themeController,
    AiController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildVoiceButton(themeController),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTextInput(context, themeController, controller),
          ),
          const SizedBox(width: 12),
          _buildSendButton(themeController, controller),
        ],
      ),
    );
  }

  /// Build voice button
  Widget _buildVoiceButton(ThemeController themeController) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: themeController.getPrimaryGradient(),
        boxShadow: [
          BoxShadow(
            color: themeController.getThemeData().primaryColor.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.snackbar(
              'Voice Input',
              'Voice recording feature coming soon',
              snackPosition: SnackPosition.TOP,
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: const Icon(
            Icons.mic_none_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// Build text input
  Widget _buildTextInput(
    BuildContext context, 
    ThemeController themeController,
    AiController controller,
  ) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 120),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeController.getThemeData().primaryColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller.textController,
        onSubmitted: (value) => _handleSendMessage(controller),
        maxLines: null,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          hintText: 'Ask Finaxis AI about your customers...',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  /// Build send button
  Widget _buildSendButton(ThemeController themeController, AiController controller) {
    return Obx(() => Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: controller.isTyping.value
            ? LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade600],
              )
            : themeController.getPrimaryGradient(),
        boxShadow: [
          BoxShadow(
            color: themeController.getThemeData().primaryColor.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.isTyping.value ? null : () => _handleSendMessage(controller),
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            controller.isTyping.value
                ? Icons.hourglass_empty_rounded
                : Icons.send_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    ));
  }

  /// Handle send message
  void _handleSendMessage(AiController controller) {
    final text = controller.textController.text.trim();
    if (text.isNotEmpty) {
      controller.sendHardcodedMessage(text);
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