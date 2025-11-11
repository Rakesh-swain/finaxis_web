import 'package:finaxis_web/widgets/futuristic_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../controllers/ai_chat_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../models/chat_message.dart';
import '../../services/chatgpt_service.dart';
import '../../widgets/futuristic_sidebar.dart';

/// 🤖 AI Chat Hub - Primary Feature of the Platform
/// Inspired by Perplexity AI + ChatGPT hybrid interface
class AiChatView extends GetView<AiChatController> {
  const AiChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return FuturisticLayout(
      selectedIndex: 0, // AI Chat Hub
      pageTitle: 'AI Chat Hub',
      headerActions: [
        _buildHeaderAction(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () => Get.snackbar('AI Chat Settings', 'Coming soon'),
          color: Colors.blue,
        ),
      ],
      child: _buildChatInterface(context, themeController),
    );
  }

  // Optional helper to create header actions (like in ConsentView)
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


  /// Build background gradient with particle effects
  // Widget _buildBackgroundGradient(ThemeController themeController) {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 800),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           themeController.getThemeData().scaffoldBackgroundColor,
  //           themeController.getThemeData().primaryColor.withOpacity(0.05),
  //           themeController.getThemeData().scaffoldBackgroundColor,
  //         ],
  //         stops: const [0.0, 0.5, 1.0],
  //       ),
  //     ),
  //   );
  // }

  /// Build main chat interface
Widget _buildChatInterface(BuildContext context, ThemeController themeController) {
  return Column(
    children: [
      // 🎨 Glowing Header (top, full width)
      _buildGlowingHeader(context, themeController),

      // 🧱 Main chat area: Messages + Quick Actions (side by side)
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: Messages
            Expanded(
              flex: 3,
              child: _buildMessagesArea(context, themeController),
            ),

            // Right: Quick Actions
            _buildQuickActions(context, themeController),
          ],
        ),
      ),

      // ⌨️ Chat Input
      _buildChatInput(context, themeController),
    ],
  );
}






  /// Build glowing header with Finaxis branding
  Widget _buildGlowingHeader(BuildContext context, ThemeController themeController) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 16),
      child: Column(
        children: [
          // 🌟 Main Title with Gradient Effect
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
          
          // ✨ Subtitle with Typing Effect
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
                TypewriterAnimatedText(
                  'Real-time Market Intelligence & Compliance',
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    letterSpacing: 0.8,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(seconds: 2),
              displayFullTextOnTap: true,
            ),
          ).animate()
            .fadeIn(duration: 1000.ms, delay: 1200.ms),
        ],
      ),
    );
  }

  /// Build messages area with chat bubbles
  Widget _buildMessagesArea(BuildContext context, ThemeController themeController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Obx(() {
        final messages = controller.currentSession.value?.messages ?? [];
        
        if (messages.isEmpty) {
          return _buildEmptyState(context, themeController);
        }
        
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
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
      }),
    );
  }

  /// Build empty state with welcome animation
  Widget _buildEmptyState(BuildContext context, ThemeController themeController) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🤖 AI Robot Icon
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
            
            // 💭 Welcome Text
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
                'Customer',
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
              'Get instant risk and oppotunity insights',
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

  /// Build individual message bubble
  Widget _buildMessageBubble(
    ChatMessage message,
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
          
          Expanded(
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

  /// Build message content bubble
  Widget _buildMessageContent(
    ChatMessage message,
    BuildContext context,
    ThemeController themeController,
  ) {
    final isUser = message.isUser;
    
    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // 💬 Message Bubble
        GlassmorphicContainer(
          width: double.infinity,
          height: 0,
          borderRadius: 20,
          blur: 20,
          alignment: Alignment.bottomCenter,
          border: 1,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isUser
                ? [
                    themeController.getThemeData().primaryColor.withOpacity(0.2),
                    themeController.getThemeData().primaryColor.withOpacity(0.1),
                  ]
                : [
                    Theme.of(context).cardColor.withOpacity(0.8),
                    Theme.of(context).cardColor.withOpacity(0.6),
                  ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeController.getThemeData().primaryColor.withOpacity(0.2),
              themeController.getThemeData().primaryColor.withOpacity(0.1),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📝 Message Content
                isUser
                    ? SelectableText(
                        message.content,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.4,
                        ),
                      )
                    : MarkdownBody(
                        data: message.content,
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                      ),
                
                // 🎯 Action Buttons
                if (message.actions != null && message.actions!.isNotEmpty)
                  ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: message.actions!.map((action) {
                        return _buildActionButton(action, themeController,context);
                      }).toList(),
                    ),
                  ],
                
                // 📊 Usage Stats (for AI messages)
                if (!isUser && message.usage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    message.usage.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        
        // 🕐 Timestamp
        const SizedBox(height: 4),
        Text(
          _formatTimestamp(message.timestamp),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  /// Build action button
  Widget _buildActionButton(ChatAction action, ThemeController themeController, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleActionTap(action),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: themeController.getThemeData().primaryColor.withOpacity(0.3),
            ),
            gradient: LinearGradient(
              colors: [
                themeController.getThemeData().primaryColor.withOpacity(0.1),
                themeController.getThemeData().primaryColor.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                action.icon ?? '🔗',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 6),
              Text(
                action.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
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

  /// Build quick actions panel
 Widget _buildQuickActions(BuildContext context, ThemeController themeController) {
  return Obx(() {
    final quickActions = controller.quickActions;
    if (quickActions.isEmpty) return const SizedBox.shrink();

    return Container(
      width: 200, // right panel width
      margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      //   borderRadius: BorderRadius.circular(16),
      //   border: Border.all(
      //     color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.05),
      //       blurRadius: 8,
      //       offset: const Offset(0, 4),
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: Text(
          //     'Quick Actions',
          //     style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //           fontWeight: FontWeight.w600,
          //           color: Theme.of(context)
          //               .textTheme
          //               .bodyMedium
          //               ?.color
          //               ?.withOpacity(0.8),
          //         ),
          //   ),
          // ),
          // const Divider(height: 1),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableHeight = constraints.maxHeight;
                final itemCount = quickActions.length;
                final itemHeight = availableHeight / itemCount; // 👈 evenly divide space

                return Column(
                  children: [
                    for (int index = 0; index < itemCount; index++)
                      SizedBox(
                        height: itemHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: _buildQuickActionCard(
                                  quickActions[index], themeController, context)
                              .animate(delay: (index * 100).ms)
                              .fadeIn(duration: 500.ms)
                              .slideY(begin: 0.2, end: 0),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  });
}





  /// Build quick action card
  Widget _buildQuickActionCard(QuickAction action, ThemeController themeController, BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.sendQuickAction(action),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
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
                color: themeController.getThemeData().primaryColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      action.icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        action.category,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: themeController.getThemeData().primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  action.title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build chat input area
  Widget _buildChatInput(BuildContext context, ThemeController themeController) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 🎤 Voice Input Button
          _buildVoiceButton(themeController),
          
          const SizedBox(width: 12),
          
          // 📝 Text Input Field
          Expanded(
            child: _buildTextInput(context, themeController),
          ),
          
          const SizedBox(width: 12),
          
          // 🚀 Send Button
          _buildSendButton(themeController),
        ],
      ),
    );
  }

  /// Build voice input button
  Widget _buildVoiceButton(ThemeController themeController) {
    return Obx(() => Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: controller.isRecording.value
            ? const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF5252)],
              )
            : themeController.getPrimaryGradient(),
        boxShadow: [
          BoxShadow(
            color: (controller.isRecording.value ? Colors.red : themeController.getThemeData().primaryColor)
                .withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleVoiceRecording,
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            controller.isRecording.value ? Icons.mic : Icons.mic_none_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    ));
  }

  /// Build text input field
  Widget _buildTextInput(BuildContext context, ThemeController themeController) {
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
        onChanged: (value) => controller.currentInput.value = value,
        onSubmitted: (value) => _handleSendMessage(),
        maxLines: null,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          hintText: 'Ask Finaxis AI about your customer...',
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
  Widget _buildSendButton(ThemeController themeController) {
    return Obx(() => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: controller.isLoading.value || controller.isStreaming.value
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
          onTap: controller.isLoading.value || controller.isStreaming.value
              ? null
              : _handleSendMessage,
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            controller.isLoading.value || controller.isStreaming.value
                ? Icons.hourglass_empty_rounded
                : Icons.send_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    ));
  }

  /// Handle navigation from sidebar
  void _handleNavigation(int index) {
    final routes = [
      '/ai-chat',     // 0: AI Chat Hub (current)
      '/dashboard',   // 1: Dashboard
      '/applicants',  // 2: Applicants
      '/consent',     // 3: Consents
      '/analytics',   // 4: Analytics
      '/reports',     // 5: Reports
      '/audit-log',   // 6: Audit Log
      '/settings',    // 7: Settings
    ];
    
    if (index < routes.length && routes[index] != '/ai-chat') {
      Get.offNamed(routes[index]);
    }
  }

  /// Handle action button tap
  void _handleActionTap(ChatAction action) {
    switch (action.type) {
      case 'navigation':
        if (action.route != null) {
          Get.toNamed(action.route!);
        }
        break;
      case 'export':
        // Handle export logic
        Get.snackbar(
          'Export',
          'Data export functionality will be implemented soon',
          snackPosition: SnackPosition.TOP,
        );
        break;
      case 'filter':
        // Handle filter logic
        Get.snackbar(
          'Filter',
          'Filter functionality will be implemented soon',
          snackPosition: SnackPosition.TOP,
        );
        break;
    }
  }

  /// Handle sending message
  void _handleSendMessage() {
    final input = controller.currentInput.value.trim();
    if (input.isNotEmpty) {
      controller.sendMessage(input, useStream: true);
    }
  }

  /// Toggle voice recording
  void _toggleVoiceRecording() {
    // Voice recording functionality will be implemented
    Get.snackbar(
      'Voice Input',
      'Voice recording feature will be available soon',
      snackPosition: SnackPosition.TOP,
    );
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
  
  /// Build background gradient based on current theme
  LinearGradient _buildBackgroundGradient(ThemeController themeController) {
    final themeName = themeController.currentThemeName;
    
    switch (themeName) {
      case 'Classic Light':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAFBFC), // Pure White
            Color(0xFFF8FAFC), // Soft White
          ],
        );
      case 'Emerald Luxe':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0FDF4), // Mint White
            Color(0xFFECFDF5), // Light Mint
          ],
        );
      case 'Royal Gold':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFEFCF3), // Cream
            Color(0xFFFEF3C7), // Light Cream
          ],
        );
      case 'Aurora Green':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFECFEFF), // Ice White
            Color(0xFFCFFAFE), // Light Ice Blue
          ],
        );
      case 'Cyber Violet':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAF5FF), // Lilac White
            Color(0xFFF3E8FF), // Light Lilac
          ],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAFBFC), // Pure White
            Color(0xFFF8FAFC), // Soft White
          ],
        );
    }
  }
}