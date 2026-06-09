import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/Colors/colors.dart';

class PythonChannelScreen extends StatelessWidget {
  const PythonChannelScreen({super.key});

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
        title: const Text('#Python', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.people_outline, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.backgroundDark,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '#Python',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Python programming — tips, questions, and projects',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '1,243 members',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Leave', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pinned Message
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFFFF9E6),
            child: Row(
              children: [
                const Icon(Icons.push_pin, color: Colors.orange, size: 16),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Pinned: Welcome to #Python! Read the rules.',
                    style: TextStyle(color: Colors.brown, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // Feed
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildChannelPost(
                  userName: 'Sarah Chen',
                  time: '2h ago',
                  content: 'Just discovered a really clean way to handle nested dictionary updates using recursive merges. Has anyone else found this useful in large-scale data processing? 🐍',
                  hasCode: true,
                  code: 'def deep_merge(d1, d2):\n  for k, v in d2.items():\n    if k in d1 and isinstance(d1[k], dict):\n      deep_merge(d1[k], v)\n    else:\n      d1[k] = v',
                  likes: 24,
                  comments: 8,
                ),
                _buildChannelPost(
                  userName: 'Dev_Marcus',
                  time: '5h ago',
                  content: 'Working on a new data visualization dashboard using Streamlit and Plotly. The speed of development in Python is honestly unmatched. What\'s your favorite viz library?',
                  hasImage: true,
                  likes: 56,
                  comments: 12,
                ),
                _buildChannelPost(
                  userName: 'Alice_Dev',
                  time: '8h ago',
                  content: 'Question for the experts: How are we feeling about the latest type hinting PEP? I\'m finding it makes my IDE much happier, but some team members think it\'s too verbose. Thoughts?',
                  chips: ['type-hints', 'best-practices'],
                  likes: 18,
                  comments: 31,
                ),
              ],
            ),
          ),

          // Bottom Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColor.lightGreyColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Post to #python...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.send_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelPost({
    required String userName,
    required String time,
    required String content,
    bool hasCode = false,
    String? code,
    bool hasImage = false,
    List<String>? chips,
    required int likes,
    required int comments,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColor.lightGreyColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$userName')),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text('#Python', style: TextStyle(color: AppColor.primaryColor, fontSize: 11)),
                    ],
                  ),
                ),
                Text(time, style: const TextStyle(color: AppColor.greyColor, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 12),
            Text(content, style: const TextStyle(fontSize: 14, height: 1.4)),
            if (hasCode) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF24292E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  code!,
                  style: const TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
            if (hasImage) ...[
              const SizedBox(height: 12),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://picsum.photos/600/400?python'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
            if (chips != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: chips.map((chip) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(chip, style: const TextStyle(color: AppColor.primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
                )).toList(),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.favorite_border, size: 18, color: AppColor.greyColor),
                const SizedBox(width: 4),
                Text('$likes', style: const TextStyle(color: AppColor.greyColor, fontSize: 12)),
                const SizedBox(width: 16),
                const Icon(Icons.chat_bubble_outline, size: 18, color: AppColor.greyColor),
                const SizedBox(width: 4),
                Text('$comments', style: const TextStyle(color: AppColor.greyColor, fontSize: 12)),
                const Spacer(),
                const Icon(Icons.share_outlined, size: 18, color: AppColor.greyColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
