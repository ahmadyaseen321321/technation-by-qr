import 'package:flutter/material.dart';
import '../../../res/Colors/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundDark,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('TechNation Hub', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          const Icon(Icons.more_vert, color: Colors.white),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=ahmad'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: AppColor.primaryColor, shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: AppColor.primaryColor),
                        ),
                        child: const Text('Edit Profile', style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ahmad Raza',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.blackColor),
                  ),
                  const Text(
                    '@ahmadraza',
                    style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Flutter developer & AI enthusiast. Learning every day 🚀 Open to opportunities.',
                    style: TextStyle(color: AppColor.greyColor, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildSkillTag('Python'),
                      _buildSkillTag('Flutter'),
                      _buildSkillTag('Networking'),
                      _buildSkillTag('Web Dev'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('47', 'POSTS'),
                      _buildDivider(),
                      _buildStatItem('134', 'REPLIES'),
                      _buildDivider(),
                      _buildStatItem('23', 'FOLLOWING'),
                      _buildDivider(),
                      _buildStatItem('89', 'FOLLOWERS'),
                    ],
                  ),
                ],
              ),
            ),
            
            // OpenClaw Action
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.smart_toy_outlined, color: AppColor.primaryColor),
                label: const Text('Ask OpenClaw about this member', style: TextStyle(color: AppColor.primaryColor)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildProfileTab('Posts', isActive: true),
                  _buildProfileTab('Projects'),
                  _buildProfileTab('Achievements'),
                ],
              ),
            ),
            
            // Posts List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: 2,
              itemBuilder: (context, index) {
                return _buildUserPost(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColor.primaryColor, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: AppColor.greyColor, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: AppColor.lightGreyColor);
  }

  Widget _buildProfileTab(String text, {bool isActive = false}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isActive ? AppColor.primaryColor : AppColor.greyColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            color: isActive ? AppColor.primaryColor : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildUserPost(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColor.lightGreyColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=ahmad'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text('Ahmad Raza', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.verified, color: AppColor.primaryColor, size: 14),
                        ],
                      ),
                      Text(index == 0 ? '2 hours ago in #FlutterDev' : 'Yesterday in #AI_Tech', 
                        style: TextStyle(color: AppColor.greyColor, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              index == 0 
                ? 'Just implemented a complex state management solution using BLoC. The performance gains are incredible! 🚀 #Flutter #MobileDev'
                : 'Working on a new integration for OpenClaw to help students parse technical documentation faster. Stay tuned for the GitHub repo!',
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            if (index == 1) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Future<void> parseDocs() async {\n  final result = await _aiAgent.analyze(rawText);\n  print(\'Insights: \$result\');\n}',
                  style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.favorite_border, color: AppColor.greyColor, size: 18),
                const SizedBox(width: 4),
                Text(index == 0 ? '24' : '56', style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
                const SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline, color: AppColor.greyColor, size: 18),
                const SizedBox(width: 4),
                Text(index == 0 ? '8' : '12', style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
                const Spacer(),
                Icon(index == 0 ? Icons.share_outlined : Icons.bookmark_border, color: AppColor.greyColor, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
