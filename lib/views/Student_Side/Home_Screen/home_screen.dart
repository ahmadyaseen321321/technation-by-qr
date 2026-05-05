import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/Colors/colors.dart';
import '../../../res/components/side_drawer.dart';
import 'python_channel_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.backgroundDark,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'TechNation Hub',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Categories
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategory('All', isActive: true, onTap: () {}),
                _buildCategory('Python', onTap: () => Get.to(() => const PythonChannelScreen())),
                _buildCategory('Networking', onTap: () {}),
                _buildCategory('Cybersecurity', onTap: () {}),
                _buildCategory('Cloud Arch', onTap: () {}),
              ],
            ),
          ),
          
          // Feed
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildPostCard(
                  userName: 'Alex Rivera',
                  userHandle: '@arivera_dev',
                  role: 'CLOUD ARCH',
                  time: '2h ago',
                  content: 'Just implemented a new CI/CD pipeline using GitHub Actions and Terraform. The speed improvement for our staging deployments is nearly 40%. Check out this logic snippet:',
                  hasCode: true,
                  codeContent: 'jobs:\n  deploy:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v2\n      - name: Terraform Init\n        run: terraform init',
                  likes: '124',
                  comments: '18',
                ),
                _buildPostCard(
                  userName: 'Jordan Smith',
                  userHandle: '@js_secure',
                  role: 'CYBERSEC',
                  time: '5h ago',
                  content: 'Finally completed the advanced network penetration testing labs. The complexity of modern zero-trust environments is fascinating. Secure your perimeters!',
                  hasImage: true,
                  imageCount: 2,
                  likes: '89',
                  comments: '4',
                ),
                _buildPostCard(
                  userName: 'Sarah Chen',
                  userHandle: '@schen_ai',
                  role: 'AI/ML',
                  time: '8h ago',
                  content: 'Experimenting with the latest OpenClaw LLM release. The reasoning capabilities for debugging React hooks are surprisingly nuanced. Has anyone else tried the zero-shot prompting on legacy codebases?',
                  likes: '256',
                  comments: '42',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String text, {bool isActive = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isActive ? AppColor.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? AppColor.primaryColor : AppColor.lightGreyColor),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : AppColor.blackColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildPostCard({
    required String userName,
    required String userHandle,
    required String role,
    required String time,
    required String content,
    bool hasCode = false,
    String? codeContent,
    bool hasImage = false,
    int imageCount = 0,
    required String likes,
    required String comments,
  }) {
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
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$userName'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(role, style: const TextStyle(color: AppColor.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Text(userHandle, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
                    ],
                  ),
                ),
                Text(time, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            
            // Post Content
            Text(content, style: const TextStyle(fontSize: 14, height: 1.4)),
            const SizedBox(height: 16),
            
            // Code Snippet
            if (hasCode)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  codeContent!,
                  style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            
            // Images
            if (hasImage)
              Row(
                children: List.generate(imageCount, (index) => Expanded(
                  child: Container(
                    height: 150,
                    margin: EdgeInsets.only(right: index < imageCount - 1 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage('https://picsum.photos/400/300'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )),
              ),
              
            const SizedBox(height: 16),
            
            // Interaction Row
            Row(
              children: [
                _buildInteractionItem(Icons.thumb_up_outlined, likes),
                const SizedBox(width: 16),
                _buildInteractionItem(Icons.chat_bubble_outline, comments),
                const SizedBox(width: 16),
                const Icon(Icons.share_outlined, color: AppColor.greyColor, size: 20),
                const Spacer(),
                const Icon(Icons.bookmark_border, color: AppColor.greyColor, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionItem(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, color: AppColor.greyColor, size: 20),
        const SizedBox(width: 4),
        Text(count, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
      ],
    );
  }
}
