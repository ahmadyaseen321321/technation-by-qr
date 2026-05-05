import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/Colors/colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Python Fundamentals', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('8 members • 3 online', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
          ],
        ),
        actions: [
          const Icon(Icons.group_outlined, color: Colors.white),
          const SizedBox(width: 16),
          const Icon(Icons.videocam_outlined, color: Colors.white),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.lightGreyColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Session started • Monday 7:00 PM', style: TextStyle(color: AppColor.greyColor, fontSize: 11)),
                  ),
                ),
                const SizedBox(height: 24),
                _buildOtherMessage('Ali Hassan', 'Let\'s start with list comprehensions today, any questions?', '7:01 PM'),
                _buildOtherMessage('Sara Ahmed', 'Can you show an example with filtering?', '7:03 PM'),
                _buildMyMessage(
                  'Here\'s how I usually do it:',
                  '7:04 PM',
                  hasCode: true,
                  code: 'result = [x for x in numbers if x > 0]',
                ),
                _buildAIMessage('OpenClaw AI', 'Great example! Want me to generate practice problems?', '7:05 PM'),
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
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=me'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.smart_toy_outlined, color: AppColor.primaryColor, size: 14),
                              SizedBox(width: 4),
                              Text('Ask AI', style: TextStyle(color: AppColor.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Message group...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const Icon(Icons.send_rounded, color: AppColor.primaryColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherMessage(String name, String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$name')),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
              const SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(text, style: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 4),
              Text(time, style: TextStyle(color: AppColor.greyColor, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyMessage(String text, String time, {bool hasCode = false, String? code}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.7),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
                if (hasCode) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      code!,
                      style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(time, style: TextStyle(color: AppColor.greyColor, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildAIMessage(String name, String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 18, backgroundColor: AppColor.primaryColor, child: Icon(Icons.smart_toy_outlined, color: Colors.white, size: 18)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: AppColor.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(color: AppColor.primaryColor.withOpacity(0.1)),
                ),
                child: Text(text, style: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 4),
              Text(time, style: TextStyle(color: AppColor.greyColor, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
