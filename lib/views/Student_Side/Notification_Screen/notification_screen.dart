import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/Colors/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColor.backgroundDark, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read', style: TextStyle(color: AppColor.primaryColor)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        children: [
          _buildNotificationItem(
            isUnread: true,
            icon: Stack(
              children: [
                const CircleAvatar(radius: 24, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=ali')),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: AppColor.primaryColor, shape: BoxShape.circle),
                    child: const Icon(Icons.reply, color: Colors.white, size: 10),
                  ),
                ),
              ],
            ),
            title: 'Ali Hassan replied to your post',
            subtitle: '"That\'s a great point! I think TCP also..."',
            time: '2m ago',
          ),
          _buildNotificationItem(
            isUnread: true,
            icon: Stack(
              children: [
                const CircleAvatar(radius: 24, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=sara')),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: const Icon(Icons.alternate_email, color: Colors.white, size: 10),
                  ),
                ),
              ],
            ),
            title: 'Sara Ahmed mentioned you in #Python',
            subtitle: '"Ask @username, they explained this well"',
            time: '15m ago',
          ),
          _buildNotificationItem(
            icon: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppColor.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.favorite, color: AppColor.primaryColor),
            ),
            title: '5 people reacted to your post',
            time: '1h ago',
          ),
          _buildNotificationItem(
            isUnread: true,
            icon: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.business_center_outlined, color: Colors.brown),
            ),
            title: 'Job match: Flutter Developer at TechCorp',
            subtitle: 'matches your skills',
            time: '3h ago',
          ),
          _buildNotificationItem(
            icon: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppColor.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.smart_toy_outlined, color: AppColor.primaryColor),
            ),
            title: 'OpenClaw: Your Python quiz results are ready!',
            time: '5h ago',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    bool isUnread = false,
    required Widget icon,
    required String title,
    String? subtitle,
    required String time,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isUnread ? AppColor.primaryColor.withOpacity(0.02) : Colors.transparent,
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              color: isUnread ? AppColor.primaryColor : Colors.transparent,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    icon,
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                            ],
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(color: Colors.grey[600], fontSize: 13, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
