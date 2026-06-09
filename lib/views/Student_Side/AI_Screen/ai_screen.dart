import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:technation_hub/Models/chat_message_model.dart';
import 'package:technation_hub/controllers/ai_controller.dart';
import 'package:technation_hub/res/Colors/colors.dart';

class OpenClawScreen extends StatefulWidget {
  const OpenClawScreen({super.key});

  @override
  State<OpenClawScreen> createState() => _OpenClawScreenState();
}

class _OpenClawScreenState extends State<OpenClawScreen> {
  late final AIController controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Use find if already registered (e.g. as a bottom-nav tab),
    // otherwise create a new instance.
    controller = Get.isRegistered<AIController>()
        ? Get.find<AIController>()
        : Get.put(AIController());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Messages ─────────────────────────────────────────────────────
          Expanded(child: _buildMessageList()),

          // ── Suggestion chips ─────────────────────────────────────────────
          _SuggestionBar(controller: controller),

          // ── Input ─────────────────────────────────────────────────────────
          _InputBar(
            controller: controller,
            focusNode: _focusNode,
          ),
        ],
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    // Only show the back arrow when pushed as a standalone route (not as a tab)
    final bool canPop = Navigator.of(context).canPop();
    return AppBar(
      backgroundColor: AppColor.backgroundDark,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            )
          : null,
      title: Row(
        children: [
          // Bot avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B63E0), AppColor.primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('OpenClaw',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              Obx(() => Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: controller.isOnline.value
                              ? Colors.greenAccent
                              : Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        controller.isOnline.value
                            ? 'Online'
                            : 'REST mode',
                        style: TextStyle(
                            color: controller.isOnline.value
                                ? Colors.greenAccent
                                : Colors.orange,
                            fontSize: 10),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.white70),
          tooltip: 'Clear chat',
          onPressed: () => _confirmClear(context),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        title: const Text('Clear conversation?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            'This will delete all messages and start a fresh session.'),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.clearChat();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  // ── Message list ────────────────────────────────────────────────────────
  Widget _buildMessageList() {
    return Obx(() {
      final msgs = controller.messages;
      final showTyping = controller.isTyping.value;

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
        itemCount: msgs.length + (showTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == msgs.length) {
            return const _TypingIndicator();
          }
          final msg = msgs[index];
          return msg.isAI
              ? _AIBubble(
                  message: msg,
                  onCopy: () => controller.copyMessage(msg.text),
                )
              : _UserBubble(message: msg);
        },
      );
    });
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Suggestion Bar
// ════════════════════════════════════════════════════════════════════════════
class _SuggestionBar extends StatelessWidget {
  final AIController controller;
  const _SuggestionBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.suggestions;
      if (list.isEmpty) return const SizedBox.shrink();
      return Container(
        color: Colors.white,
        height: 48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final s = list[i];
            return GestureDetector(
              onTap: () => controller.sendMessage(override: s.prompt),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColor.primaryColor.withValues(alpha: 0.25)),
                ),
                child: Text(
                  s.label,
                  style: const TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Input Bar
// ════════════════════════════════════════════════════════════════════════════
class _InputBar extends StatelessWidget {
  final AIController controller;
  final FocusNode focusNode;

  const _InputBar({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColor.lightGreyColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller.messageController,
                focusNode: focusNode,
                maxLines: 5,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Ask OpenClaw anything…',
                  hintStyle:
                      TextStyle(color: AppColor.greyColor, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Send button
          Obx(() {
            final busy = controller.isTyping.value;
            return GestureDetector(
              onTap: busy ? null : () => controller.sendMessage(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: busy ? AppColor.greyColor : AppColor.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: busy
                    ? const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        ),
                      )
                    : const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// AI Bubble  (with markdown-like rendering + long-press copy)
// ════════════════════════════════════════════════════════════════════════════
class _AIBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onCopy;

  const _AIBubble({required this.message, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bot icon
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B63E0), AppColor.primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: GestureDetector(
              onLongPress: onCopy,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: _FormattedText(text: message.text),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: const TextStyle(
                            color: AppColor.greyColor, fontSize: 10),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onCopy,
                        child: const Icon(Icons.copy_outlined,
                            size: 13, color: AppColor.greyColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// User Bubble
// ════════════════════════════════════════════════════════════════════════════
class _UserBubble extends StatelessWidget {
  final ChatMessage message;
  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.45),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.timestamp),
                      style: const TextStyle(
                          color: AppColor.greyColor, fontSize: 10),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      message.status == MessageStatus.error
                          ? Icons.error_outline
                          : Icons.done_all,
                      size: 12,
                      color: message.status == MessageStatus.error
                          ? AppColor.errorColor
                          : AppColor.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Formatted Text  — renders **bold**, • bullets, ``` code blocks
// ════════════════════════════════════════════════════════════════════════════
class _FormattedText extends StatelessWidget {
  final String text;
  const _FormattedText({required this.text});

  @override
  Widget build(BuildContext context) {
    final segments = _parse(text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: segments,
    );
  }

  List<Widget> _parse(String raw) {
    final lines = raw.split('\n');
    final List<Widget> widgets = [];

    bool inCodeBlock = false;
    final List<String> codeLines = [];

    for (final line in lines) {
      if (line.trim().startsWith('```')) {
        if (inCodeBlock) {
          // close code block
          widgets.add(_CodeBlock(code: codeLines.join('\n')));
          codeLines.clear();
          inCodeBlock = false;
        } else {
          inCodeBlock = true;
        }
        continue;
      }

      if (inCodeBlock) {
        codeLines.add(line);
        continue;
      }

      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 6));
        continue;
      }

      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: _InlineText(text: line),
      ));
    }

    // unclosed code block
    if (inCodeBlock && codeLines.isNotEmpty) {
      widgets.add(_CodeBlock(code: codeLines.join('\n')));
    }

    return widgets;
  }
}

class _InlineText extends StatelessWidget {
  final String text;
  const _InlineText({required this.text});

  @override
  Widget build(BuildContext context) {
    // Parse **bold** segments
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int last = 0;

    // Handle bullet prefix
    String body = text;
    bool isBullet = false;
    if (text.startsWith('• ') || text.startsWith('* ') ||
        text.startsWith('- ')) {
      isBullet = true;
      body = text.substring(2);
    }

    for (final match in regex.allMatches(body)) {
      if (match.start > last) {
        spans.add(TextSpan(
            text: body.substring(last, match.start),
            style: const TextStyle(fontSize: 14, height: 1.5)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.bold),
      ));
      last = match.end;
    }
    if (last < body.length) {
      spans.add(TextSpan(
          text: body.substring(last),
          style: const TextStyle(fontSize: 14, height: 1.5)));
    }

    final richText = RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Color(0xFF1A1A2E), // explicit color — RichText doesn't inherit from theme
        ),
        children: spans,
      ),
    );

    if (isBullet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColor.primaryColor)),
          Flexible(child: richText),
        ],
      );
    }
    return richText;
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Code toolbar
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D3F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, size: 14, color: Colors.white54),
                const SizedBox(width: 6),
                const Text('Code',
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    Get.snackbar('Copied', 'Code copied',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.copy_outlined,
                          size: 13, color: Colors.white54),
                      SizedBox(width: 4),
                      Text('Copy',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Code content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(14),
            child: Text(
              code,
              style: const TextStyle(
                color: Color(0xFF89DDFF),
                fontFamily: 'monospace',
                fontSize: 12.5,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Animated Typing Indicator
// ════════════════════════════════════════════════════════════════════════════
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _dots;
  late final List<Animation<double>> _scales;

  @override
  void initState() {
    super.initState();
    _dots = List.generate(3, (i) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) c.repeat(reverse: true);
      });
      return c;
    });
    _scales = _dots
        .map((c) =>
            Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _dots) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B63E0), AppColor.primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _scales[i],
                  builder: (_, __) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor
                          .withValues(alpha: _scales[i].value),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────
String _formatTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
