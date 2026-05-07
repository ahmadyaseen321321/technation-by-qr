import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technation_hub/controllers/ai_controller.dart';
import '../../../res/Colors/colors.dart';

class OpenClawScreen extends StatefulWidget {
  const OpenClawScreen({super.key});

  @override
  State<OpenClawScreen> createState() => _OpenClawScreenState();
}

class _OpenClawScreenState extends State<OpenClawScreen> {
  final controller = Get.put(AIController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundDark,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.smart_toy, color: Colors.white),
            const SizedBox(width: 12),
            const Text('OpenClaw', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('Online', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.messages.length) {
                  return _buildAIMessage("OpenClaw is thinking...");
                }
                final msg = controller.messages[index];
                return msg.isAI ? _buildAIMessage(msg.text) : _buildUserMessage(msg.text);
              },
            )),
          ),
          
          // Suggestions
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSuggestion('Summarize today\'s', onTap: () {
                  controller.messageController.text = 'Summarize today\'s discussions';
                  controller.sendMessage();
                }),
                _buildSuggestion('Quiz me', onTap: () {
                  controller.messageController.text = 'Quiz me on Python';
                  controller.sendMessage();
                }),
                _buildSuggestion('Explain BLoC', onTap: () {
                  controller.messageController.text = 'Explain BLoC pattern';
                  controller.sendMessage();
                }),
              ],
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColor.lightGreyColor)),
            ),
            child: Row(
              children: [
                const Icon(Icons.mic_none_outlined, color: AppColor.greyColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: controller.messageController,
                      onSubmitted: (_) => controller.sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Ask OpenClaw anything...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: controller.sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: AppColor.primaryColor, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 16, backgroundColor: AppColor.primaryColor, child: Icon(Icons.smart_toy, size: 16, color: Colors.white)),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard() {
    return Container(
      margin: const EdgeInsets.only(left: 44, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.trending_up, color: AppColor.primaryColor, size: 18),
              SizedBox(width: 8),
              Text('3 HOT DISCUSSIONS FOUND', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          _buildTrendingItem('TCP vs UDP debate (47 replies)'),
          _buildTrendingItem('List comprehension tricks'),
          _buildTrendingItem('Django vs FastAPI'),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: AppColor.primaryColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('View in Channel', style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16, color: AppColor.primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: AppColor.primaryColor),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildQuizCard() {
    return Container(
      margin: const EdgeInsets.only(left: 44, bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('QUESTION 1/5', style: TextStyle(color: AppColor.greyColor, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text(
            'What is the correct syntax to output "Hello World" in Python?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildQuizOption('A', 'echo("Hello World")'),
          _buildQuizOption('B', 'p("Hello World")'),
          _buildQuizOption('C', 'print("Hello World")', isSelected: true),
          _buildQuizOption('D', 'System.out.println("Hello World")'),
        ],
      ),
    );
  }

  Widget _buildQuizOption(String label, String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.primaryColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? AppColor.primaryColor : AppColor.lightGreyColor),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.primaryColor : AppColor.backgroundLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColor.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, fontFamily: 'monospace'))),
        ],
      ),
    );
  }

  Widget _buildSuggestion(String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.lightGreyColor),
        ),
        child: Center(
          child: Text(text, style: const TextStyle(color: AppColor.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
