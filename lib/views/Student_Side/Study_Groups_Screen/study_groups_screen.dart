import 'package:flutter/material.dart';
import '../../../res/Colors/colors.dart';

class StudyGroupsScreen extends StatelessWidget {
  const StudyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: AppColor.blackColor),
        title: const Text(
          'Study Groups',
          style: TextStyle(color: AppColor.blackColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          const Icon(Icons.search, color: AppColor.blackColor),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Toggle
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColor.lightGreyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                          ],
                        ),
                        child: const Center(
                          child: Text('My Groups', style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Center(
                          child: Text('Discover', style: TextStyle(color: AppColor.greyColor)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // My Groups
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMyGroupCard(
                    title: 'Python Fundamentals',
                    subtitle: 'Weekly practice and problem solving',
                    members: '8/20 members',
                    day: 'Every Monday',
                    time: '7:00 PM',
                    badge: 'Next session in 2 days',
                    badgeColor: Colors.blue.withOpacity(0.1),
                    icon: Icons.code,
                  ),
                  _buildMyGroupCard(
                    title: 'CCNA Prep Group',
                    subtitle: 'Routing, Switching & Network security',
                    members: '12/20 members',
                    day: 'Every Wednesday',
                    time: '6:00 PM',
                    badge: 'Next session tomorrow',
                    badgeColor: Colors.orange.withOpacity(0.1),
                    icon: Icons.language,
                  ),
                ],
              ),
            ),
            
            // Discover more
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Discover more groups',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildDiscoverGroupCard(
                title: 'AWS Certified Solutions',
                subtitle: 'Exam prep for Associate level',
                members: '45/100 members',
                day: 'Thursdays',
                isNew: true,
                icon: Icons.cloud_queue,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColor.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMyGroupCard({
    required String title,
    required String subtitle,
    required String members,
    required String day,
    required String time,
    required String badge,
    required Color badgeColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColor.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: AppColor.primaryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subtitle, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconInfo(Icons.people_outline, members),
              _buildIconInfo(Icons.calendar_today_outlined, day),
              _buildIconInfo(Icons.access_time, time),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
                child: Text(badge, style: const TextStyle(color: AppColor.primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: AppColor.primaryColor),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: const Text('Open Chat', style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverGroupCard({
    required String title,
    required String subtitle,
    required String members,
    required String day,
    required IconData icon,
    bool isNew = false,
  }) {
    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: Colors.orange, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        if (isNew) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: const Text('NEW', style: TextStyle(color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                    Text(subtitle, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildIconInfo(Icons.people_outline, members),
              const SizedBox(width: 24),
              _buildIconInfo(Icons.calendar_today_outlined, day),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Avatar group placeholder
              const Align(
                widthFactor: 0.6,
                child: CircleAvatar(radius: 12, backgroundColor: Colors.blueGrey),
              ),
              const CircleAvatar(radius: 12, backgroundColor: Colors.indigo),
              const SizedBox(width: 8),
              const Text('+42', style: TextStyle(fontSize: 10, color: AppColor.greyColor)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                ),
                child: const Text('Join Group', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColor.greyColor),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: AppColor.greyColor, fontSize: 11)),
      ],
    );
  }
}
